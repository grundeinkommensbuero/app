import 'User.dart';

class Login {
  User user;
  String secret;
  String firebaseKey;

  Login(this.user, this.secret, this.firebaseKey);

  Map<String, dynamic> toJson() => {
        'user': user,
        'secret': secret,
        'firebaseKey': firebaseKey,
      ***REMOVED***
***REMOVED***
