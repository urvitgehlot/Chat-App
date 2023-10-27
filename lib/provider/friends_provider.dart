// import 'dart:ffi';

// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sqflite/sqflite.dart' as sql;
import 'package:firebase_auth/firebase_auth.dart';

// final database = FirebaseFirestore.instance;
// final auth = FirebaseAuth.instance;

final friendsProvider = Provider((ref) {
  // List<dynamic> friendsEmail = [];
  // void getFriendsEmail() async {
  //   await database
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     // print('PRinting type');
  //     // print(value['friends'].runtimeType);
  //     friendsEmail = value['friends'];
  //   });
  // }

  // getFriendsEmail();

  return Friends();
});

class Friends {
  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  List<String> friendsList = [];

  Friends() {
    database.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      List<String> tempEmail = [];
      for (int i = 0; i < value['friends'].length; i++) {
        tempEmail.add(value['friends'][i]);
      }
      friendsList = tempEmail;
    });
  }

  List<String> getFriendsList() {
    return friendsList;
  }
}

class FriendsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FriendsNotifier() : super([]);

  // List<Map<String, dynamic>> friendsGet() {
  //   ref
  //   for(int i;i<)
  //   return [];
  // }

  void friendsupdate(String n) {
    state = [
      ...state,
      {n: n}
    ];
    print(n);
  }
}

final friendsNotifier = StateNotifierProvider((ref) {
  return FriendsNotifier();

  // ref.read(friendsProvider);
});
