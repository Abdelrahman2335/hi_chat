import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hi_chat/widget/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy("createdAt",
                descending:
                    true) // we are showing the messages by data using this code.
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: const Text("No message found."));
          }

          if (snapshot.hasError) {
            return const Text("Something went wrong...");
          }

          final loadedMessage = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.only(left: 13, right: 13, bottom: 40),
            reverse: true,
            itemCount: loadedMessage.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessage[index].data();
              final nextMessage = index + 1 < loadedMessage.length
                  ? loadedMessage[index + 1].data()
                  : null;

              final currentMessageUserId = chatMessage["userId"];
              final nextMessageUserId =
                  nextMessage != null ? chatMessage["userId"] : null;

              bool nextUserIsSame = currentMessageUserId == nextMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: nextMessage!["message"],
                    isMe: authUser.uid == currentMessageUserId);
              } else {
                MessageBubble.first(
                    userImage: chatMessage["profile_image"],
                    username: chatMessage["username"],
                    message: chatMessage["message"],
                    isMe: authUser.uid == currentMessageUserId);
                log(chatMessage["profile_image"]);
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
