import 'package:fast_chat_app/components/my_button.dart';
import 'package:fast_chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  Function()? onTap;
  LoginPage({super.key, required this.onTap});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  textEditingController: emailController, hintText: "Email"),

              SizedBox(
                height: size.aspectRatio * 50,
              ),

              // password textfield
              MyTextField(
                textEditingController: passwordController,
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
                    onTap: onTap,
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

              MyButton(onTap: () {}, buttonText: "LOGIN"),
            ],
          ),
        ),
      ),
    );
  }
}
