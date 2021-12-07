import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:watched_movies/Services/authentication.dart';
import 'package:watched_movies/Services/movies.dart';
import 'package:watched_movies/screens/home_page.dart';
import 'package:watched_movies/widgets/snackbar.dart';
import 'package:watched_movies/widgets/textform_fiels.dart';

class AddMoviesPage extends StatefulWidget {
  const AddMoviesPage({Key? key}) : super(key: key);

  @override
  _AddMoviesPageState createState() => _AddMoviesPageState();
}

class _AddMoviesPageState extends State<AddMoviesPage> {
  String? name, director;
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final service = AuthenticationService();

  _imgGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    const density = VisualDensity.maximumDensity;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          "Add Movies",
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 4 * density,
                ),
                CustomTextFormField(
                  hintText: "Movie Name",
                  validator: (value) {
                    if (value?.isNotEmpty != true) {
                      return 'Please enter Movie Name';
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 4 * density,
                ),
                CustomTextFormField(
                  hintText: "Director Name",
                  validator: (value) {
                    if (value?.isNotEmpty != true) {
                      return 'Please enter Director Name';
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      director = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 4 * density,
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, spreadRadius: 1)
                      ]),
                  width: double.infinity,
                  child: Center(
                      child: _image != null
                          ? ClipRRect(
                              child: Image.file(
                                _image!,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 80, right: 80),
                              child: InkWell(
                                child: const Text(
                                  "Select Poster",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onTap: () {
                                  _imgGallery();
                                },
                              ),
                            )),
                ),
                const SizedBox(
                  height: 4 * density,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10 * VisualDensity.maximumDensity,
                      right: 10 * VisualDensity.maximumDensity),
                  child: Container(
                    height: 12 * VisualDensity.maximumDensity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black54),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () async {
                        final MoviesService request =
                            Provider.of<MoviesService>(context, listen: false);
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (isValid) {
                          _formKey.currentState!.save();
                          try {
                            await request.addMovies(
                                name: name, director: director, poster: _image);

                            AppSnackbar.of(context)
                                .success("Sucsessfully Added");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          } on FirebaseException catch (e) {
                            return AppSnackbar.of(context)
                                .error(e.message ?? "");
                          }
                        }
                      },
                      child: Center(
                        child: Text(
                          "Add",
                          style: Theme.of(context).textTheme.button!.copyWith(
                              fontSize: 4 * VisualDensity.maximumDensity,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
