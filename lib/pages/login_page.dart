import 'package:fast_chat_app/services/auth/auth_service.dart';
import 'package:fast_chat_app/components/my_button.dart';
import 'package:fast_chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    // get instance of auth service
    final AuthService authService = AuthService();
    // try login
    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    }
    // display error
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: size.aspectRatio * 200,
              ),
              SizedBox(
                height: size.aspectRatio * 50,
              ),

              // Intro text
              const Text("Welcome back!"),
              SizedBox(
                height: size.aspectRatio * 50,
              ),

              // Email address textfield
              MyTextField(
                  textEditingController: _emailController, hintText: "Email"),

              SizedBox(
                height: size.aspectRatio * 50,
              ),

              // password textfield
              MyTextField(
                textEditingController: _passwordController,
                hintText: "Password",
                obscureText: true,
              ),

              SizedBox(
                height: size.aspectRatio * 50,
              ),

              // have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have and account? "),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Register here!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: size.aspectRatio * 50,
              ),

              MyButton(onTap: login, buttonText: "LOGIN"),
            ],
          ),
        ),
      ),
    );
  }
}
