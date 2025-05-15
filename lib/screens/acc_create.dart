import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bagify_app/widgets/passward.dart';
import 'package:bagify_app/widgets/submit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _rememberMe = false;
  bool _showPassword = false;

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setBool('rememberMe', _rememberMe);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email address',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        PasswordField(
          controller: _passwordController,
          showPassword: _showPassword,
          onToggleVisibility: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon:
                  Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (val) {
                setState(() {
                  _rememberMe = val ?? false;
                });
              },
            ),
            const Text("Remember Me"),
          ],
        ),
        const Text(
          'By creating an account, you agree to our Terms of Service and Privacy Policy.',
          style: TextStyle(fontSize: 12.0),
        ),
        const SizedBox(height: 16.0),
        SubmitButton(
          onPressed: () {
            final name = _fullNameController.text.trim();
            final email = _emailController.text.trim();
            final pass = _passwordController.text.trim();
            final confirm = _confirmPasswordController.text.trim();

            if (name.isEmpty ||
                email.isEmpty ||
                pass.isEmpty ||
                confirm.isEmpty) {
              _showDialog("Error", "All fields are required.");
            } else if (pass != confirm) {
              _showDialog("Password Mismatch", "Passwords do not match.");
            } else {
              _saveCredentials();
              _showDialog("Success", "Account created successfully.");
            }
          },
        ),
      ],
    );
  }
}
