import 'package:flutter/material.dart';

import 'fonctions/firestoreHelper.dart';

class registerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return registerPageState();
  }
}

class registerPageState extends State<registerPage> {
  late String mail;
  late String password;
  late String prenom;
  late String nom;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person),
            hintText: "Taper votre prénom",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onChanged: (value) {
            setState(() {
              prenom = value;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person),
            hintText: "Taper votre nom",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onChanged: (value) {
            setState(() {
              nom = value;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail),
            hintText: "Taper votre adresse mail",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onChanged: (value) {
            setState(() {
              mail = value;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_rounded),
            hintText: "Taper votre mot de passe",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          obscureText: true,
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              FirestoreHelper().register(mail, password, nom, prenom);
            },
            child: const Text("Inscription"))
      ],
    );
  }
}
