import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ProfileScreen(this.user, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationMuted = false;
  final database = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  bool muteNotificationSwitch = false;

  Future<String> getImage() async {
    final storage = FirebaseStorage.instance;

    String imgUrl = await storage.ref(widget.user['dp']).getDownloadURL();

    return imgUrl;
  }

  void getMutualFriends() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Profile'),
        actions: [
          GestureDetector(
            onTapDown: (details) {
              showMenu(
                shadowColor: Colors.black,
                // color: Color.fromRGBO(136, 178, 181, 1),

                color: Color.fromRGBO(143, 165, 170, 1),
                // color: Theme.of(context).scaffoldBackgroundColor,
                // Color.fromRGBO(221, 230, 231, 1)
                context: context,
                position: RelativeRect.fromLTRB(
                    details.globalPosition.dx, details.globalPosition.dy, 0, 0),
                items: [
                  PopupMenuItem(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.share),
                        ),
                        Text(
                          'Share',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.block),
                        ),
                        Text(
                          'Block',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.report),
                        ),
                        Text(
                          'Report',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              // showSearch(
              //     context: context, delegate: CustomSearchDelegate());
            },
            child: const Icon(
              Icons.more_vert,
              size: 30,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: size.width / 2,
              height: size.width / 2,
              constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: FutureBuilder(
                    future: getImage(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.network(snapshot.data!);
                      } else {
                        return Image.asset(
                          'assets/images/user.png',
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Text(
              '${widget.user['firstname']} ${widget.user['lastname']}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                widget.user['aboutme'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(198, 214, 214, 1),
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Icon(Icons.notifications_active),
                  ),
                  Expanded(
                    child: Text(
                      'Mute Notification',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      activeColor: Colors.white,
                      activeTrackColor: Colors.black,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.white,
                      trackOutlineColor:
                          MaterialStateProperty.all(Colors.black),
                      onChanged: (value) {
                        setState(() {
                          notificationMuted = value;
                        });
                      },
                      value: notificationMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(198, 214, 214, 1),
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.music_note),
                  ),
                  Expanded(
                    child: Text(
                      'Custom Notification',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  IconButton(
                    color: Colors.black,
                    onPressed: () {},
                    icon: Icon(Icons.library_music),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(198, 214, 214, 1),
              ),
              child: Column(
                children: [
                  Text("Mutual Friends"),
                  // Container(
                  //   child: ListView.builder(
                  //     itemCount: null,
                  //     itemBuilder: (context, index) {
                  //       return Card(
                  //         child: ListTile(
                  //           leading: FutureBuilder(),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
