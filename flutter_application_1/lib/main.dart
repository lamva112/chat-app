import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/BackEnd/firebase/OnlineDatabaseManagement/cloud_data_management.dart';
import 'package:flutter_application_1/FontEnd/AuthUI/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';

import 'FontEnd/AuthUI/log_in.dart';
import 'FontEnd/MainScreen/main_screens.dart';
import 'FontEnd/newUserEntry/new_user_entry.dart';

Future<void> main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Generation',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: await differentContextDecisionTake(),
    ),
  );
}

Future<Widget> differentContextDecisionTake() async {
  if (FirebaseAuth.instance.currentUser == null) {
    return LoginScreen();
  } else {
    final CloudStoreDataManagement _cloudStoreDataManagement =
        CloudStoreDataManagement();

    final bool _dataPresentResponse =
        await _cloudStoreDataManagement.userRecordPresentOrNot(
            email: FirebaseAuth.instance.currentUser!.email.toString());

    return _dataPresentResponse ? MainScreen() : TakePrimaryUserData();
  }
}
