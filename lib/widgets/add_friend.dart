import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class AddFriend extends StatefulWidget {
  final Function addFriend;
  const AddFriend({super.key, required this.addFriend});

  // final Map<String, dynamic> searchedData = {};

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  final emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Add Friends'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              BoxDecoration(border: Border(top: BorderSide(width: 0.4))),
          // height: size.height - 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(size.height / 25),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Search Friend')),
                  // onChanged: (value) async {
                  //   inputName = value;
                  //   await database
                  //       .collection('users')
                  //       .where('email', isGreaterThanOrEqualTo: inputName)
                  //       .get()
                  //       .then((value) {
                  //     for (int i = 0; i <= value.docs.length; i++) {
                  //       widget.searchedData.addEntries(value.docs);
                  //     }
                  //   });
                  // },
                  controller: emailController,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.addFriend(emailController.text, auth.currentUser!.uid);
                  Navigator.pop(context);
                },
                child: const Text('Search'),
              ),
              // Container(
              //   child: ListView.builder(
              //     itemBuilder: (context, index) {},
              //     itemCount: 1,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
