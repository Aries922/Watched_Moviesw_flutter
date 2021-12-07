import 'package:flutter/material.dart';
import 'package:watched_movies/Services/authentication.dart';
import 'package:watched_movies/screens/home_page.dart';
import 'package:watched_movies/screens/signup_page.dart';
import 'package:watched_movies/widgets/buttons.dart';
import 'package:watched_movies/widgets/textform_fiels.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String? email, password;

  final _formkey = GlobalKey<FormState>();
  final service = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    const density = VisualDensity.maximumDensity;



    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 35 * density,
                ),
                const Center(
                    child: Text(
                  "Movies",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                )),
                const Center(
                    child: Text(
                  "Watched",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      color: Colors.black),
                )),
                const SizedBox(
                  height: 20 * density,
                ),
                CustomTextFormField(
                  validator: (value) {
                    if (value?.isNotEmpty != true) {
                      return 'Please enter Password';
                    }
                    if (value?.contains("@") != true) {
                      return 'Please enter a Valid Email';
                    }
                  },
                  hintText: "Email",
                  onSaved: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5 * density,
                ),
                MyPasswordField(
                  hintText: "Password",
                  validator: (value) {
                    if (value?.isNotEmpty != true) {
                      return 'Please enter Password';
                    } else if (value!.length <= 6) {
                      return 'Password Should be more than 6 Letter ';
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5 * density,
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
                        color: Colors.black38),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        final isvalid =
                            _formkey.currentState?.validate() ?? false;
                        if (isvalid) {
                          _formkey.currentState!.save();
                          service
                              .signIn(email: email, password: password)
                              .then((value) {
                            if (value == null) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (route) => false);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(value)));
                            }
                          });
                        }
                      },
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: Theme.of(context).textTheme.button!.copyWith(
                              fontSize: 4 * VisualDensity.maximumDensity,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2 * density,
                ),
                Center(
                    child: CustomRichText(
                  textonly: "Don't have an account?",
                  textforclick: "Sign Up",
                  onClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                )),
                const SizedBox(
                  height: 6 * density,
                ),
                Row(
                  children: const [
                    Expanded(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Text("  Or Login With  ",
                        style: TextStyle(color: Colors.grey)),
                    Expanded(
                        child: Divider(
                      color: Colors.black,
                    ))
                  ],
                ),
                InkWell(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15 * density),
                    child: Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 25),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/google.png'),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ))),
                  ),
                  onTap: () async {
                    service.googleAuth(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
