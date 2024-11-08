import 'package:asau_chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:asau_chat/components/custom_button.dart';
import 'package:asau_chat/components/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final AuthService _authService = AuthService();

  static const double spacingSmall = 10.0;
  static const double spacingMedium = 25.0;
  static const double spacingLarge = 50.0;

  void _showDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(message),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmPwController.text) {
      _showDialog("Passwords don't match");
      return;
    }

    try {
      await _authService.signUpWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      _showDialog('Registration Successful');
    } catch (e) {
      _showDialog(e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: spacingLarge),
            Text(
              "Create an account",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: spacingMedium),
            CustomTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: spacingSmall),
            CustomTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: spacingSmall),
            CustomTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmPwController,
            ),
            const SizedBox(height: spacingMedium),
            CustomButton(
              text: 'Register',
              onTap: _register,
            ),
            const SizedBox(height: spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member? ",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}