import 'package:chat_app/screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class RecentChats extends StatefulWidget {
  // final int i;
  final Map<String, Object?> user;
  final Function friendAdd;
  const RecentChats(this.user, this.friendAdd, {super.key});

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  String fullName = '';
  String url = '';
  // String lastMsg = '';
  // int unReadedMsg = 0;
  String chatRoomId = '';

  final database = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // String chatRoomId = '';
  // final auth = FirebaseAuth.instance;

  // String getChatId(String user1, String user2) {
  //   if (user1.trim().toLowerCase().codeUnits[0] >
  //       user2.trim().toLowerCase().codeUnits[0]) {
  //     return '$user1 $user2';
  //   } else {
  //     return '$user2 $user1';
  //   }
  // }

  // void setChatRoomId() async {
  //   // await auth.currentUser!.updateDisplayName('Suraj Saraswat');
  //   chatRoomId = getChatId(
  //     auth.currentUser!.displayName!.trim().toLowerCase(),
  //     '${widget.user['firstname'].toString().trim().toLowerCase()} ${widget.user['lastname'].toString().trim().toLowerCase()}',
  //   );
  // }

  // void updatePreview() async {
  //   final database = FirebaseFirestore.instance;
  //   setChatRoomId();

  //   database
  //       .collection('msg')
  //       .doc('directmsg')
  //       .collection(chatRoomId)
  //       .where(field);
  // }

  void fun() async {
    print('OK');
    final storageRef = FirebaseStorage.instance.ref();
    // final database = FirebaseFirestore.instance;
    String getChatId(String user1, String user2) {
      if (user1.trim().toLowerCase().codeUnits[0] >
          user2.trim().toLowerCase().codeUnits[0]) {
        return '$user1 $user2';
      } else {
        return '$user2 $user1';
      }
    }

    chatRoomId = getChatId(
      auth.currentUser!.displayName!.trim().toLowerCase(),
      '${widget.user['firstname'].toString().trim().toLowerCase()} ${widget.user['lastname'].toString().trim().toLowerCase()}',
    );
    print('Printing msg');
    // String tempMsg = await database
    //     .collection('msg')
    //     .doc('directmsg')
    //     .collection(chatRoomId)
    //     .orderBy('time', descending: true)
    //     .snapshots()
    //     .first
    //     .then((value) {
    //   if (value.docs.isNotEmpty) {
    //     return value.docs[0]['msg'];
    //   } else
    //     return '';
    // });

    // int tempUnread = await database
    //     .collection('msg')
    //     .doc('directmsg')
    //     .collection(chatRoomId)
    //     .where('read', isEqualTo: false)
    //     .count()
    //     .get()
    //     .then((value) => value.count);

    // var storageUrl = userInfoGet.docs[0]['dp'].toString();
    var storageUrl = widget.user['dp'].toString();
    // print('Try ' + storageUrl);

    var dp = await storageRef.child(storageUrl).getDownloadURL();

    var name = '${widget.user['firstname']} ${widget.user['lastname']}';
    setState(() {
      if (url != dp) {
        url = dp;
      }
      if (fullName != name) {
        fullName = name;
      }
      // if (tempMsg.isNotEmpty || lastMsg != tempMsg) {
      //   lastMsg = tempMsg;
      // }
      // if (tempUnread > 0 || unReadedMsg != tempUnread) {
      //   unReadedMsg = tempUnread;
      // }
    });

    // return url;
  }

  @override
  void initState() {
    // TODO: implement initState
    fun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // var o = n.getData(1048576);
    // print(n.fullPath);
    // n.getDownloadURL();

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => Chat(widget.user, widget.friendAdd),
        ))
            .then((value) {
          fun();
        });
      },
      splashColor: Colors.black,
      child: Container(
        height: 70,
        margin: EdgeInsets.symmetric(
          horizontal: size.width / 20,
          vertical: size.height / 80,
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(221, 230, 231, 1),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 4),
                blurRadius: 4,
                blurStyle: BlurStyle.outer),
          ],
          // color: const Color.fromARGB(100, 201, 124, 124),
          borderRadius: const BorderRadius.all(Radius.circular(35)),
          border: Border.all(),
        ),
        child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: ,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                height: 62,
                width: 60,
                // width: ,
                // width: 40,

                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  // color: Colors.black,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: url.isEmpty
                        ? Image.asset('assets/images/user.png')
                        : Image.network(url)),
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: size.width / 2,
                    margin: const EdgeInsets.only(left: 10),
                    child: StreamBuilder(
                        stream: database
                            .collection('msg')
                            .doc('directmsg')
                            .collection(chatRoomId)
                            .orderBy('time', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data == null || snapshot.data!.docs.isEmpty
                                ? ''
                                : snapshot.data!.docs[0]['msg'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(128, 119, 119, 1),
                            ),
                          );
                        }),
                  )
                ],
              ),
              Expanded(
                child: Container(),
              ),
              // if (unReadedMsg != 0)
              StreamBuilder(
                  stream: database
                      .collection('msg')
                      .doc('directmsg')
                      .collection(chatRoomId)
                      .where('read', isEqualTo: false)
                      // .where('sender',
                      //     isNotEqualTo: auth.currentUser!.displayName!
                      //         .trim()
                      //         .toLowerCase())
                      .snapshots(),
                  builder: (context, snapshot) {
                    String text = () {
                      if (snapshot.data != null) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          int noOfUnread = snapshot.data!.docs
                              .where(
                                (element) =>
                                    element['sender'] !=
                                    auth.currentUser!.email!
                                        .trim()
                                        .toLowerCase(),
                              )
                              .length;

                          if (noOfUnread > 0) {
                            return noOfUnread.toString();
                            // return '100';
                          }
                        }
                      }
                      return '';
                    }();

                    // String text = () {
                    //   return '';
                    // }();
                    // snapshot.data!.docs.where((element) {
                    //   element['sender']!=auth.currentUser!.displayName!.trim().toLowerCase()
                    // },).length;
                    // int unReadMsg = snapshot.data!.docs.length;
                    if (text.isNotEmpty) {
                      return Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            )
                          ],
                          color: Color.fromRGBO(217, 217, 217, 1),
                          // color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        alignment: Alignment.centerRight,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              int.parse(text) > 999
                                  ? '${(int.parse(text) / 1000).floor()}k'
                                  : text,
                              style: const TextStyle(
                                color: Color.fromRGBO(28, 189, 200, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ]),
      ),
    );
  }
}
