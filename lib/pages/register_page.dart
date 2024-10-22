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

  void register() async {
    final authService = AuthService();
    if (_passwordController.text == _confirmPwController.text) {
      try {
        await authService.signUpWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
        if (!mounted) return; // Ensure the widget is still mounted before using context
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Registration Successful'),
            ));
      } catch (e) {
        if (!mounted) return; // Check if the widget is still in the widget tree
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ));
      }
    } else {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Passwords don't match"),
          ));
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
            const SizedBox(height: 50),
            Text(
              "Create an account",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            CustomTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmPwController,
            ),
            const SizedBox(
              height: 25,
            ),
            CustomButton(
              text: 'Register',
              onTap: register,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member? ",
                  style:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
