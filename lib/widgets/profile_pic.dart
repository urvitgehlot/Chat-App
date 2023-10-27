import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePic extends StatelessWidget {
  final String imageName;

  Future<String> getImageUrl(String imageName) async {
    String imageUrl =
        await FirebaseStorage.instance.ref('dp/$imageName').getDownloadURL();

    return imageUrl;
  }

  const ProfilePic({Key? key, required this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getImageUrl(imageName),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        }
        print(snapshot.data!);
        if (snapshot.hasData) {
          return Image.network(snapshot.data!);
        } else {
          return Image.network('src');
        }
      },
    );
  }
}
