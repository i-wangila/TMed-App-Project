import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class UserService {
  static UserProfile? _currentUser;
  static final Map<String, UserProfile> _users = {}; // Simulated database
  static bool _isInitialized = false;

  // Initialize the service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Load users from storage (simulated)
    await _loadUsers();
    _isInitialized = true;
  }

  // Get current user
  static UserProfile? get currentUser => _currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _currentUser != null;

  // Sign up new user
  static Future<AuthResult> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Validate input
      if (name.trim().isEmpty) {
        return AuthResult(success: false, message: 'Name is required');
      }
      if (email.trim().isEmpty) {
        return AuthResult(success: false, message: 'Email is required');
      }
      if (phone.trim().isEmpty) {
        return AuthResult(success: false, message: 'Phone is required');
      }
      if (password.length < 6) {
        return AuthResult(
          success: false,
          message: 'Password must be at least 6 characters',
        );
      }
      if (password != confirmPassword) {
        return AuthResult(success: false, message: 'Passwords do not match');
      }

      // Check if user already exists
      if (_users.containsKey(email.toLowerCase())) {
        return AuthResult(
          success: false,
          message: 'Account with this email already exists',
        );
      }

      // Create new user
      final user = UserProfile(
        name: name.trim(),
        email: email.toLowerCase().trim(),
        phone: phone.trim(),
        password: _hashPassword(password),
      );

      // Save user
      _users[email.toLowerCase()] = user;
      _currentUser = user;

      await _saveUsers();

      if (kDebugMode) {
        print('User signed up successfully: ${user.email}');
      }

      return AuthResult(success: true, message: 'Account created successfully');
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Failed to create account: $e',
      );
    }
  }

  // Sign in existing user
  static Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      if (email.trim().isEmpty) {
        return AuthResult(success: false, message: 'Email is required');
      }
      if (password.isEmpty) {
        return AuthResult(success: false, message: 'Password is required');
      }

      final emailKey = email.toLowerCase().trim();

      // Check if user exists
      if (!_users.containsKey(emailKey)) {
        return AuthResult(success: false, message: 'Account does not exist');
      }

      final user = _users[emailKey]!;

      // Verify password
      if (!_verifyPassword(password, user.password!)) {
        return AuthResult(success: false, message: 'Invalid password');
      }

      _currentUser = user;

      if (kDebugMode) {
        print('User signed in successfully: ${user.email}');
      }

      return AuthResult(success: true, message: 'Signed in successfully');
    } catch (e) {
      return AuthResult(success: false, message: 'Failed to sign in: $e');
    }
  }

  // Sign out user
  static Future<void> signOut() async {
    _currentUser = null;
    if (kDebugMode) {
      print('User signed out');
    }
  }

  // Update user profile
  static Future<bool> updateProfile(UserProfile updatedProfile) async {
    try {
      if (_currentUser == null) return false;

      final updatedUser = updatedProfile.copyWith();
      _users[_currentUser!.email] = updatedUser;
      _currentUser = updatedUser;

      await _saveUsers();

      if (kDebugMode) {
        print('Profile updated successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update profile: $e');
      }
      return false;
    }
  }

  // Update profile picture
  static Future<bool> updateProfilePicture(String imagePath) async {
    try {
      if (_currentUser == null) return false;

      final updatedUser = _currentUser!.copyWith(profilePicturePath: imagePath);
      _users[_currentUser!.email] = updatedUser;
      _currentUser = updatedUser;

      await _saveUsers();

      if (kDebugMode) {
        print('Profile picture updated successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update profile picture: $e');
      }
      return false;
    }
  }

  // Delete account
  static Future<bool> deleteAccount() async {
    try {
      if (_currentUser == null) return false;

      _users.remove(_currentUser!.email);
      _currentUser = null;

      await _saveUsers();

      if (kDebugMode) {
        print('Account deleted successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete account: $e');
      }
      return false;
    }
  }

  // Private methods for password handling
  static String _hashPassword(String password) {
    // Simple hash for demo - in production use proper hashing like bcrypt
    return '${password.split('').reversed.join()}_hashed';
  }

  static bool _verifyPassword(String password, String hashedPassword) {
    return _hashPassword(password) == hashedPassword;
  }

  // Simulated storage methods
  static Future<void> _loadUsers() async {
    // In a real app, this would load from SharedPreferences, SQLite, or server
    // For demo, we'll start with empty users
    _users.clear();

    if (kDebugMode) {
      print('Users loaded from storage');
    }
  }

  static Future<void> _saveUsers() async {
    // In a real app, this would save to SharedPreferences, SQLite, or server
    // For demo, we'll just log

    if (kDebugMode) {
      print('Users saved to storage. Total users: ${_users.length}');
    }
  }

  // Get all users (for admin purposes)
  static List<UserProfile> getAllUsers() {
    return _users.values.toList();
  }

  // Check if email exists
  static bool emailExists(String email) {
    return _users.containsKey(email.toLowerCase().trim());
  }
}

class AuthResult {
  final bool success;
  final String message;

  AuthResult({required this.success, required this.message});
}
