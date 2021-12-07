import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:watched_movies/Services/authentication.dart';
import 'package:watched_movies/widgets/snackbar.dart';

class MoviesService with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;
  String? returnURL;

  Future<String?> uploadPoster(File? _image) async {
    try {
      final storageReference =
          FirebaseStorage.instance.ref().child('posters/${_image!.path}');
      final uploadTask = storageReference.putFile(_image);
      final snapshot = await uploadTask.whenComplete(() {});
      await snapshot.ref.getDownloadURL().then((fileURL) {
        returnURL = fileURL;
      });
      notifyListeners();
      return "File Uploaded";
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future addMovies({String? name, director, File? poster}) async {
    await uploadPoster(poster).then((value) async {
      if (value == "File Uploaded") {
        try {
          final movie = await firestore
              .collection("users")
              .doc(auth?.uid)
              .collection("movies")
              .add({
            "name": "$name",
            "director": "$director",
            "image": returnURL
          }).then((value) => "Success");
          notifyListeners();
        } on FirebaseException catch (e) {
          return e.message;
        }
      } else {
        return value;
      }
    });
  }

  Future deleteMovie(
    BuildContext context,
    String? docid,
  ) async {
    try {
      final data = await firestore
          .collection("users")
          .doc(auth!.uid)
          .collection("movies")
          .doc(docid)
          .delete();
      notifyListeners();
      return AppSnackbar.of(context).success("Deleted");
    } on FirebaseException catch (e) {
      return AppSnackbar.of(context).error(e.message ?? "");
    }
  }
}
