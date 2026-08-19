import 'package:flutter/material.dart';

const String kMockEmail = 'admin@example.com';
const String kMockPassword = '123456';

class LoginScreenController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _loginError;
  String? get loginError => _loginError;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required.';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  Future<bool> handleLogin() async {
    _loginError = null;
    notifyListeners();

    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email == kMockEmail && password == kMockPassword) {
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      _loginError = 'Invalid email or password. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _loginError = null;
    notifyListeners();
  }
}
