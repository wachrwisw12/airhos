import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/widgets/show_sneckbar.dart';
import '../controller/auth_controller.dart';
import 'form_login_username.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.isLoading == true) {
        showLoadingOverlay(context);
      } else {
        hideLoadingOverlay();
      }
      if (next.error != null && next.error!.isNotEmpty) {
        showAppSnackBar(context, next.error!, type: SnackBarType.error);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with illustration and gradient
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFE8B73),
                        Color(0xFFFC658A),
                        Color(0xFFFEE68C),
                      ],
                    ),
                  ),
                  child: Center(
                    // Placeholder for the illustration image
                    child: Image.asset(
                      'assets/images/akatlogo.png', // Replace with your image path
                      fit: BoxFit.cover,
                      height: 400,
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FormLoginUsername(),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Image.asset(assetPath, height: 24), // Use your actual icon images
    );
  }
}
