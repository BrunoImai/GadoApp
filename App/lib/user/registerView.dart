import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gado_app/animal/animalFormView.dart';
import 'package:gado_app/user/user.dart';
import 'package:http/http.dart' as http;

import '../home/homePage.dart';
import 'UserManager.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {

    Future<void> registerUser(VoidCallback onSuccess) async {
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
        final jsonData = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Registration successful
          final token = jsonData['token'];
          final user = jsonData['user'];

          final userId = user['id'];
          final userName = user['name'];
          final userEmail = user['email'];

          UserManager.instance.loggedUser = LoggedUser(token, userId, userName, userEmail);
          onSuccess.call();
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
        title: const Text('Cadastro'),
        backgroundColor: const Color.fromARGB(255, 0, 101, 32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OneLineInputField("Nome", controller: nameController),
            const SizedBox(height: 32.0),
            OneLineInputField("Email", controller: emailController),
            const SizedBox(height: 32.0),
            PassWordInputField("Senha", controller: passwordController),
            const SizedBox(height: 32.0),
            PassWordInputField("Confirme sua senha", controller: confirmPasswordController),
            const SizedBox(height: 48.0),
            FlatMenuButton(
              icon: const Icon(Icons.send),
              buttonName: "Registro",
              onPress: () {
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                if (password != confirmPassword) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertPopUp(errorDescription: 'As senhas não coincidem ');
                    },
                  );
                } else {
                  registerUser(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage())
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Realizado')),
                    );
                  });
                }
              },
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

