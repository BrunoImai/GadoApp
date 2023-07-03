import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gado_app/user/user.dart';
import 'package:http/http.dart' as http;

class RegisterView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Future<void> registerUser() async {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;

      UserRequest userRequest = UserRequest(name: name, email: email, password: password);
      String requestBody = jsonEncode(userRequest.toJson());

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/users'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Registration successful
          print('Registration successful!');
        } else {
          // Registration failed
          print('Registration failed. Status code: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any error that occurred during the HTTP request
        print('Error occurred: $e');
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirme sua senha',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {

                String email = emailController.text;
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                if (password != confirmPassword) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertPopUp(errorDescription: 'As senhas não coincidem ');
                    },
                  );
                // } else if (password.length < 8 || password.length > 50){
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return const AlertPopUp(errorDescription: 'A senha deve conter entre 8 e 50 caracteres');
                //     },
                //   );
                } else {
                  registerUser();
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertPopUp extends StatelessWidget{
  const AlertPopUp({super.key, required this.errorDescription});

  final String errorDescription;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Erro'),
      content: Text(errorDescription),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

}

