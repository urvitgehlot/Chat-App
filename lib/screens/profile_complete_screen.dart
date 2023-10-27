import 'dart:io';

import 'package:chat_app/screens/authenticator_screen.dart';
import 'package:chat_app/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileComplete extends StatefulWidget {
  const ProfileComplete({super.key});

  @override
  State<ProfileComplete> createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final aboutMeController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  late File _image;

  bool isImage = false;
  // Widget img = const Icon(
  //   Icons.image_outlined,
  //   size: 80,
  // );

  Future<void> createProfile(
    String firstName,
    String lastName,
    String aboutMe,
  ) async {
    if (firstName.trim().isEmpty ||
        lastName.trim().isEmpty ||
        aboutMe.trim().isEmpty) return;

    try {
      auth.currentUser!.updateDisplayName("$firstName $lastName");
      if (isImage) {
        var img = storage.ref('dp/${auth.currentUser!.uid}.jpg');
        await img.putFile(_image);
        await database.collection('users').doc(auth.currentUser!.uid).set({
          'firstname': firstName,
          'lastname': lastName,
          'aboutme': aboutMe,
          'status': 'offline',
          'friends': [],
          'email': auth.currentUser!.email,
          'uid': auth.currentUser!.uid,
          'dp': img.fullPath
        });
      } else {
        await database.collection('users').doc(auth.currentUser!.uid).set({
          'firstname': firstName,
          'lastname': lastName,
          'aboutme': aboutMe,
          'status': 'offline',
          'email': auth.currentUser!.email,
          'uid': auth.currentUser!.uid,
          'dp': ''
        });
      }
    } catch (e) {
      print('Fir Se Error');
    }
  }

  void pickFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // print(_image.path);
      setState(() {
        _image = File(pickedImage.path);
        isImage = true;
        // img =
      });
    }
  }

  void pickFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      // print(_image.path);
      setState(() {
        _image = File(pickedImage.path);
        isImage = true;
        // img =
      });
    }
  }

  void removeDp() {
    setState(() {
      _image = File('');
      isImage = false;
      // img = const Icon(
      //   Icons.image_outlined,
      //   size: 80,
      // );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    auth.signOut;
    print('object');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(221, 230, 231, 1),
        title: const Text('Complete Profile'),
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut();

                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => const Authenticator(),
                  ),
                );
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: const Color.fromRGBO(136, 178, 181, 1),
                        context: context,
                        builder: (ctx) {
                          return Container(
                            height: size.width / 5 + 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: size.width / 5,
                                  height: size.width / 5,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(217, 217, 217, 1),
                                    borderRadius: BorderRadius.circular(
                                        (size.width / 5) / 2),
                                  ),
                                  child: IconButton(
                                    iconSize: size.width / 7,
                                    color: Color.fromRGBO(41, 45, 50, 1),
                                    onPressed: () async {
                                      final imagePicker = ImagePicker();
                                      XFile? pickedImaged =
                                          await imagePicker.pickImage(
                                              source: ImageSource.camera);

                                      if (pickedImaged == null) return;

                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();

                                      setState(() {
                                        _image = File(pickedImaged.path);
                                        isImage = true;
                                      });
                                    },
                                    icon: const Icon(Icons.camera_alt),
                                  ),
                                ),
                                Container(
                                  width: size.width / 5,
                                  height: size.width / 5,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(217, 217, 217, 1),
                                    borderRadius: BorderRadius.circular(
                                        (size.width / 5) / 2),
                                  ),
                                  child: IconButton(
                                    iconSize: size.width / 7,
                                    color: Color.fromRGBO(41, 45, 50, 1),
                                    onPressed: () async {
                                      final imagePicker = ImagePicker();
                                      XFile? pickedImaged =
                                          await imagePicker.pickImage(
                                              source: ImageSource.gallery);

                                      if (pickedImaged == null) return;

                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();

                                      setState(() {
                                        _image = File(pickedImaged.path);
                                        isImage = true;
                                      });
                                    },
                                    icon: const Icon(Icons.photo_library),
                                  ),
                                ),
                                Container(
                                  width: size.width / 5,
                                  height: size.width / 5,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(217, 217, 217, 1),
                                    borderRadius: BorderRadius.circular(
                                        (size.width / 5) / 2),
                                  ),
                                  child: IconButton(
                                    iconSize: size.width / 7,
                                    color: Color.fromRGBO(41, 45, 50, 1),
                                    onPressed: () async {
                                      if (!isImage) return;

                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();

                                      setState(() {
                                        isImage = false;
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: size.height / 15),
                    height: size.width / 3,
                    width: size.width / 3,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(136, 178, 181, 1),
                    ),
                    child: isImage
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(_image, fit: BoxFit.cover),
                            ),
                          )
                        : const Icon(
                            Icons.image_outlined,
                            size: 80,
                          ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: size.height / 3,
                  // width: size.width / 1.3,
                  margin: EdgeInsets.symmetric(
                      horizontal: 35, vertical: size.height / 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          label: Text('First Name'),
                        ),
                      ),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          label: Text('Last Name'),
                        ),
                      ),
                      TextField(
                        controller: aboutMeController,
                        decoration: InputDecoration(
                          label: Text('Bio'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height / 18),
                  child: GestureDetector(
                    onTap: () {
                      createProfile(
                        firstNameController.text,
                        lastNameController.text,
                        aboutMeController.text,
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height / 15,
                      width: size.width / 1.2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
