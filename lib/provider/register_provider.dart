import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../provider/user_provider.dart';

enum AuthStatus { notAuthentication, checking, authenticated }

class RegisterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus authStatus = AuthStatus.notAuthentication;

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required Function onSuccess,
    required Function(String) onError,
    required UserProvider userProvider,
  }) async {
    try {
      authStatus = AuthStatus.checking;
      notifyListeners();
      
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();
      final User? updatedUser = _auth.currentUser;

      authStatus = AuthStatus.authenticated;
      notifyListeners();

      userProvider.setUserName(updatedUser!.displayName!);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      authStatus = AuthStatus.notAuthentication;
      notifyListeners();
      if (e.code == 'email-already-in-use') {
        onError('El email ya está en uso por otro usuario.');
      } else if (e.code == 'weak-password') {
        onError('La contraseña es demasiado débil.');
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
