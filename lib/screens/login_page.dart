import 'package:flutter/material.dart';
import 'package:bagify_app/widgets/app_bar.dart';
import 'package:bagify_app/screens/sign_in.dart';
import 'package:bagify_app/screens/acc_create.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Bagify'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Sign In'),
                  Tab(text: 'Create Account'),
                ],
                labelColor: Colors.deepPurple,
                unselectedLabelColor: Colors.grey,
              ),
              const SizedBox(height: 16.0),
              const Expanded(
                child: TabBarView(
                  children: [
                    SignInScreen(),
                    RegisterScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
