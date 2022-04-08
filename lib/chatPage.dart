import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  late String content;

  clearTextInput() {
    msgController.clear();
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
        title: Text(widget.user.prenom),
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
                  width: size.width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: msgController,
                      onChanged: (value) {
                        setState(() {
                          content = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.download, size: 30),
                ),
                GestureDetector(
                  onTap: () {
                    String uid = Uuid().v1();
                    Map<String, dynamic> map = {
                      "UIDRECEVER": widget.user.uid,
                      "UIDSENDER": monProfil.uid,
                      "UID": uid,
                      "CONTENT": content,
                      "DATE": DateTime.now()
                    };
                    FirestoreHelper().addMessage(uid, map);
                    msgController.text = "";
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.message, size: 30),
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
            // messages.sort(((a, b) => a.date.compareTo(b.date)));

            return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  if (monProfil.uid == messages[index].uidSender) {
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(messages[index].content),
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(monProfil.logo!),
                          )
                        ],
                      ),
                    );
                  } else if (monProfil.uid == messages[index].uidRecever) {
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(widget.user.logo!),
                          ),
                          Text(messages[index].content)
                        ],
                      ),
                    );
                  }
                  return Container();
                });
          }
        });
  }
}
