// core/auth/auth_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Reactive user state
  final Rx<User?> user = Rx<User?>(null);

  // Auth state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    user.bindStream(_authService.authStateChanges);
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign up
  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.createUserWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  // Check if user is authenticated
  bool get isAuthenticated => user.value != null;
}
