import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const UserProfileScreen(this.user, {super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Map<String, dynamic> user;
  Future<String?> getUserDp() async {
    final storage = FirebaseStorage.instance;

    if (widget.user['dp'].toString().isEmpty) return null;

    String imgUrl = await storage.ref(widget.user['dp']).getDownloadURL();

    return imgUrl;
  }

  @override
  void initState() {
    // TODO: implement initState
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 7),
              child: Stack(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: FutureBuilder(
                          future: getUserDp(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.network(snapshot.data!);
                            } else {
                              return Image.asset('assets/images/user.png');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromRGBO(104, 136, 143, 1),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(
                '${user['firstname'].toString().trim()} ${user['lastname'].toString().trim()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 30),
              constraints: BoxConstraints(minWidth: 150, maxWidth: 400),
              // color: Colors.grey,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child:
                            Image.asset('assets/images/user.png', height: 20),
                      ),
                      Expanded(
                        child: Text(
                          "${user['firstname'].toString().trim()} ${user['lastname'].toString().trim()}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Color.fromRGBO(104, 136, 143, 1)),
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ]),
                  ),
                  Positioned(
                    left: 17,
                    top: 0,
                    child: Container(
                      // width: ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      child: Text('Name'),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 30),
              constraints: BoxConstraints(minWidth: 150, maxWidth: 400),
              // color: Colors.grey,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Image.asset('assets/images/user info.png',
                            height: 20),
                      ),
                      Expanded(
                        child: Text(
                          "${user['aboutme']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Color.fromRGBO(104, 136, 143, 1)),
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ]),
                  ),
                  Positioned(
                    left: 17,
                    top: 0,
                    child: Container(
                      // width: ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      child: Text('About Me'),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 30),
              constraints: BoxConstraints(minWidth: 150, maxWidth: 400),
              // color: Colors.grey,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child:
                            Image.asset('assets/images/email.png', height: 20),
                      ),
                      Expanded(
                        child: Text(
                          user["email"].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Color.fromRGBO(104, 136, 143, 1)),
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ]),
                  ),
                  Positioned(
                    left: 17,
                    top: 0,
                    child: Container(
                      // width: ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      child: Text('Email'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
