import 'dart:io';
import 'dart:math';

import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/recieve_msg_box.dart';
import 'package:chat_app/widgets/sender_msg_box.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class Chat extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function friendAdd;

  const Chat(this.user, this.friendAdd, {super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController msgController = TextEditingController();

  bool isSending = false;

  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  String dp = '';
  String url = '';
  String? chatRoomId;

  List<File> imagePicked = [];
  late File selectedImage;

  // void setupPushNotification() async {
  //   final fcm = FirebaseMessaging.instance;
  //   await fcm.requestPermission();

  //   final token = await fcm.getToken();
  //   print(token);
  // }

  // int msgCount = 0;

  void getDataInfo(String image) async {
    String imageUrl =
        await FirebaseStorage.instance.ref(image).getDownloadURL();
    print(chatRoomId);

    setState(() {
      if (imageUrl.isNotEmpty) {
        dp = imageUrl;
      }
    });
  }

  // void

  String getChatId(String user1, String user2) {
    if (user1.trim().toLowerCase().codeUnits[0] >
        user2.trim().toLowerCase().codeUnits[0]) {
      return '$user1 $user2';
    } else {
      return '$user2 $user1';
    }
  }

  void setChatRoomId() async {
    // await auth.currentUser!.updateDisplayName('Suraj Saraswat');
    chatRoomId = getChatId(
      auth.currentUser!.displayName!.trim().toLowerCase(),
      '${widget.user['firstname'].toString().trim().toLowerCase()} ${widget.user['lastname'].toString().trim().toLowerCase()}',
    );
  }

  void addPickedImage() async {
    final imagePicker = ImagePicker();

    XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    setState(() {
      imagePicked.add(File(pickedImage.path));
      selectedImage = imagePicked[0];
      // imagePicked = File(pickedImage.path);
    });
  }

  void sendMsg() async {
    if (msgController.text.trim().isEmpty && imagePicked.isEmpty) return;
    setState(() {
      isSending = true;
    });

    var timeStamp = DateTime.now();
    var sender = auth.currentUser!.email!.trim().toLowerCase();
    // var sender = database.collection('users').where('email',
    //     isEqualTo: auth.currentUser!.email!.trim().toLowerCase());
    var reciever = widget.user['email'].toString().trim().toLowerCase();
    // print(sender)

    var temp = await database
        .collection('users')
        .where('email', isEqualTo: widget.user['email'])
        .get();
    if (temp.docs[0]['friends'].contains(sender) == false) {
      widget.friendAdd(sender, widget.user['uid']);
    }

    if (imagePicked.isNotEmpty) {
      List<String> imgpaths = [];
      for (File i in imagePicked) {
        String imgPath = storage
            .ref(
                '${chatRoomId!}/${timeStamp.toString()} ${Random().nextInt(100)}${p.extension(i.path)}')
            .fullPath;

        imgpaths.add(imgPath);

        await storage.ref(imgPath).putFile(i);
      }
      Map<String, dynamic> messages = {
        'sender': sender,
        'reciever': reciever,
        'time': timeStamp,
        'msg': msgController.text.trim(),
        'read': false,
        'images': imgpaths,
      };
      await database
          .collection('msg')
          .doc('directmsg')
          .collection(chatRoomId!)
          .add(messages);

      setState(() {
        imagePicked = [];
      });
    } else {
      Map<String, dynamic> messages = {
        'sender': sender,
        'reciever': reciever,
        'time': timeStamp,
        'msg': msgController.text.trim(),
        'read': false,
        'images': [],
      };
      await database
          .collection('msg')
          .doc('directmsg')
          .collection(chatRoomId!)
          .add(messages);
    }

    msgController.text = '';
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isSending = false;
    });
  }

  void readMsg(String id) async {
    // var temp = await database
    //     .collection('msg')
    //     .doc('directmsg')
    //     .collection(chatRoomId!)
    //     .doc(id)
    //     .get();
    // // .update({'read': true});
    // if (temp[0]['sender'] ==
    //     auth.currentUser!.displayName!.trim().toLowerCase()) {
    await database
        .collection('msg')
        .doc('directmsg')
        .collection(chatRoomId!)
        .doc(id)
        .update({'read': true});
    // }
  }

  @override
  void initState() {
    // setupPushNotification();

    chatRoomId = getChatId(
      auth.currentUser!.displayName!.trim().toLowerCase(),
      '${widget.user['firstname'].toString().trim().toLowerCase()} ${widget.user['lastname'].toString().trim().toLowerCase()}',
    );

    // TODO: implement initState
    getDataInfo(widget.user['dp']);
    super.initState();
  }

  @override
  void dispose() {
    msgController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // DateTime time;
    // DateTime tempTime;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.keyboard_backspace_outlined),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // InkWell(
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: const BorderRadius.only(
                              //         topLeft: Radius.circular(50),
                              //         bottomLeft: Radius.circular(50),
                              //       ),
                              //       color: Theme.of(context).primaryColor,
                              //     ),
                              //     padding: const EdgeInsets.only(
                              //         top: 2, bottom: 2, right: 5, left: 5),
                              //     child: const Icon(Icons.add_ic_call_sharp),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return Image.network(dp);
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2.5,
                                        style: BorderStyle.solid,
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: dp.isEmpty
                                        ? Image.asset(
                                            fit: BoxFit.cover,
                                            height: 80,
                                            width: 80,
                                            'assets/images/user.png',
                                            color:
                                                Color.fromRGBO(0, 0, 255, 0.5),
                                          )
                                        : Image.network(
                                            fit: BoxFit.cover,
                                            height: 80,
                                            width: 80,
                                            // dp.isEmpty
                                            //     ? "https://pbs.twimg.com/media/D4F_egWXsAAjB6r.jpg"
                                            dp,
                                          ),
                                  ),
                                ),
                              ),
                              // InkWell(
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: const BorderRadius.only(
                              //         topRight: Radius.circular(50),
                              //         bottomRight: Radius.circular(50),
                              //       ),
                              //       color: Theme.of(context).primaryColor,
                              //     ),
                              //     padding: const EdgeInsets.only(
                              //         top: 2, bottom: 2, right: 5, left: 5),
                              //     child: const Icon(Icons.videocam),
                              //   ),
                              // )
                            ],
                          ),
                          StreamBuilder(
                              stream: database
                                  .collection('users')
                                  .where('email',
                                      isEqualTo: widget.user['email'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      '${snapshot.data!.docs[0]['status']}');
                                } else {
                                  return const Text('Not Available');
                                }
                              }),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (details) {
                        showMenu(
                          shadowColor: Colors.black,
                          // color: Color.fromRGBO(136, 178, 181, 1),

                          color: Color.fromRGBO(221, 230, 231, 1),
                          // color: Theme.of(context).scaffoldBackgroundColor,
                          // Color.fromRGBO(221, 230, 231, 1)
                          context: context,
                          position: RelativeRect.fromLTRB(
                              details.globalPosition.dx,
                              details.globalPosition.dy,
                              0,
                              0),
                          items: [
                            PopupMenuItem(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(widget.user),
                                ));
                              },
                              child: Text(
                                'View Profile',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: Text(
                                'Search',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: Text(
                                'Mute Notifications',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: Text(
                                'Report',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: Text(
                                'Block',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: Text(
                                'Clear Chat',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              child: Text(
                                'Wallpaper',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                      child: const Icon(
                        Icons.menu,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 10),
                        spreadRadius: 10,
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    color: Color.fromRGBO(241, 241, 241, 1),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          // padding: EdgeInsets.only(top: 30),
                          // height: 500,
                          child: StreamBuilder(
                            stream: database
                                .collection('msg')
                                .doc('directmsg')
                                .collection(chatRoomId!)
                                .orderBy('time', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return ListView.builder(
                                  reverse: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    // String? imgUrl;
                                    bool isSenderIsUser =
                                        snapshot.data!.docs[index]['sender'] ==
                                            auth.currentUser!.email;
                                    // DateTime time = (snapshot.data!.docs[index]
                                    //         ['time'])
                                    //     .toDate();

                                    if (isSenderIsUser == false &&
                                        snapshot.data!.docs[index]['read'] ==
                                            false) {
                                      readMsg(snapshot.data!.docs[index].id);
                                      print('reading');
                                    }
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: isSenderIsUser
                                          ? SenderMsgBox(
                                              snapshot.data!.docs[index].data())
                                          : RecieveMsgBox(snapshot
                                              .data!.docs[index]
                                              .data()),
                                    );
                                  },
                                );
                              } else {
                                return Text('NO DATA');
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(
                          right: 20,
                          left: 20,
                          top: 15,
                          bottom: 30,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(198, 214, 214, 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.camera_alt)),
                            Container(
                              // padding: const EdgeInsets.only(left: 30),
                              width: size.width - 190,
                              child: TextField(
                                controller: msgController,
                                decoration: const InputDecoration(
                                  hintText: 'Write a message',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                addPickedImage();
                              },
                              icon: const Icon(Icons.attachment),
                            ),
                            isSending
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      sendMsg();
                                    },
                                    icon: const Icon(Icons.send),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          imagePicked.isNotEmpty
              ? Positioned(
                  bottom: 0,
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(4, -1),
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 0.1,
                            blurRadius: 13),
                      ],
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          // color: Colors.grey,
                          margin: EdgeInsets.symmetric(horizontal: 15),

                          width: size.width - 100,
                          // alignment: Alignment.centerLeft,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  imagePicked.remove(selectedImage);
                                  if (imagePicked.isNotEmpty) {
                                    selectedImage = imagePicked[0];
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: size.width - 100,
                          height: 250,
                          // margin: EdgeInsets.only(bottom: 10),
                          // color: Colors.grey,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.file(
                              selectedImage,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: IconButton(
                                  onPressed: () {
                                    addPickedImage();
                                  },
                                  icon: Icon(Icons.add_circle_outlined),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: imagePicked.map((e) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImage = e;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: selectedImage == e
                                            ? Border.all(
                                                color: Colors.lightBlue,
                                                width: 1.5,
                                                style: BorderStyle.solid,
                                              )
                                            : Border.all(
                                                style: BorderStyle.none),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: 50,
                                      child: Image.file(e),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 30,
                            left: 15,
                            right: 15,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color.fromRGBO(241, 241, 241, 1),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: 2,
                                  offset: Offset(3, 4),
                                )
                              ]),
                          // height: 40,
                          // width: 100,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 30),
                                width: size.width - 150,
                                child: TextField(
                                  controller: msgController,
                                  decoration: const InputDecoration(
                                    hintText: 'Add Message',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              isSending
                                  ? Container(
                                      width: 24,
                                      height: 24,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        sendMsg();
                                      },
                                      icon: const Icon(Icons.send),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
