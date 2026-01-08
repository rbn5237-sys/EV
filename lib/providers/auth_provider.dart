import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  bool _isAuthenticated = false;
  bool _hasPin = false;
  bool _isLoading = true;
  
  bool get isAuthenticated => _isAuthenticated;
  bool get hasPin => _hasPin;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkPinStatus();
  }

  Future<void> _checkPinStatus() async {
    _isLoading = true;
    notifyListeners();
    
    final storedHash = await _storage.read(key: 'pin_hash');
    _hasPin = storedHash != null && storedHash.isNotEmpty;
    
    _isLoading = false;
    notifyListeners();
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> setPin(String pin) async {
    try {
      final hash = _hashPin(pin);
      await _storage.write(key: 'pin_hash', value: hash);
      _hasPin = true;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      final storedHash = await _storage.read(key: 'pin_hash');
      final inputHash = _hashPin(pin);
      
      if (storedHash == inputHash) {
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    final isValid = await verifyPin(oldPin);
    if (!isValid) return false;
    
    return await setPin(newPin);
  }

  Future<void> resetPin() async {
    await _storage.delete(key: 'pin_hash');
    _hasPin = false;
    _isAuthenticated = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
