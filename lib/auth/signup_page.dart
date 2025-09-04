import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart'; // Add this line
import '../main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:confetti/confetti.dart';

// Note: To use the Pinput widget, you'll need to add the dependency to your pubspec.yaml file:
// dependencies:
//   pinput: ^4.0.0

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // --- Controllers ---
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --- State variables ---
  File? _profileImageFile;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  Timer? _debounce;
  String? _usernameError;
  bool _isCheckingUsername = false;

  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confettiController.dispose();
    _animationController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Theme.of(context).colorScheme.error : Colors.green,
    ));
  }

  void _onUsernameChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_usernameController.text.isNotEmpty) {
        _checkUsernameUniqueness(_usernameController.text.trim());
      }
    });
  }

  Future<void> _checkUsernameUniqueness(String username) async {
    setState(() {
      _isCheckingUsername = true;
      _usernameError = null;
    });

    try {
      final result = await supabase
          .from('profiles')
          .select('id')
          .eq('username', username)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _usernameError = result != null ? 'Username is already taken.' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _usernameError = 'Error checking username.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingUsername = false;
        });
      }
    }
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => _profileImageFile = File(pickedFile.path));
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      _showMessage('Please fill all required fields correctly.', isError: true);
      return;
    }
    if (_profileImageFile == null) {
      _showMessage('Please select a profile picture.', isError: true);
      return;
    }
    if (_usernameError != null) {
      _showMessage('Please choose a different username.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Sign up user and pass metadata for the trigger.
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          'full_name': _fullNameController.text.trim(),
          'username': _usernameController.text.trim(),
          'phone_number': _phoneController.text.trim(),
        },
      );

      final user = response.user;

      if (mounted && user != null) {
        // Step 2: Upload profile picture.
        final image = _profileImageFile!;
        final imageExtension = image.path.split('.').last.toLowerCase();
        final imagePath = '${user.id}/profile.$imageExtension';

        await supabase.storage.from('avatars').upload(
          imagePath,
          image,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

        // Step 3: Get the public URL.
        final imageUrl = supabase.storage.from('avatars').getPublicUrl(imagePath);

        // Step 4: Update profile with the avatar URL and test password.
        await supabase.from('profiles').update({
          'avatar_url': imageUrl,
          'password_plaintext_test_only': _passwordController.text.trim(),
        }).eq('id', user.id);

        _showSuccessDialog();
      }
    } on AuthException catch (error) {
      _showMessage(error.message, isError: true);
    } on StorageException catch (error) {
      _showMessage('Storage Error: ${error.message}', isError: true);
    } on PostgrestException catch (error) {
      _showMessage('Database Error: ${error.message}', isError: true);
    }
    catch (e) {
      _showMessage('An unexpected error occurred.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Stack(
        alignment: Alignment.topCenter,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Account Created!', textAlign: TextAlign.center),
            content: const Text('Please check your email to verify your account before logging in.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: const Text('Continue to Login'),
              ),
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Create Your EcoGames Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1220),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start your eco-journey with us.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7481),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildProfilePicturePicker(),
                  const SizedBox(height: 24),

                  _buildFullNameField(),
                  _buildUsernameField(),
                  _buildEmailField(),
                  _buildContactField(),
                  _buildPasswordField(),
                  _buildConfirmPasswordField(),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06A906),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSignInLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---
  Widget _buildProfilePicturePicker() => Center(child: Stack(alignment: Alignment.center, children: [AnimatedBuilder(animation: _animation, builder: (context, child) => CustomPaint(size: const Size(140, 140), painter: CircularProgressPainter(progress: _animation.value))), CircleAvatar(radius: 60, backgroundColor: Colors.grey[200], backgroundImage: _profileImageFile != null ? FileImage(_profileImageFile!) : null, child: _profileImageFile == null ? Icon(Icons.person, size: 60, color: Colors.grey[400]) : null), Positioned(bottom: 0, right: 0, child: GestureDetector(onTap: _pickProfileImage, child: CircleAvatar(radius: 20, backgroundColor: const Color(0xFF03845D), child: const Icon(Icons.camera_alt, color: Colors.white, size: 22))))]));

  InputDecoration _getInputDecoration({required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF6B7481),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildFullNameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _fullNameController,
        decoration: _getInputDecoration(hintText: 'Full Name (Optional)', icon: Icons.person_outline),
      ),
    );
  }

  Widget _buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _usernameController,
        decoration: _getInputDecoration(hintText: 'Username', icon: Icons.alternate_email).copyWith(
          errorText: _usernameError,
          suffixIcon: _isCheckingUsername
              ? const Padding(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator(strokeWidth: 2))
              : (_usernameError == null && _usernameController.text.isNotEmpty ? const Icon(Icons.check, color: Colors.green) : null),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter a username';
          if (_usernameError != null) return 'Username is not available';
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _emailController,
        decoration: _getInputDecoration(hintText: 'example@domain.com', icon: Icons.email_outlined),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter your email';
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!emailRegex.hasMatch(value)) return 'Please enter a valid email address';
          return null;
        },
      ),
    );
  }

  Widget _buildContactField() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.8),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text(
              'Contact Number (Optional)',
              style: TextStyle(color: const Color(0xFF6B7481).withOpacity(0.9), fontSize: 14),
            ),
          ),
          Pinput(
            controller: _phoneController,
            length: 10,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyDecorationWith(
              border: Border.all(color: const Color(0xFF03845D)),
            ),
            submittedPinTheme: defaultPinTheme,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() => Padding(padding: const EdgeInsets.only(bottom: 16.0), child: TextFormField(controller: _passwordController, obscureText: !_isPasswordVisible, decoration: _getInputDecoration(hintText: 'Password', icon: Icons.lock_outline).copyWith(suffixIcon: IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF6B7481)), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible))), validator: (value) => (value == null || value.length < 6) ? 'Password must be at least 6 characters' : null));
  Widget _buildConfirmPasswordField() => Padding(padding: const EdgeInsets.only(bottom: 16.0), child: TextFormField(controller: _confirmPasswordController, obscureText: !_isPasswordVisible, decoration: _getInputDecoration(hintText: 'Confirm Password', icon: Icons.lock_person_outlined), validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null));
  Widget _buildSignInLink(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Already have an account? ", style: TextStyle(color: Color(0xFF6B7481), fontWeight: FontWeight.w400, fontSize: 14)), GestureDetector(onTap: () => Navigator.pushReplacementNamed(context, '/login'), child: const Text('Sign In', style: TextStyle(color: Color(0xFF03845D), fontWeight: FontWeight.bold, fontSize: 14, decoration: TextDecoration.underline)))]);
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  CircularProgressPainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green.withOpacity(0.8)..style = PaintingStyle.stroke..strokeWidth = 6.0..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2), -90 * (3.1415926535 / 180), 360 * progress * (3.1415926535 / 180), false, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

