import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_prj/first_screen.dart';

// final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithPhone(String phoneNumber, BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userStr = "";
  final _codeController = TextEditingController();
  await Firebase.initializeApp();
  _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        print('verificationCompletedListener');
        print(phoneAuthCredential.toString());
        // final UserCredential authResult =
        //     await _auth.signInWithCredential(phoneAuthCredential);
        // print(authResult);
        // final User user = authResult.user;

        // if (user != null) {
        //   assert(!user.isAnonymous);
        //   assert(await user.getIdToken() != null);

        //   final User currentUser = _auth.currentUser;
        //   assert(user.uid == currentUser.uid);

        //   print('signInWithPhone succeeded: $user');

        //   // return '$user';
        // }
      },
      verificationFailed: (FirebaseAuthException exception) {
        print(exception);
      },
      codeSent: (String verificationId, int forceResendingToken) {
        print('codeSent call back');
        print('forceResendingToken= $forceResendingToken');
        print('verificationId= $verificationId');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Give the code?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: code);

                      var result = await _auth.signInWithCredential(credential);

                      final User user = result.user;

                      if (user != null) {
                        assert(!user.isAnonymous);
                        assert(await user.getIdToken() != null);

                        final User currentUser = _auth.currentUser;
                        assert(user.uid == currentUser.uid);

                        print('signInWithPhone succeeded: $user');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FirstScreen()));
                        // return '$user';
                      } else {
                        print("Error");
                      }
                    },
                  )
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: null);
  return userStr;
}

// Future<void> signOutGoogle() async {
//   await googleSignIn.signOut();

//   print("User Signed Out");
// }
