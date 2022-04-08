import 'package:flutter/material.dart';
import 'package:ipssiflutter/chatPage.dart';
import 'model/utilisateur.dart';

class detailPage extends StatefulWidget {
  Utilisateur user;
  detailPage({required this.user});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return detailState();
  }
}

class detailState extends State<detailPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(), body: bodyPage());
  }

  Widget bodyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: widget.user.uid,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: (widget.user.logo != null)
                        ? NetworkImage(widget.user.logo!)
                        : NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/projetsqyavril2022.appspot.com/o/noImage.png?alt=media&token=dc26627a-5c9f-491b-8529-c8b44bfad00a"))),
          ),
        ),
        //Image

        SizedBox(height: 15),

        //nom et prénom
        Text("${widget.user.prenom} ${widget.user.nom}"),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatPage(user: widget.user);
              }));
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text("chat"))
      ],
    );
  }
}
