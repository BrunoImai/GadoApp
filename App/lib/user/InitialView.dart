import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gado_app/animal/animalFormView.dart';
import 'package:gado_app/user/UserManager.dart';
import 'package:gado_app/user/registerView.dart';
import 'package:gado_app/user/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../userHome/homePage.dart';

class InitialView extends StatefulWidget {
  const InitialView({Key? key}) : super(key: key);

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isAdm = false;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkEulaStatus();
  }

  Future<void> _checkEulaStatus() async {
    // Check if the user has accepted the EULA before.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool eulaAccepted = prefs.getBool('eula_accepted') ?? false;

    if (!eulaAccepted) {
      // Show the EULA dialog if it has not been accepted before.
      bool userAcceptedEula = await _showEulaDialog(context);

      // Store the user's decision in shared preferences.
      await prefs.setBool('eula_accepted', userAcceptedEula);

      // If the user declines the EULA, you may choose to close the app or restrict functionality.
      if (!userAcceptedEula) {
        // For example, you can close the app:
        // SystemNavigator.pop();
      }
    }
  }

  Future<bool> _showEulaDialog(BuildContext context) async {
    // Show the dialog and handle the nullable return type.
    bool? userAcceptedEula = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EulaDialog(),
    );

    // If userAcceptedEula is null, consider it as declined (false).
    return userAcceptedEula ?? false;
  }

  Future<void> userLogin(VoidCallback onSuccess) async {
    String email = emailController.text;
    String password = passwordController.text;

    UserLoginRequest userRequest = UserLoginRequest(cellphone: email, password: password);
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
        final userRoles = user['roles'];

        isAdm = (userRoles.contains("ADMIN"));
        UserManager.instance.loggedUser = LoggedUser(token, userId, userName, userEmail, isAdm);
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
                    "Celular",
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
                            MaterialPageRoute(builder: (context) => const UserHomePage()),
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
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterView()),
                );
              },
              child: const Text(
                "Não tem uma conta ainda? Cadastre-se!",
                style: TextStyle(color: Color.fromARGB(255, 0, 101, 32)),
              ),
            ),
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


class EulaDialog extends StatelessWidget {
  const EulaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('End User License Agreement'),
      content: const SingleChildScrollView(
        child: Text(
          '"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"',
          style: TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // User agrees to the EULA.
            Navigator.of(context).pop(true);
          },
          child: const Text('Aceitar termos',
            style: TextStyle(color: Color.fromARGB(255, 0, 101, 32)),),
        ),
      ],
    );
  }
}

