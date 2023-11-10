import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';

class SenderMsgBox extends StatefulWidget {
  final Map<String, dynamic> msgMap;
  const SenderMsgBox(this.msgMap, {super.key});

  @override
  State<SenderMsgBox> createState() => _SenderMsgBoxState();
}

class _SenderMsgBoxState extends State<SenderMsgBox> {
  final storage = FirebaseStorage.instance;

  Future<String> getImgUrl(String img) async {
    String imgUrl = await storage.ref(img).getDownloadURL();

    return imgUrl;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicWidth(
            child: Card(
              color: Color.fromRGBO(217, 217, 217, 1),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width / 1.4),
                child: Column(
                  children: [
                    (widget.msgMap['images'] as List<dynamic>).isNotEmpty
                        ? Column(
                            children:
                                (widget.msgMap['images'] as List<dynamic>).map(
                              (e) {
                                return Container(
                                  constraints: BoxConstraints(minWidth: 150),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  height: 250,
                                  child: FutureBuilder(
                                    future: getImgUrl(e.toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Image.network(snapshot.data!);
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ).toList(),
                          )
                        : Container(),
                    if ((widget.msgMap['msg']).isNotEmpty)
                      Container(
                        alignment: Alignment.centerRight,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        // color: Color.fromRGBO(217, 217, 217, 1),
                        // decoration: BoxDecoration(),
                        child: Text(
                          widget.msgMap['msg'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(104, 136, 143, 1),
                              fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Container(
          //   child: Image.file(File('asdf')),
          // ),
        ],
      ),
    );
  }
}
