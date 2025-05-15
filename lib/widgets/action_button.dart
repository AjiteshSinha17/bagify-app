import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Sign in'),
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Create an account'),
          ),
        ),
      ],
    );
  }
}