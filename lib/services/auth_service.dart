import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserNotAuthenticated implements Exception {
  final String cause = "User needs to login";
  UserNotAuthenticated();
}

class AuthenticationService {
  bool isUserAuthenticated() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    }

    return false;
  }

  Future<String> getUserToken() async {
    if (!isUserAuthenticated()) {
      throw UserNotAuthenticated();
    }

    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    String? bearerToken = "bearer" + (token ?? (throw UserNotAuthenticated));
    // ignore: todo
    //TODO remove it
    bearerToken = dotenv.env['TEST_TOKEN'];
    return bearerToken!;
  }
}
