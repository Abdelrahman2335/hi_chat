import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController messageCon = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    messageCon.dispose();
  }

  void sendmessage() async {
    final String enterdedMessage = messageCon.text;

    if (enterdedMessage.trim() == "") {
      return;
    }

    // this will unfocus the keybord
    FocusScope.of(context).unfocus();

    // we used [clear] to clear the data inside the textfiled so we will sned something else later
    messageCon.clear();

    final User user = FirebaseAuth.instance.currentUser!;

    // Here we are geting the data from the FirebaseFirestor, don't forget we have to [wait] so use [await]
    final userData =
        await FirebaseFirestore.instance.collection("user").doc(user.uid).get();

    await FirebaseFirestore.instance.collection("chat").add(
      {
        "message": enterdedMessage,
        "createdAt": Timestamp.now(),
        "userId": user.uid,
        "username": userData.data()!["username"],
        "profile_image": userData.data()!["profile_image"],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 1, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageCon,
              autocorrect: true,
              enableSuggestions: true,
            ),
          ),
          IconButton(
            onPressed: sendmessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
