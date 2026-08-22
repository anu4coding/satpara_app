import 'package:firebase_auth/firebase_auth.dart';
import '../backend/auth_service.dart';
import '../backend/firestore_service.dart';
import '../domain/models/user_model.dart';

class AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository(this._authService, this._firestoreService);

  User? get currentUser => _authService.currentUser;
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signUp(email: email, password: password);
    final uid = credential.user!.uid;
    final profile = UserModel(uid: uid, name: name, email: email);
    await _firestoreService.createUserProfile(profile);
    return profile;
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signIn(email: email, password: password);
    final uid = credential.user!.uid;
    return _firestoreService.getUserProfile(uid);
  }

  Future<void> signOut() => _authService.signOut();

  Future<void> resetPassword(String email) => _authService.sendPasswordReset(email);
}
