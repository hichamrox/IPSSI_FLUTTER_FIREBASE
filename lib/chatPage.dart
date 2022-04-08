import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ipssiflutter/library/constants.dart';
import 'package:ipssiflutter/model/message.dart';
import 'package:uuid/uuid.dart';
import 'fonctions/firestoreHelper.dart';
import 'model/utilisateur.dart';

class ChatPage extends StatefulWidget {
  Utilisateur user;
  ChatPage({required this.user});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController msgController = new TextEditingController();

  final ScrollController controller =
      ScrollController(initialScrollOffset: 10000);
  late String content;

  Future scrollToItem() async {
    controller.jumpTo(controller.position.maxScrollExtent * 1.5);
  }

  @override
  void initState() {
    super.initState();

    msgController.addListener(() {
      setState(() {}); // setState every time text changes
    });
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                  radius: 20,
                  backgroundImage: (widget.user.logo != null)
                      ? NetworkImage(widget.user.logo!)
                      : NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/projetsqyavril2022.appspot.com/o/noImage.png?alt=media&token=dc26627a-5c9f-491b-8529-c8b44bfad00a")),
            ),
            Column(
              children: [
                Text(widget.user.prenom),
                Text(
                  "en ligne",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ],
        ),
      ),
      body: bodyPage(),
      bottomSheet: Container(
          width: size.width,
          color: Colors.white,
          child: Container(
            height: 100,
            width: Size.infinite.width,
            child: Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Write message"),
                      controller: msgController,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (msgController.text.isNotEmpty) {
                      String uid = Uuid().v1();
                      Map<String, dynamic> map = {
                        "UIDRECEVER": widget.user.uid,
                        "UIDSENDER": monProfil.uid,
                        "UID": uid,
                        "CONTENT": msgController.text,
                        "DATE": DateTime.now()
                      };
                      FirestoreHelper().addMessage(uid, map);
                      msgController.clear();
                      setState(() {
                        scrollToItem();
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.send,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget bodyPage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_message.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            List documents = snapshot.data!.docs;
            List<Message> messages = [];
            documents.forEach((element) {
              Message msg = Message(element);
              if (((monProfil.uid == msg.uidSender) &
                      (widget.user.uid == msg.uidRecever)) |
                  ((monProfil.uid == msg.uidRecever) &
                      (widget.user.uid == msg.uidSender))) {
                messages.add(msg);
              }
            });
            messages.sort(((a, b) => a.date.compareTo(b.date)));

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                  controller: controller,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (monProfil.uid == messages[index].uidSender) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(messages[index].date.hour.toString() +
                                  ":" +
                                  messages[index].date.minute.toString()),
                              Flexible(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Color.fromARGB(255, 93, 173, 238)),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        messages[index].content,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                  radius: 15,
                                  backgroundImage: (monProfil.logo != null)
                                      ? NetworkImage(monProfil.logo!)
                                      : NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/projetsqyavril2022.appspot.com/o/noImage.png?alt=media&token=dc26627a-5c9f-491b-8529-c8b44bfad00a"))
                            ],
                          ),
                        ),
                      );
                    } else if (monProfil.uid == messages[index].uidRecever) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage: (widget.user.logo != null)
                                      ? NetworkImage(widget.user.logo!)
                                      : NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/projetsqyavril2022.appspot.com/o/noImage.png?alt=media&token=dc26627a-5c9f-491b-8529-c8b44bfad00a")),
                            ),
                            Flexible(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.6),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          Color.fromARGB(255, 216, 213, 213)),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      messages[index].content,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(messages[index].date.hour.toString() +
                                ":" +
                                messages[index].date.minute.toString())
                          ],
                        ),
                      );
                    }

                    return Container();
                  }),
            );
          }
        });
  }
}
