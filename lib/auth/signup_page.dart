import 'package:flutter/material.dart';

void main() {
  runApp(const SignUpScreen());
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFEFF9F5), // very light green background
      ),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController(text: 'John Doe');
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? selectedSchool;

  final List<String> schools = [
    'Select your school',
    'Greenwood High',
    'Riverdale College',
    'Eco University',
    'Springfield School'
  ];

  @override
  void initState() {
    super.initState();
    selectedSchool = schools[0];
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool get isCreateAccountEnabled {
    return _formKey.currentState?.validate() == true && selectedSchool != schools[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image container (example placeholder)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.local_florist, size: 48, color: Colors.green),
                      SizedBox(height: 8),
                      Text(
                        'Eco',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join our community and start your eco-journey!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        hintText: 'John Doe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter full name' : null,
                    ),
                    const SizedBox(height: 16),

                    // Username
                    const Text('Username', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Choose a unique username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter username' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email address
                    const Text('Email address', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'you@example.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter email address';
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter password' : null,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please confirm password';
                        if (value != passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // School/College Dropdown
                    const Text('School/College', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSchool,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: schools.map((school) {
                            return DropdownMenuItem(
                              value: school,
                              child: Text(
                                school,
                                style: TextStyle(
                                  color: school == schools[0]
                                      ? Colors.grey.shade400
                                      : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedSchool = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Create Account Button (disabled if form invalid)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isCreateAccountEnabled
                            ? () {
                          if (_formKey.currentState!.validate()) {
                            // Perform create account logic here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Creating account...')),
                            );
                          }
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade200,
                          disabledBackgroundColor: Colors.green.shade100,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Create Account'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          // Handle sign-up navigation or action here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sign Up pressed')),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Login prompt
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already a member? ',
                          style: const TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Log in',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              recognizer: null, // You can add TapGestureRecognizer for tap action
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}