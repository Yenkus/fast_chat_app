import 'package:fast_chat_app/auth/service.dart';
import 'package:fast_chat_app/components/my_button.dart';
import 'package:fast_chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void displayError(
      {required BuildContext context, required String errorMessage}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(errorMessage),
            ));
  }

  void register(BuildContext context) async {
    // get auth service instance
    AuthService authService = AuthService();

    // try to create account
    if (passwordController.text == confirmPasswordController.text) {
      try {
        authService.signUpWithEmailAndPassword(
            emailController.text, passwordController.text);
      }

      // display error
      catch (e) {
        displayError(context: context, errorMessage: e.toString());
      }
    } else {
      displayError(context: context, errorMessage: "Passwords don't match");
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
              const Text("Create an account and join in on the fun!"),
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
              // password textfield
              MyTextField(
                textEditingController: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true,
              ),

              SizedBox(
                height: size.aspectRatio * 50,
              ),

              // have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "Login here!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: size.aspectRatio * 50,
              ),

              MyButton(
                onTap: () => register(context),
                buttonText: "REGISTER",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
