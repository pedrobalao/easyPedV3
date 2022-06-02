import 'package:firebase_auth/firebase_auth.dart';

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

    String bearerToken = "bearer" + (token ?? (throw UserNotAuthenticated));
    // ignore: todo
    //TODO remove it
    bearerToken =
        "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsImlhdCI6MTU0OTExMTE5N30.Ao7gDvxtuoMVyrsfeG3G6LDMZwWuIhbb4gJC5IL5Hus";
    return bearerToken;
  }
}
