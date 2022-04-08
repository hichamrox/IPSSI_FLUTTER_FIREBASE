import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String uid;
  late String uidSender;
  late String uidRecever;
  late String content;
  late DateTime date;

  Message(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    uidRecever = map["UIDRECEVER"];
    uidSender = map["UIDSENDER"];
    content = map["CONTENT"];
    uid = map["UID"];
    Timestamp timestamp = map["DATE"];
    date = timestamp.toDate();
  }
}
