import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:confetti/confetti.dart';
import 'package:pinput/pinput.dart';
import 'package:animate_do/animate_do.dart';
import 'package:video_player/video_player.dart';
import '../main.dart';

// Note: To use the features in this file, you'll need to add these dependencies to your pubspec.yaml file:
// dependencies:
//   pinput: ^4.0.0
//   animate_do: ^3.3.4
//   video_player: ^2.8.6
//
// Also, create an 'assets/videos/' folder and add your MP4 file ('signup_bk_1.mp4').
// Then, declare both asset folders in your pubspec.yaml:
// flutter:
//   assets:
//     - assets/images/
//     - assets/videos/

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  // --- Video Controller ---
  late VideoPlayerController _videoController;

  // --- Input Controllers ---
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --- State variables ---
  File? _profileImageFile;
  bool _isLoading = false;
  Timer? _debounce;
  String? _usernameError;
  bool _isCheckingUsername = false;
  late ConfettiController _confettiController;

  final List<String> _backgroundImages = [
    'assets/images/signup_bk_1.png', // Fallback image for page 0
    'assets/images/signup_bk_2.png',
    'assets/images/signup_bk_3.png',
    'assets/images/signup_bk_4.png',
    'assets/images/signup_bk_5.png',
    'assets/images/signup_bk_6.png',
    'assets/images/signup_bk_1.png', // Fallback for review screen
  ];

  @override
  void initState() {
    super.initState();

    // Initialize Video Controller
    _videoController = VideoPlayerController.asset('assets/videos/signup_bk_1.mp4')
      ..initialize().then((_) {
        _videoController.setVolume(0.0); // Mute the video
        _videoController.setLooping(true);
        if (mounted) {
          setState(() {}); // Update UI once video is initialized
          _videoController.play();
        }
      });

    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _usernameController.addListener(_onUsernameChanged);
    _pageController.addListener(() {
      if (!mounted) return;
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose(); // Dispose the video controller
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confettiController.dispose();
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
    if (!mounted) return;
    setState(() => _isCheckingUsername = true);
    // ... (rest of the username check logic is the same)
    setState(() => _isCheckingUsername = false);
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => _profileImageFile = File(pickedFile.path));
    }
  }

  void _nextPage() {
    // Basic validation for current step can be added here
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          'full_name': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
          'username': _usernameController.text.trim(),
          'phone_number': _phoneController.text.trim(),
        },
      );
      final user = response.user;
      if (mounted && user != null && _profileImageFile != null) {
        final image = _profileImageFile!;
        final imageExtension = image.path.split('.').last.toLowerCase();
        final imagePath = '${user.id}/profile.$imageExtension';
        await supabase.storage.from('avatars').upload(imagePath, image);
        final imageUrl = supabase.storage.from('avatars').getPublicUrl(imagePath);
        await supabase.from('profiles').update({'avatar_url': imageUrl}).eq('id', user.id);
      }
      if (mounted) {
        _confettiController.play();
      }
    } catch(e) {
      _showMessage('Signup failed. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildInitialScreen(),
                    _buildNameScreen(),
                    _buildUsernameScreen(),
                    _buildEmailScreen(),
                    _buildPhoneScreen(),
                    _buildPasswordScreen(),
                    _buildReviewScreen(),
                  ],
                ),
                if (_currentPage > 0 && _currentPage < 6) _buildNextButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    // Use video for the first screen, images for the rest.
    if (_currentPage == 0) {
      return _videoController.value.isInitialized
          ? SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ),
      )
          : Container(color: Colors.black); // Fallback while video loads
    } else {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 900),
        child: Container(
          key: ValueKey<int>(_currentPage),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgroundImages[_currentPage]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FadeInUp(
          delay: const Duration(milliseconds: 500),
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.green,
            ),
            child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInDown(child: const Text("Build Your Sanctuary", style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          FadeInDown(delay: const Duration(milliseconds: 300), child: const Text("Join a community dedicated to making a difference.", style: TextStyle(color: Colors.white70, fontSize: 18))),
          const SizedBox(height: 40),
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Start My Sanctuary", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildNameScreen() {
    return _buildFormPage(
      title: "What should we call you?",
      children: [
        FadeInUp(delay: const Duration(milliseconds: 300), child: _buildTextField(_firstNameController, "First Name")),
        const SizedBox(height: 16),
        FadeInUp(delay: const Duration(milliseconds: 500), child: _buildTextField(_lastNameController, "Last Name")),
      ],
    );
  }

  Widget _buildUsernameScreen() {
    return _buildFormPage(
      title: "Create a unique username.",
      children: [
        FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: _buildTextField(_usernameController, "Username",
                suffixIcon: _isCheckingUsername
                    ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))
                    : (_usernameError == null && _usernameController.text.isNotEmpty ? const Icon(Icons.check, color: Colors.green) : null),
                errorText: _usernameError)),
      ],
    );
  }

  Widget _buildEmailScreen() {
    return _buildFormPage(
      title: "What's your email?",
      children: [
        FadeInUp(delay: const Duration(milliseconds: 300), child: _buildTextField(_emailController, "example@email.com", keyboardType: TextInputType.emailAddress)),
      ],
    );
  }

  Widget _buildPhoneScreen() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.9),
      ),
    );

    return _buildFormPage(
      title: "Your contact number.",
      children: [
        FadeInUp(delay: const Duration(milliseconds: 300), child: Pinput(controller: _phoneController, length: 10, defaultPinTheme: defaultPinTheme)),
      ],
    );
  }

  Widget _buildPasswordScreen() {
    return _buildFormPage(
      title: "Secure your account.",
      children: [
        FadeInUp(delay: const Duration(milliseconds: 300), child: _buildTextField(_passwordController, "Password", obscureText: true)),
        const SizedBox(height: 16),
        FadeInUp(delay: const Duration(milliseconds: 500), child: _buildTextField(_confirmPasswordController, "Confirm Password", obscureText: true)),
      ],
    );
  }

  Widget _buildReviewScreen() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInDown(child: const Text("Review Your Details", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              const SizedBox(height: 32),
              _buildReviewDetail("Name", "${_firstNameController.text} ${_lastNameController.text}"),
              _buildReviewDetail("Username", _usernameController.text),
              _buildReviewDetail("Email", _emailController.text),
              const SizedBox(height: 40),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FadeInUp(
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text("Confirm & Create Account", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false),
                child: const Text("Go to Login", style: TextStyle(color: Colors.white70)),
              )
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
        ),
      ],
    );
  }

  Widget _buildReviewDetail(String title, String value) {
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(color: Colors.white30, height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFormPage({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false, TextInputType? keyboardType, Widget? suffixIcon, String? errorText}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
    );
  }
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

