import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hi_chat/widget/user_image.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final firebase = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLogin = true;
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  File? _selectedImage;
  bool isUpLoading = false;

  void submit() async {
    final valid = formKey.currentState!.validate();
    try {
      isUpLoading = true;
      if (!valid && (!isLogin && _selectedImage == null)) {
        /// This mean Go Back
        return;
      } else {
        if (isLogin) {
          final UserCredential userCredential =
              await firebase.signInWithEmailAndPassword(
                  email: emailCon.text, password: passCon.text);
        } else {
          final UserCredential userCredential =
              await firebase.createUserWithEmailAndPassword(
                  email: emailCon.text, password: passCon.text);

          final Reference storageRef = FirebaseStorage.instance
              .ref()
              .child("user_images")
              .child("${userCredential.user!.uid}.jpg");

          storageRef.putFile(_selectedImage!);
          final imageUrl = storageRef.getDownloadURL();
        }
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            /// Note you have access on this 'message' because we let catch focus only on FirebaseAuthException only
            error.message ?? "Authentication Error",
          ),
        ),
      );
      setState(() {
        isUpLoading = false;
      });
    }

    formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 30, bottom: 30, left: 20, right: 20),
              width: 200,
              child: Image.asset("assets/chat.png"),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              /// using Expanded here is essential because, this widget will be scrollable, [Don't use SingleChildScrollView]
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        if (!isLogin)
                          UserImagePicker(
                            onSelectedImage: (File pickedImage) {

                              _selectedImage = pickedImage;
                            },
                          ),

                        /// This is Flutter if statement, not Dart.
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Email Address"),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return "Invalid Email";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: emailCon,
                          autocorrect: false,
                          onSaved: (value) => emailCon.text = value!,

                          /// this correct errors to the user
                          textCapitalization: TextCapitalization.none,

                          /// this makes the first letter is Capital
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          obscureText: true,
                          controller: passCon,
                          onSaved: (value) => passCon.text = value!,
                          validator: (value) {
                            if (value == null || value.trim().length <= 6) {
                              return "Password must be more than more 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (isUpLoading) const CircularProgressIndicator(),

                        if (!isUpLoading)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            onPressed: submit,
                            child: Text(
                              isLogin ? "Login" : "Sign Up",
                            ),
                          ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (isUpLoading) const CircularProgressIndicator(),
                        if (!isUpLoading)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                                emailCon.text = '';
                                passCon.text = '';
                              });
                            },
                            child: Text(
                              isLogin
                                  ? "Create an Account"
                                  : "Already have an account",
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
