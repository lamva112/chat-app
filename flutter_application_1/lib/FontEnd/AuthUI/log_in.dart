import 'package:flutter/material.dart';
import 'package:flutter_application_1/FontEnd/AuthUI/comomAuthMethod.dart';
import 'package:flutter_application_1/Global_uses/reg_exp.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _logInKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromRGBO(34, 48, 60, 1),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: Text(
                'Log in',
                style: TextStyle(fontSize: 28.0, color: Colors.white),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _logInKey,
                child: ListView(
                  children: [
                    commonTextFormField(
                        hintText: 'Email',
                        validator: (String? inputVal) {
                          if (!emailRegex.hasMatch(inputVal.toString()))
                            return 'Email format is not matching';
                          return null;
                        },
                        textEditingController: this._email),
                    commonTextFormField(
                        hintText: 'Password',
                        validator: (String? inputVal) {
                          if (inputVal!.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        },
                        textEditingController: this._pwd),
                    logInAuthButton(context, 'Log in'),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                'Or Continue With',
                style: TextStyle(color: Colors.white70, fontSize: 20.0),
              ),
            ),
            socialMediaInterationButtons(),
            switchAnotherAuthScreen(
                context, 'Don\'t Have an Account? ', 'Log-In'),
          ],
        ),
      ),
    ));
  }

  Widget logInAuthButton(BuildContext context, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width - 60, 30.0),
            elevation: 5.0,
            primary: Color.fromRGBO(57, 60, 80, 1),
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            )),
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 25.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () async {},
      ),
    );
  }
}
