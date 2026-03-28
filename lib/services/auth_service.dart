import 'package:firebase_auth/firebase_auth.dart';

class UserNotAuthenticated implements Exception {
  UserNotAuthenticated();
  final String cause = 'User needs to login';
}

class AuthenticationService {
  bool isUserAuthenticated() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    }

    return false;
  }

  Future<String> getUserToken() async {
    if (!isUserAuthenticated()) {
      throw UserNotAuthenticated();
    }

    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final bearerToken = 'Bearer ${token ?? (throw UserNotAuthenticated)}';
    return bearerToken;
  }
}
