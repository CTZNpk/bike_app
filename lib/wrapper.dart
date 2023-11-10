import 'package:bike_app/features/auth/screens/auth_screen.dart';
import 'package:bike_app/features/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInWrapper extends StatefulWidget {
  const SignInWrapper({super.key});

  @override
  State<SignInWrapper> createState() => _SignInWrapperState();
}

class _SignInWrapperState extends State<SignInWrapper> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? const EmailAndPasswordSignIn()
        : const HomeScreen();
  }
}
