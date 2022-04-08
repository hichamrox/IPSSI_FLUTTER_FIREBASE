import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ipssiflutter/model/message.dart';

import '../model/utilisateur.dart';

class FirestoreHelper {
  final auth = FirebaseAuth.instance;
  final fire_user = FirebaseFirestore.instance.collection("Users");
  final fire_message = FirebaseFirestore.instance.collection("Messages");
  final fire_storage = FirebaseStorage.instance;

  //Methode pour l'inscription
  Future register(
      String mail, String password, String nom, String prenom) async {
    UserCredential resultat = await auth.createUserWithEmailAndPassword(
        email: mail, password: password);
    String uid = resultat.user!.uid;
    Map<String, dynamic> map = {"NOM": nom, "PRENOM": prenom, "UID": uid};
    addUser(uid, map);
  }

  //Méthode pour la connexion

  Future connect(String mail, String password) async {
    UserCredential resultat =
        await auth.signInWithEmailAndPassword(email: mail, password: password);
  }

  //Méthode pour enregistrer dans la base de donnée
  addUser(String uid, Map<String, dynamic> map) {
    fire_user.doc(uid).set(map);
  }

  addMessage(String uid, Map<String, dynamic> map) {
    fire_message.doc(uid).set(map);
  }

  updateUser(String uid, Map<String, dynamic> map) {
    fire_user.doc(uid).update(map);
  }

  Future<String> getIdenfiant() async {
    return await auth.currentUser!.uid;
  }

  Future<Utilisateur> getUtilisateur(String uid) async {
    DocumentSnapshot snapshot = await fire_user.doc(uid).get();
    return Utilisateur(snapshot);
  }

  Future<Message> getMessage(String uid) async {
    DocumentSnapshot snapshot = await fire_user.doc(uid).get();
    return Message(snapshot);
  }

  Future<String> stockage(String name, Uint8List bytes) async {
    TaskSnapshot download =
        await FirebaseStorage.instance.ref("profil/$name").putData(bytes);
    String chemin = await download.ref.getDownloadURL();
    return chemin;
  }
}
