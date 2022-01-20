import 'package:firebase_auth/firebase_auth.dart';

class EmailAndPasswordAuth {
  Future<bool> sinUpAuth({required String email, required String pwd}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);
      if (userCredential.user!.email != null) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error in Email and Password Sign Up: ${e.toString()}');
      return false;
    }
  }
}
