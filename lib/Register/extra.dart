import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  static final _OAUTH = GoogleSignIn(scopes: ['email']);

  static void googleSignIn() async {
    final GoogleSignInAccount? acc = await _OAUTH.signIn();

    if(acc != null) {
      print('Logged in Email: ${acc.email}');
    }
  }
}
