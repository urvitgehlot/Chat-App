import 'package:chat_app/screens/authenticator_screen.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/profile_complete_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkLoginStatus() async {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      final database = FirebaseFirestore.instance;

      bool isCompletedProfile = await database
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => value.exists);

      if (!context.mounted) return;

      if (isCompletedProfile) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ProfileComplete(),
        ));
      }
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Authenticator(),
      ));
    }
  }

  @override
  void initState() {
    checkLoginStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Image.asset(
          height: size.width / 1.4,
          'assets/images/ug.png',
        ),
      ),
    );
  }
}
