import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/screens/authenticator_screen.dart';
import 'package:chat_app/widgets/add_friend.dart';
import 'package:chat_app/widgets/recent_chats.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;

  final database = FirebaseFirestore.instance;
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, Object?>> friends = [];
  // List<String> friendsEmails = [];

  void setStatusOnline(bool isOnline) async {
    await database
        .collection('users')
        .doc(userUid)
        .update({'status': isOnline ? 'Online' : 'Offline'});
  }

  void friendAdd(String email, String addTo) async {
    var user = await database
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (user.docs.isEmpty) {
      print('Entered Nothing');
      return;
    }

    await database.collection('users').doc(addTo).update({
      'friends': FieldValue.arrayUnion([email])
    });
    if (addTo == auth.currentUser!.uid) {
      setState(() {
        friends.add(user.docs[0].data());
      });
    }
    // else{
    //   await database.collection('users').where('email',is)
    // }
  }

  void getFriends() async {
    List<Map<String, Object?>> temp = [];
    await database.collection('users').doc(auth.currentUser!.uid).get().then(
      (value) async {
        if (value.exists && value.data()!.containsKey('friends')) {
          print('PRinting 1st');
          for (int i = 0; i < value['friends'].length; i++) {
            await database
                .collection('users')
                .where('email', isEqualTo: value['friends'][i])
                .get()
                .then(
              (value1) {
                if (value1.docs.isNotEmpty) {
                  print(value1.docs[0]);
                  temp.add(value1.docs[0].data());
                }
              },
            );
          }
        }
      },
    );
    if (temp.isEmpty) return;

    setState(() {
      friends = temp;
    });
  }

  // final List<Friend> recentChats = [];

  // late final DocumentSnapshot<Map<String, dynamic>> user;

  void addFriend(BuildContext ctx) async {
    await Navigator.of(ctx).push(MaterialPageRoute(
      builder: (context) => AddFriend(
        addFriend: friendAdd,
      ),
    ));

    getFriends();
  }

  @override
  void initState() {
    setStatusOnline(true);
    // getFriends();
    // TODO: implement initState
    getFriends();
    super.initState();
  }

  @override
  void dispose() {
    setStatusOnline(false);

    print('database closed');
    // TODO: implement dispose
    // closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getFriends();
    final size = MediaQuery.of(context).size;

    // final userData =
    //     database.collection('users').doc(auth.currentUser!.uid).get();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        // leadingWidth: ,
        leading: Container(
          // color: Color.fromRGBO(163, 183, 184, 1),
          child: Image.asset('assets/images/ug.png'),
        ),
        title: const Text('Ug Chat'),
        // backgroundColor: Color.fromRGBO(136, 178, 181, 1),
        backgroundColor: Color.fromRGBO(221, 230, 231, 1),

        actions: [
          const Icon(Icons.search),
          IconButton(
            onPressed: () {
              addFriend(context);
            },
            icon: Icon(Icons.person_add_alt_1_rounded),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTapDown: (details) {
                showMenu(
                  shadowColor: Colors.black,
                  // color: Color.fromRGBO(136, 178, 181, 1),

                  color: Color.fromRGBO(221, 230, 231, 1),
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  // Color.fromRGBO(221, 230, 231, 1)
                  context: context,
                  position: RelativeRect.fromLTRB(details.globalPosition.dx,
                      details.globalPosition.dy, 0, 0),
                  items: [
                    PopupMenuItem(
                      onTap: () async {
                        Map<String, dynamic>? user = await database
                            .collection('users')
                            .doc(auth.currentUser!.uid)
                            .get()
                            .then((value) => value.data());

                        if (user == null) return;

                        if (!context.mounted) return;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserProfileScreen(user),
                        ));
                      },
                      child: const Text(
                        'View Profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // PopupMenuItem(
                    //   child: Text('Search'),
                    // ),
                    PopupMenuItem(
                      onTap: () {},
                      child: const Text(
                        'Notifications',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: const Text(
                        'Settings',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        await auth.signOut();

                        if (!context.mounted) return;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => const Authenticator(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: const Text(
                        'Report',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: const Text(
                        'About',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // PopupMenuItem(
                    //   child: Text('Block'),
                    // ),
                    // PopupMenuItem(
                    //   child: Text('Clear Chat'),
                    // ),
                    // PopupMenuItem(
                    //   child: Text('Wallpaper'),
                    // ),
                    // PopupMenuItem(
                    //   child: TextButton.icon(
                    //     onPressed: () {},
                    //     icon: const Icon(Icons.account_circle_rounded),
                    //     label: const Text('Profile'),
                    //   ),
                    // ),
                    // PopupMenuItem(
                    //   child: TextButton.icon(
                    //     onPressed: () {},
                    //     icon: const Icon(Icons.settings),
                    //     label: const Text('Settings'),
                    //   ),
                    // ),
                    // PopupMenuItem(
                    //   child: TextButton.icon(
                    //     onPressed: () {},
                    //     icon: const Icon(Icons.logout),
                    //     label: const Text('Sign Out'),
                    //   ),
                    // ),
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
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
            color: Colors.black,
            width: 0.4,
          )),
          color: const Color.fromRGBO(221, 230, 231, 1),
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height / 50,
            ),
            Expanded(
              child: SizedBox(
                // height: 600,
                child: StreamBuilder<Object>(
                    stream: database
                        .collection('users')
                        .doc(auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemBuilder: (ctx, i) {
                          return RecentChats(friends[i], friendAdd);
                        },
                        itemCount: friends.length,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromRGBO(136, 178, 181, 1),
      //   onPressed: () {
      //     addFriend(context);
      //   },
      //   child: Icon(Icons.person_add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation,
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final database = FirebaseFirestore.instance;
  // Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return StreamBuilder(
        stream: database.collection('users').snapshots(),
        builder: (context, snapshot) {
          List<String> l = [];
          if (snapshot.hasData) {
            for (var snap in snapshot.data!.docs) {
              if (snap['email'].toString().contains(query.toLowerCase())) {
                l.add(snap['email']);
                print(l);
              }
            }
            // snapshot.data!.docs[]
            // print(snapshot.data!.docs[0]['email']);
            return ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                var result = l[index];
                return ListTile(
                  title: Text(result),
                );
              },
            );
          } else {
            return Text('data');
          }
        });
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
