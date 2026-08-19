import 'package:hive_flutter/hive_flutter.dart';
import '../errors/app_exception.dart';

class AuthStorageService {
  static const String _boxName = 'auth_box';

  static Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox(_boxName);
      }
    } catch (e) {
      throw StorageException('Failed to initialize auth storage: ${e.toString()}');
    }
  }

  static Box get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw const StorageException('Auth storage box is not open.');
    }
    return Hive.box(_boxName);
  }

  static Future<void> saveSession({
    required String token,
    required String email,
  }) async {
    try {
      await _box.put('user_token', token);
      await _box.put('user_email', email);
      await _box.put('is_logged_in', true);
    } catch (e) {
      throw StorageException('Failed to save auth session: ${e.toString()}');
    }
  }

  static bool isLoggedIn() {
    try {
      if (!Hive.isBoxOpen(_boxName)) return false;
      final flag = _box.get('is_logged_in', defaultValue: false);
      final token = _box.get('user_token');
      return flag == true && token != null && (token as String).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static String? getToken() {
    try {
      if (!Hive.isBoxOpen(_boxName)) return null;
      return _box.get('user_token') as String?;
    } catch (_) {
      return null;
    }
  }

  static String? getEmail() {
    try {
      if (!Hive.isBoxOpen(_boxName)) return null;
      return _box.get('user_email') as String?;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearSession() async {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        await _box.clear();
      }
    } catch (e) {
      throw StorageException('Failed to clear auth session: ${e.toString()}');
    }
  }
}
