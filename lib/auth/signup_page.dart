import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:image_picker/image_picker.dart';

final supabase = Supabase.instance.client;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isCheckingUsername = false;
  String? _usernameError;

  late VideoPlayerController _videoController;
  late ConfettiController _confettiController;
  File? _profileImageFile;

  @override
  void initState() {
    super.initState();

    _videoController =
    VideoPlayerController.asset('assets/videos/signup_bk_1.mp4')
      ..initialize().then((_) {
        _videoController.setVolume(0.0);
        _videoController.setLooping(true);
        if (mounted) {
          setState(() {});
          _videoController.play();
        }
      });

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _videoController.dispose();
    _confettiController.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // 📌 Pick profile image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImageFile = File(picked.path);
      });
    }
  }

  // 📌 Check if username already exists
  Future<void> _checkUsernameUniqueness(String username) async {
    if (!mounted) return;
    setState(() => _isCheckingUsername = true);

    try {
      final response = await supabase
          .from('profiles')
          .select('username')
          .eq('username', username)
          .maybeSingle();

      if (response != null) {
        setState(() {
          _usernameError = 'This username is already taken.';
        });
      } else {
        setState(() {
          _usernameError = null;
        });
      }
    } catch (e) {
      setState(() {
        _usernameError = 'Error checking username.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingUsername = false;
        });
      }
    }
  }

  // 📌 Handle SignUp
  Future<void> _signUp() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      _showMessage("Passwords do not match", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Create the user in Supabase auth
      final AuthResponse res = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = res.user;
      if (user == null) throw Exception('User creation failed.');

      String? avatarUrl;

      // Step 2: Upload the user's profile image if one was selected
      if (_profileImageFile != null) {
        final image = _profileImageFile!;
        final imageExtension = image.path.split('.').last.toLowerCase();
        final imagePath = '${user.id}/profile.$imageExtension';

        await supabase.storage.from('avatars').upload(
          imagePath,
          image,
          fileOptions: const FileOptions(upsert: true),
        );

        avatarUrl = supabase.storage.from('avatars').getPublicUrl(imagePath);
      }

      // Step 3: Insert the user's profile data into the 'profiles' table
      await supabase.from('profiles').upsert({
        'id': user.id,
        'full_name':
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'avatar_url': avatarUrl,
      });

      // Step 4: Success 🎉
      if (mounted) {
        _confettiController.play();
        _showMessage('Sign up successful! Welcome!');
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/app');
          }
        });
      }
    } on AuthException catch (e) {
      _showMessage(e.message, isError: true);
    } catch (e) {
      _showMessage('An error occurred: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 📌 Show messages
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // =================== UI ===================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Background
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          // Grey overlay
          Container(color: Colors.black.withOpacity(0.6)),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),

          // SignUp Form
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    FadeInDown(
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile Image Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white24,
                        backgroundImage: _profileImageFile != null
                            ? FileImage(_profileImageFile!)
                            : null,
                        child: _profileImageFile == null
                            ? const Icon(Icons.camera_alt,
                            color: Colors.white, size: 40)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // First & Last name
                    _buildTextField(
                      controller: _firstNameController,
                      hintText: "First Name",
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _lastNameController,
                      hintText: "Last Name",
                    ),
                    const SizedBox(height: 15),

                    // Username
                    _buildTextField(
                      controller: _usernameController,
                      hintText: "Username",
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          _checkUsernameUniqueness(val);
                        }
                      },
                      errorText: _usernameError,
                    ),
                    if (_isCheckingUsername)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(),
                      ),
                    const SizedBox(height: 15),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),

                    // Phone
                    _buildTextField(
                      controller: _phoneController,
                      hintText: "Phone Number",
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),

                    // Password
                    _buildTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Signup Button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Already have account? Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 📌 Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? errorText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        errorText: errorText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
