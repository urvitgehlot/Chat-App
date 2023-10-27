import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

final auth = FirebaseAuth.instance;
// final database = FirebaseDatabase.instance;
final db = FirebaseFirestore.instance;

void create_user_login({
  required BuildContext context,
  required String email,
  required String password,
  required String fullname,
}) async {
  try {
    print('object');
    var p = await db
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) => value.docs.isEmpty);
    if (p) {
      auth.createUserWithEmailAndPassword(email: email, password: password);
    }
    // if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(p
            ? "Account Successfully Created"
            : "Account Already Exist with this email")));
  } catch (e) {
    print('object');
  }

  // da
}
