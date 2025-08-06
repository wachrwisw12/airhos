import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoOpacity = 0.0;
  @override
  void initState() {
    super.initState();

    // เริ่ม fade-in หลังจากโหลดหน้านี้
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      setState(() {
        _logoOpacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _SplashContent(),
      ),
    );
  }
}

class _SplashContent extends StatefulWidget {
  const _SplashContent({super.key});

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent> {
  double _logoOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _logoOpacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: _logoOpacity,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: Image.asset(
            'assets/images/akatlogo.png',
            width: 300,
            height: 300,
          ),
        ),
        const SizedBox(height: 24),
        DefaultTextStyle(
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Akathos',
                speed: Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
            pause: Duration(milliseconds: 500),
            displayFullTextOnTap: true,
          ),
        ),
        const SizedBox(height: 24),
        // const CircularProgressIndicator(),
      ],
    );
  }
}
