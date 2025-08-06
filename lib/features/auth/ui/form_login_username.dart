import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/auth_controller.dart';

class FormLoginUsername extends ConsumerStatefulWidget {
  const FormLoginUsername({super.key});

  @override
  ConsumerState<FormLoginUsername> createState() => _FormLoginUsernameState();
}

class _FormLoginUsernameState extends ConsumerState<FormLoginUsername> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return // Login Form Section
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Akathospital application',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Please Login to Your Account',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Email Input Field
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'ชื่อผู้ใช้งาน',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.mail_outline, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Password Input Field
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'รหัสผ่าน',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forget Password',
                style: TextStyle(
                  color: Color(0xFFFC658A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Login Button
          ElevatedButton(
            onPressed: () {
              final username = _usernameController.text.trim();
              final password = _passwordController.text.trim();
              if (username.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('กรุณากรอกชื่อผู้ใช้และรหัสผ่าน'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              ref
                  .read(authControllerProvider.notifier)
                  .loginWithUser(username, password);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFFE579C), Color(0xFFFE8B73)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                constraints: const BoxConstraints(minHeight: 50.0),
                alignment: Alignment.center,
                child: const Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Or Login using Social Media Account',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Social Media Icons
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     // Social media icons placeholders
          //     _buildSocialIcon(
          //         'assets/facebook_icon.png'), // Replace with your icon paths
          //     _buildSocialIcon('assets/google_icon.png'),
          //     _buildSocialIcon('assets/twitter_icon.png'),
          //     _buildSocialIcon('assets/linkedin_icon.png'),
          //   ],
          // ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
