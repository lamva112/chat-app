import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/BackEnd/firebase/Auth/fb_auth.dart';
import 'package:flutter_application_1/BackEnd/firebase/Auth/google_auth.dart';
import 'package:flutter_application_1/BackEnd/firebase/Auth/sign_up_auth.dart';
import 'package:flutter_application_1/FontEnd/AuthUI/log_in.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();
  final FacebookAuthentication _facebookAuthentication =
      FacebookAuthentication();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: ElevatedButton(
          child: Text(
            'log out',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            final bool googleResponse =
                await this._googleAuthentication.logOut();

            if (!googleResponse) {
              final bool fbResponse =
                  await this._facebookAuthentication.logOut();

              if (!fbResponse) await this._googleAuthentication.logOut();
            }

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false);
          },
        ),
      ),
    );
  }
}
