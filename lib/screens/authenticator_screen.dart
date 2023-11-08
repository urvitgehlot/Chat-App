import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/profile_complete_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticator extends StatefulWidget {
  const Authenticator({super.key});

  @override
  State<Authenticator> createState() => _AuthenticatorState();
}

class _AuthenticatorState extends State<Authenticator> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;

  bool isLoading = false;
  bool login = true;
  bool isPasswordHide = true;
  IconData passwordShow = Icons.visibility_off;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      var t = await database
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => value.exists);
      setState(() {
        isLoading = false;
      });
      void nav() {
        if (t) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Home(),
          ));
        } else {
          print('Profile Complete page');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProfileComplete(),
          ));
        }
      }

      nav();
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  void createAccount(String email, String password, String confirmPassword,
      Function fun) async {
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty) {
      setState(() {
        isLoading = false;
      });
      fun.call('Enter Email and Password');
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        isLoading = false;
      });
      fun.call('confirm password is not correct');
    }

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      emailController.text = '';
      passwordController.text = '';
      confirmPasswordController.text = '';
      setState(() {
        login = true;
        isLoading = false;
      });
      fun.call('Account Created successfully');
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'email-already-in-use') {
        fun.call('Email is already taken');
      } else if (e.code == 'invalid-email') {
        fun.call('Email is invalid');
      } else if (e.code == 'weak-password') {
        fun.call('Set Strong Password');
      }
    }
  }

  Future<void> loginAccount(
    String email,
    String password,
    Function fun,
  ) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      setState(() {
        isLoading = false;
      });
      fun.call('Enter Email and Password');
      return;
    }

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      var t = await database
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => value.exists);
      setState(() {
        isLoading = false;
      });
      void nav() {
        if (t) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Home(),
          ));
        } else {
          print('Profile Complete page');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProfileComplete(),
          ));
        }
      }

      nav();
      // print('object');
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-disabled') {
        fun.call('User is been disabled');
        return;
      } else if (e.code == 'invalid-email') {
        fun.call('Email is invalid');
        return;
      } else if (e.code == 'wrong-password') {
        fun.call('Password Incorrect');
        return;
      } else if (e.code == 'user-not-found') {
        fun.call('User not found');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void notifySnack(BuildContext context, String text) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: size.height,
                // width:,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height / 10,
                    ),
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Color.fromRGBO(28, 189, 200, 1),
                      size: size.height / 7,
                    ),
                    Text(
                      'WELCOME',
                      style: GoogleFonts.itim(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          // fontFamily: ,
                        ),
                      ),
                    ),
                    Text(
                      login
                          ? 'Please Sign-in to continue'
                          : 'Please Register Yourself to continue',
                      style: TextStyle(
                        color: Color.fromRGBO(104, 136, 143, 1),
                        fontSize: 13,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      indent: 35,
                      endIndent: 35,
                    ),
                    Container(
                      // color: Theme.of(context).colorScheme.primary,
                      width: size.width - 70,
                      margin: EdgeInsets.only(top: size.height / 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            login ? 'Login' : 'Register',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 24,
                            ),
                          ),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              label: Text('Email'),
                            ),
                            // cursorColor: Theme.of(context).colorScheme.primary,
                            // style: TextStyle(
                            //   color: Theme.of(context).colorScheme.primary,
                            // ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    label: Text('Password'),
                                  ),
                                  obscureText: isPasswordHide,
                                  // style: TextStyle(
                                  //   color: Theme.of(context).colorScheme.primary,
                                  // ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.only(top: 20),
                                onPressed: () {
                                  if (isPasswordHide) {
                                    setState(() {
                                      isPasswordHide = false;
                                      passwordShow = Icons.visibility;
                                    });
                                  } else {
                                    setState(() {
                                      isPasswordHide = true;
                                      passwordShow = Icons.visibility_off;
                                    });
                                  }
                                },
                                icon: Icon(passwordShow),
                              ),
                            ],
                          ),
                          if (!login)
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: isPasswordHide,
                              decoration: const InputDecoration(
                                label: Text('Confirm Password'),
                              ),
                              // style: TextStyle(
                              //   color: Theme.of(context).colorScheme.primary,
                              // ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // Text('G'),
                        Icon(
                          Icons.g_mobiledata_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 100,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            print('Google Sign In initiated');
                            signInWithGoogle();
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: Text(
                            'Sign-in with Google',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        emailController.text = '';
                        passwordController.text = '';
                        confirmPasswordController.text = '';
                        setState(() {
                          login = !login;
                        });
                      },
                      child: Text(
                        login ? 'Create Account' : 'Already have account login',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.all(Radius.circular(35)),
                      ),
                      child: ClipRRect(
                        child: IconButton(
                          color: Colors.black,
                          iconSize: 60,
                          icon: Icon(Icons.arrow_forward_rounded),
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            login
                                ? loginAccount(emailController.text,
                                    passwordController.text, (String text) {
                                    notifySnack(context, text);
                                  })
                                : createAccount(
                                    emailController.text,
                                    passwordController.text,
                                    confirmPasswordController.text,
                                    (String text) {
                                      notifySnack(context, text);
                                    },
                                  );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
