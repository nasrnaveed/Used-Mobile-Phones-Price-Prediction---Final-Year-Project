import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phone_lo/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.deepPurple,
      child: const Center(
        child: Text(
          'PhoneLo',
          style: TextStyle(
              color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}
