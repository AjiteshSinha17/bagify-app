import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bagify_app/widgets/passward.dart';
import 'package:bagify_app/widgets/submit.dart';
import 'package:bagify_app/screens/home.dart'; // Make sure HomeScreen exists

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setBool('rememberMe', _rememberMe);
  }

  void _validateAndSubmit() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    
  //  print("Email: $email, Password: $password");
   
   
    bool isEmailValid =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(email);

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: All fields are required!")),
      );
      return; // Stop execution to prevent login
    }

    if (!isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Invalid email format!")),
      );
      return;
    }

    if (password.trim().length < 8 || password.trim().length > 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error: Password must be between 8-16 characters!")),
      );
      return;
    }

    if (_rememberMe) {
      _saveCredentials();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Success: Credentials saved!")),
      );
    }

    // Navigate to Home Screen **ONLY** if all validations pass
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
              labelText: 'Email address', border: OutlineInputBorder()),
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
        SubmitButton(onPressed: _validateAndSubmit),
      ],
    );
  }
}
