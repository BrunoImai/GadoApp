import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:gado_app/machine/machine.dart';

import 'package:http/http.dart' as http;

import '../animal/animalFormView.dart';
import '../firebase/storageService.dart';
import '../home/homePage.dart';
import '../user/UserManager.dart';


class MachineryFormView extends StatefulWidget {
  const MachineryFormView({Key? key}) : super(key: key);


  @override
  State<MachineryFormView> createState() => _MachineryFormViewState();
}

class _MachineryFormViewState extends State<MachineryFormView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
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

  List<String> imagePaths = [];
  List<String> imageNames = [];
  List<Widget> imagePillButtons = [];

  final Storage storage = Storage();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController= TextEditingController();
  final TextEditingController _qttController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String priceTypeValue = "Unid";

  void handleDropdownValueChanged(String? value) {
    setState(() {
      priceTypeValue = value!;
    });
  }

  void addImage(String imagePath, String imageName) {
    setState(() {
      imagePaths.add(imagePath);
      imageNames.add(imageName);
      imagePillButtons.add(
        ImagePillButton(
          imageName: imageName,
          onPressed: () => removeImage(imageName),
        ),
      );
    });
  }

  void removeImage(String imageName) {
    setState(() {
      int index = imageNames.indexOf(imageName);
      imagePaths.removeAt(index);
      imageNames.removeAt(index);
      imagePillButtons.removeAt(index);
    });
  }

  Future<void> registerMachineryAd() async {
    final String name =  _nameController.text;
    final String location =  _locationController.text;
    final double price =  double.parse(_priceController.text);
    final String description =  _descriptionController.text;
    final int qtt = int.parse(_qttController.text);
    const String priceType =  "Unid";
    final List<String> images = imageNames;

    MachineryAd machineryRequest = MachineryAd(name: name, price: price, localization: location, quantity: qtt,priceType: priceType,description: description, id: 0, images: images );
    String requestBody = jsonEncode(machineryRequest.toJson());

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/users/${UserManager.instance.loggedUser!.id}/ads/machinery'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
        },
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        print('Registration successful!');
        await storage.uploadFiles(imagePaths, imageNames).
        then((value) => print("Done"));
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
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 101, 32),
        title: const Text(
          "Novo Anúncio de Máquina",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _buyFormKey,
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                LogoBox,
                OneLineInputField(
                  "Titulo",
                  controller: _nameController,
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
                      child: OneLineInputField(
                        "Quantidade",
                        controller: _qttController,
                      ),
                    ),
                  ],
                ),
                OneLineInputField(
                  "Local",
                  controller: _locationController,
                ),
                FlatMenuButton(
                  icon: const Icon(Icons.image),
                  buttonName: "Adicionar imagem",
                  onPress: () async {
                    final results = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg', 'jpeg'],
                    );
                    if (results == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nenhum arquivo selecionado!')),
                      );
                      return null;
                    }
                    addImage(
                      results.files.single.path!,
                      results.files.single.name,
                    );
                  },
                ),
                Wrap(
                  children: imagePillButtons,
                ),
                MultiLineInputField(
                  controller: _descriptionController,
                  fieldLabelText: 'Descrição',
                  visibleRows: 5,
                ),
                FlatMenuButton(
                  icon: const Icon(Icons.send),
                  buttonName: "Enviar",
                  onPress: () {
                    if (_buyFormKey.currentState!.validate()) {
                      registerMachineryAd();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pedido Enviado')),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ]
                  .map((widget) => Padding(
                padding: const EdgeInsets.all(24),
                child: widget,
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

}