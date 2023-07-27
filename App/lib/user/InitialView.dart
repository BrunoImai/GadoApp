import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gado_app/animal/animalFormView.dart';
import 'package:gado_app/user/UserManager.dart';
import 'package:gado_app/user/registerView.dart';
import 'package:gado_app/user/user.dart';
import 'package:http/http.dart' as http;

import '../home/homePage.dart';

class InitialView extends StatefulWidget {
  const InitialView({Key? key}) : super(key: key);

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  Future<void> userLogin(VoidCallback onSuccess) async {
    String email = emailController.text;
    String password = passwordController.text;

    UserLoginRequest userRequest = UserLoginRequest(email: email, password: password);
    String requestBody = jsonEncode(userRequest.toJson());

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/users/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      final jsonData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = jsonData['token'];
        final user = jsonData['user'];

        final userId = user['id'];
        final userName = user['name'];
        final userEmail = user['email'];

        UserManager.instance.loggedUser = LoggedUser(token, userId, userName, userEmail);
        onSuccess.call();
      } else {
        // Registration failed
        print('Login failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any error that occurred during the HTTP request
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              LogoBox,

              const SizedBox(height: 16.0),
              Form(
                key: _loginFormKey,
                  child: Column(
                  children: [
                    OneLineInputField(
                      "Email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 16.0),
                    PassWordInputField(
                      "Senha",
                      controller: passwordController,
                    ),
                    const SizedBox(height: 16.0),
                    FlatMenuButton(
                        icon: const Icon(Icons.send),
                        buttonName: "Login",
                        onPress: () {
                          if (_loginFormKey.currentState!.validate()) {
                            userLogin(() {
                              if (!mounted) return;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomePage())
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login Realizado')),
                              );
                            });
                          }
                        }
                    ),
                  ],
                )
              ),

              TextButton(
                  onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterView()),
              );
              }, child: const Text("Não tem uma conta ainda? Cadastre-se!", style: TextStyle(color: Color.fromARGB(255, 0, 101, 32),)),)
            ]
                .map((widget) => Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: widget,
            ))
                .toList(),
          ),
        ),
      );
  }
}
