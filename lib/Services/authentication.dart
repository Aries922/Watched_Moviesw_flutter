import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watched_movies/screens/home_page.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  Future signUp({String? email, String? password}) async {
    try {
await _auth.createUserWithEmailAndPassword(
          email: email ?? "", password: password ?? "");
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "";
    }
  }

  Future signIn({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email ?? "", password: password ?? "");
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "";
    }
  }

  Future signOut() async {
    await _auth.signOut();
    print("SignOut");
  }


  Future<void> googleAuth(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
        
      // Getting users credential
      UserCredential result = await _auth.signInWithCredential(authCredential);  
       
      if (result != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }  // if result not null we simply call the MaterialpageRoute,
        // for go to the HomePage screen
    } 
  }
}
