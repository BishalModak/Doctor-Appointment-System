import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'auth_wrapper.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/Lottie/Animation - 1749449652039.json',
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            'Medic++',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      nextScreen: const AuthWrapper(),
      splashIconSize: 400,
      backgroundColor: const Color.fromARGB(255, 107, 159, 248),
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
