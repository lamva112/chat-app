import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/BackEnd/firebase/sign_up_auth.dart';
import 'package:flutter_application_1/FontEnd/AuthUI/comomAuthMethod.dart';
import 'package:flutter_application_1/FontEnd/AuthUI/log_in.dart';
import 'package:flutter_application_1/Global_uses/reg_exp.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SIgnUpScreen extends StatefulWidget {
  SIgnUpScreen({Key? key}) : super(key: key);

  @override
  _SIgnUpScreenState createState() => _SIgnUpScreenState();
}

class _SIgnUpScreenState extends State<SIgnUpScreen> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _conformPwd = TextEditingController();

  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();

  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromRGBO(34, 48, 60, 1),
      body: LoadingOverlay(
        isLoading: _isloading,
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 28.0, color: Colors.white),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _signUpKey,
                  child: ListView(
                    children: [
                      commonTextFormField(
                          hintText: 'Email',
                          validator: (inputVal) {
                            if (!emailRegex.hasMatch(inputVal.toString()))
                              return 'Email Format not Matching';
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
                        textEditingController: this._pwd,
                      ),
                      commonTextFormField(
                          hintText: 'Conform Password',
                          validator: (inputVal) {
                            if (inputVal!.length < 6) {
                              return 'Conform Password must be at least 6 characters';
                            }
                            if (this._pwd.text != this._conformPwd.text)
                              return 'Password and Conform Password Not Same Here';
                            return null;
                          },
                          textEditingController: this._conformPwd),
                      signUpAuthButton(context, 'Sign up'),
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
                  context, 'Already have an account?', 'Log-In'),
            ],
          ),
        ),
      ),
    ));
  }

  Widget signUpAuthButton(BuildContext context, String buttonName) {
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
        onPressed: () async {
          if (_signUpKey.currentState!.validate()) {
            print('Validated');
            SystemChannels.textInput.invokeMethod('TextInput.hide');

            _emailAndPasswordAuth.sinUpAuth(email: _email.text, pwd: _pwd.text);
          } else {
            print('Not Validated');
          }
        },
      ),
    );
  }
}
