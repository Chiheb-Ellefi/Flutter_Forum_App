import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';

class VerifyEmailService {
  Future sendEmailVerification(
      {isUserAnonymous, ifMountedTrue, ifMountedFalse}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (!isUserAnonymous && user != null) {
        await user.sendEmailVerification();

        ifMountedTrue();
        await Future.delayed(const Duration(seconds: 5));

        ifMountedFalse();
      }
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future checkEmailVerified(
      {isUserAnonymous, isEmailVerified, timer, setEmailVerified}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (!isUserAnonymous && user != null) {
      await user.reload();

      setEmailVerified(user: user);
      if (isEmailVerified) {
        timer?.cancel();
      }
    }
  }
}
