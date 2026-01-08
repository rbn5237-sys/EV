import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/localization.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final List<String> _pin = [];
  final List<String> _confirmPin = [];
  bool _isSettingPin = false;
  bool _isConfirming = false;
  String _error = '';
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        _isSettingPin = !authProvider.hasPin;
      });
    });
  }

  void _onNumberPressed(String number) {
    HapticFeedback.lightImpact();
    
    setState(() {
      _error = '';
      if (_isConfirming) {
        if (_confirmPin.length < 4) {
          _confirmPin.add(number);
          if (_confirmPin.length == 4) {
            _verifyNewPin();
          }
        }
      } else {
        if (_pin.length < 4) {
          _pin.add(number);
          if (_pin.length == 4) {
            if (_isSettingPin) {
              _confirmPin.clear();
              _isConfirming = true;
            } else {
              _verifyPin();
            }
          }
        }
      }
    });
  }

  void _onBackspacePressed() {
    HapticFeedback.lightImpact();
    
    setState(() {
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin.removeLast();
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin.removeLast();
        }
      }
      _error = '';
    });
  }

  Future<void> _verifyPin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verifyPin(_pin.join());
    
    if (success) {
      setState(() {
        _showSuccess = true;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _error = context.tr('wrong_pin');
        _pin.clear();
      });
    }
  }

  Future<void> _verifyNewPin() async {
    if (_pin.join() == _confirmPin.join()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.setPin(_pin.join());
      
      if (success) {
        setState(() {
          _showSuccess = true;
        });
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _error = context.tr('pin_mismatch');
        _pin.clear();
        _confirmPin.clear();
        _isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    String title;
    if (_isSettingPin) {
      title = _isConfirming ? context.tr('confirm_pin') : context.tr('set_pin');
    } else {
      title = context.tr('enter_pin');
    }
    
    final currentPin = _isConfirming ? _confirmPin : _pin;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1a237e), const Color(0xFF0d47a1)]
                : [const Color(0xFF3949ab), const Color(0xFF1e88e5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _showSuccess ? Icons.check : Icons.lock_outline,
                  size: 40,
                  color: Colors.white,
                ),
              ).animate().fadeIn().scale(),
              const SizedBox(height: 30),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < currentPin.length
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  )
                      .animate(target: index < currentPin.length ? 1 : 0)
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                ),
              ),
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  _error,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                  ),
                ).animate().shake(),
              ],
              const SizedBox(height: 40),
              _buildNumberPad(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          for (int row = 0; row < 4; row++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildRow(row),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRow(int row) {
    if (row < 3) {
      return [
        for (int col = 0; col < 3; col++)
          _buildNumberButton('${row * 3 + col + 1}'),
      ];
    } else {
      return [
        const SizedBox(width: 70),
        _buildNumberButton('0'),
        _buildBackspaceButton(),
      ];
    }
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onNumberPressed(number),
        borderRadius: BorderRadius.circular(35),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onBackspacePressed,
        borderRadius: BorderRadius.circular(35),
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
