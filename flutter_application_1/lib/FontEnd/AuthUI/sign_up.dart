import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/BackEnd/firebase/Auth/fb_auth.dart';
import 'package:flutter_application_1/BackEnd/firebase/Auth/google_auth.dart';
import 'package:flutter_application_1/BackEnd/firebase/Auth/sign_up_auth.dart';
import 'package:flutter_application_1/FontEnd/AuthUI/comomAuthMethod.dart';
import 'package:flutter_application_1/FontEnd/AuthUI/home_page.dart';
import 'package:flutter_application_1/FontEnd/AuthUI/log_in.dart';
import 'package:flutter_application_1/FontEnd/newUserEntry/new_user_entry.dart';
import 'package:flutter_application_1/Global_uses/enum_generation.dart';
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
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();
  final FacebookAuthentication _facebookAuthentication =
      FacebookAuthentication();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromRGBO(34, 48, 60, 1),
      body: LoadingOverlay(
        isLoading: _isLoading,
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
              signUpSocialMediaIntegrationButtons(),
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

            if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }

            SystemChannels.textInput.invokeMethod('TextInput.hide');

            final EmailSignUpResults response = await _emailAndPasswordAuth
                .sinUpAuth(email: _email.text, pwd: _pwd.text);

            if (response == EmailSignUpResults.SignUpCompleted) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => TakePrimaryUserData()));
            } else {
              final String msg =
                  response == EmailSignUpResults.EmailAlreadyPresent
                      ? 'Email Already Present'
                      : 'Sign Up Not Completed';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                ),
              );
            }
          } else {
            print('Not Validated');
          }

          if (mounted) {
            setState(() {
              this._isLoading = false;
            });
          }
        },
      ),
    );
  }

  Widget signUpSocialMediaIntegrationButtons() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              print('Google Pressed');
              if (mounted) {
                setState(() {
                  this._isLoading = true;
                });
              }

              final GoogleSignInResults _googleSignInResults =
                  await this._googleAuthentication.signInWithGoogle();

              String msg = '';

              if (_googleSignInResults == GoogleSignInResults.SignInCompleted) {
                msg = 'Sign In Completed';
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => TakePrimaryUserData()));
              } else if (_googleSignInResults ==
                  GoogleSignInResults.SignInNotCompleted)
                msg = 'Sign In not Completed';
              else if (_googleSignInResults ==
                  GoogleSignInResults.AlreadySignedIn)
                msg = 'Already Google SignedIn';
              else
                msg = 'Unexpected Error Happen';

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));

              // if (_googleSignInResults == GoogleSignInResults.SignInCompleted) {
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(builder: (_) => HomePage()),
              //       (route) => false);
              // }

              if (mounted) {
                setState(() {
                  this._isLoading = false;
                });
              }
            },
            child: Image.asset(
              'assets/images/google.png',
              width: 50.0,
            ),
          ),
          SizedBox(
            width: 80.0,
          ),
          GestureDetector(
            onTap: () async {
              print('Facebook Pressed');

              if (mounted) {
                setState(() {
                  this._isLoading = true;
                });
              }

              final FBSignInResults _fbSignInResults =
                  await this._facebookAuthentication.facebookLogIn();

              String msg = '';

              if (_fbSignInResults == FBSignInResults.SignInCompleted) {
                msg = 'Sign In Completed';
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => TakePrimaryUserData()),
                    (route) => false);
              } else if (_fbSignInResults == FBSignInResults.SignInNotCompleted)
                msg = 'Sign In not Completed';
              else if (_fbSignInResults == FBSignInResults.AlreadySignedIn)
                msg = 'Already fb SignedIn';
              else
                msg = 'Unexpected Error Happen';

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));

              // if (_fbSignInResults == FBSignInResults.SignInCompleted)
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(builder: (_) => HomePage()),
              //       (route) => false);

              if (mounted) {
                setState(() {
                  this._isLoading = false;
                });
              }
            },
            child: Image.asset(
              'assets/images/fbook.png',
              width: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
