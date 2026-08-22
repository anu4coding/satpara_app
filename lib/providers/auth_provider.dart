import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/auth_repository.dart';
import '../domain/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;

  AuthProvider(this._repo) {
    _repo.authStateChanges.listen((user) {
      _firebaseUser = user;
      notifyListeners();
    });
  }

  User? _firebaseUser;
  UserModel? profile;
  bool isLoading = false;
  String? errorMessage;

  User? get firebaseUser => _firebaseUser;
  bool get isLoggedIn => _firebaseUser != null;

  Future<bool> signUp(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      profile = await _repo.signUp(name: name, email: email, password: password);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      profile = await _repo.signIn(email: email, password: password);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    profile = null;
    notifyListeners();
  }
}
