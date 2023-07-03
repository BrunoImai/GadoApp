import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/animal/Animal.dart';
import 'package:gado_app/land/land.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../animal/animalFormView.dart';
import '../home/homePage.dart';


class LandFormView extends StatefulWidget {
  const LandFormView({Key? key}) : super(key: key);


  @override
  State<LandFormView> createState() => _LandFormViewState();
}

class _LandFormViewState extends State<LandFormView> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: const SafeArea(
          child: Scaffold(
            body: NewLandAdForm(),
          ),
        ),
      ),
    );
  }
}

class NewLandAdForm extends StatefulWidget {
  const NewLandAdForm({super.key});

  @override
  NewLandAdFormState createState() {
    return NewLandAdFormState();
  }

}

class NewLandAdFormState extends State<NewLandAdForm> {

  final _buyFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController= TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String priceTypeValue = "Unid";

  void handleDropdownValueChanged(String? value) {
    setState(() {
      priceTypeValue = value!;
    });
  }


  Future<void> registerLandAd() async {
    final String name =  _nameController.text;
    final String location =  _locationController.text;
    final double price =  double.parse(_priceController.text);
    final String description =  _descriptionController.text;
    final String area =  _areaController.text;
    const String priceType =  "ha";

    LandAdRequest landRequest = LandAdRequest(name: name, price: price, localization: location, area: area,priceType: priceType,description: description );
    String requestBody = jsonEncode(landRequest.toJson());

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/users/2/ads/land'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODgzMjU1OTUsImV4cCI6MTY4ODQxMTk5NSwiaXNzIjoiQXV0aCBTZXJ2ZXIiLCJzdWIiOiIxIiwidXNlciI6eyJpZCI6MSwibmFtZSI6IkF1dGggU2VydmVyIEFkbWluaXN0cmF0b3IiLCJyb2xlcyI6WyJBRE1JTiJdfX0.SN8YzNc6T80f6INpLdqh6F7Tx35tXBiU0VVArrCEA-U',
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


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _buyFormKey,
      child: ListView(
          children: [Column(
            children: <Widget>[
              homePageLogo,
              OneLineInputField(
                "Titulo", controller: _nameController,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: OneLineInputField(
                      "Valor",
                      suffixText: "R\$",
                      controller: _priceController,
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                    flex: 4,
                    child: OneLineInputField("Área", controller: _areaController, suffixText: "ha",)
                  ),
                ],
              ),

              OneLineInputField(
                "Local", controller: _locationController,
              ),

              MultiLineInputField(
                controller: _descriptionController, fieldLabelText: 'Descrição', visibleRows: 5,
              ),
              FlatMenuButton(
                  icon: const Icon(Icons.send),
                  buttonName: "Enviar",
                  onPress: () {
                    if (_buyFormKey.currentState!.validate()) {
                      registerLandAd();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pedido Enviado')),
                      );
                    }
                  }
              )
            ] .map((widget) => Padding(
              padding: const EdgeInsets.all(24),
              child: widget,
            ))
                .toList(),
          ),
          ]
      ),
    );
  }
}