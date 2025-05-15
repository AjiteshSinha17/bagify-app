import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required TextEditingController controller, required Null Function() onToggleVisibility, required bool showPassword});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: !_showPassword,
        ),
        Row(
          children: [
            Checkbox(
              value: _showPassword,
              onChanged: (bool? value) {
                setState(() {
                  _showPassword = value ?? false;
                });
              },
            ),
            Text('Show password'),
          ],
        ),
      ],
    );
  }
}