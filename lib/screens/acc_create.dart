import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bagify_app/widgets/passward.dart';
import 'package:bagify_app/widgets/submit.dart';
import 'package:bagify_app/screens/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _rememberMe = false;

  void onToggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _fullNameController.text.trim());
    await prefs.setString('email', _emailController.text.trim());
    await prefs.setString('password', _passwordController.text.trim());
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
        TextField(
          controller:
              _passwordController, // Ensuring controller is assigned properly
          obscureText: !_showPassword,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon:
                  Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: onToggleVisibility,
            ),
          ),
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

            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: Name is required!")),
              );
            }
            if (name.trim().isEmpty ||
                email.trim().isEmpty ||
                pass.trim().isEmpty ||
                confirm.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: All fields are required!")),
              );
            } else if (pass != confirm) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text("Password Mismatch: Passwords do not match!")),
              );
            } else {
              _saveCredentials();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Success: Account created successfully!"),
                duration: Duration(seconds: 4),
              ));

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          },
        ),
      ],
    );
  }
}
