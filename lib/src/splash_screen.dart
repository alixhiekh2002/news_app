import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gmaps/src/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/splash_pic.jpg",
              fit: BoxFit.cover,
              height: height * .5,
            ),
            SizedBox(
              height: height * .04,
            ),
            Text("TOP HEADLINES",
                style: TextStyle(
                  color: Colors.grey.shade700,
                )),
            SizedBox(
              height: height * .04,
            ),
            SpinKitChasingDots(
              color: Colors.purple,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
