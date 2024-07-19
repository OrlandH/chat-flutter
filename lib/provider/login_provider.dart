import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../provider/user_provider.dart';

enum AuthStatus { notAuthentication, checking, authenticated }

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus authStatus = AuthStatus.notAuthentication;

  Future<void> loginUser({
    required String email,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
    required UserProvider userProvider,
  }) async {
    try {
      authStatus = AuthStatus.checking;
      notifyListeners();
      // ignore: unused_local_variable
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      authStatus = AuthStatus.authenticated;
      notifyListeners();

      final User? user = _auth.currentUser;
      final userName = user?.displayName ?? user?.email ?? 'Unknown';
      userProvider.setUserName(userName);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      authStatus = AuthStatus.notAuthentication;
      notifyListeners();
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        onError('Usuario o contraseña incorrectos');
      } else {
        onError(e.toString());
      }
    } catch (e) {
      authStatus = AuthStatus.notAuthentication;
      notifyListeners();
      onError(e.toString());
    }
  }
}
