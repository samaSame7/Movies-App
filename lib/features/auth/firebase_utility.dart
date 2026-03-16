import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/features/auth/user_dm.dart';

import '../../core/widgets/app_dialogues.dart';

Future<void> createUserInFirestore(UserDM user) async {
  var userCollection = FirebaseFirestore.instance.collection("users");

  // userCollection.add();
  var emptyDoc = userCollection.doc(
    user.id,
  ); // create or search for doc with id
  await emptyDoc.set(user.toJson());

}

 Future<void> updateUserProfile({
required String userId,
required String name,
required String phone,
required String avatar,
}) async {

await FirebaseFirestore.instance
    .collection("users")
    .doc(userId)
    .update({
"name": name,
"phone_number": phone,
"profile_photo": avatar,
});
}


Future<UserDM> getUserFromFirestore(String uid, User? firebaseUser) async {
  var userCollection = FirebaseFirestore.instance.collection("users");
  print("reading user from firestore");

  DocumentSnapshot snapshot = await userCollection.doc(uid).get();
  print("snapshot exists ${snapshot.exists}");

  if (!snapshot.exists || snapshot.data() == null) {
    print("creating new user");

    final newUser = UserDM(
      id: uid,
      name: firebaseUser?.displayName ?? '',
      email: firebaseUser?.email ?? '',
      phoneNumber: '', wishListCount: 0, historyCount: 0, profilePhoto: 'assets/images/avatar_1.png',
    );

    await userCollection.doc(uid).set(newUser.toJson());
    return newUser;
  }

  Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
  return UserDM.fromJson(json);
}
Future<void> verifyEmailAndResetPassword(
    BuildContext context, String email) async {
  try {
    showLoading(context);

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    Navigator.pop(context);

    showMessage(
      context,
      "Password reset link sent to your email",
      title: "Success",
      posText: "OK",
    );
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);

    if (e.code == 'user-not-found') {
      showMessage(
        context,
        "This email is not registered",
        title: "Error",
        posText: "OK",
      );
    } else {
      showMessage(
        context,
        e.message ?? "Something went wrong",
        title: "Error",
        posText: "OK",
      );
    }
  }
}
Future<void> deleteAccount(BuildContext context) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw Exception("No user logged in");

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .delete();

    await user.delete();

    UserDM.currentUser = null;

    Navigator.pop(context);

    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (route) => false);

  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); // اغلاق loading
    String message = '';
    if (e.code == 'requires-recent-login') {
      message =
      "You need to re-login before deleting your account.";
    } else {
      message = e.message ?? "Something went wrong.";
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Something went wrong.")));
  }
}