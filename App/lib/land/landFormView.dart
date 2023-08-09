import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gado_app/land/land.dart';
import 'package:http/http.dart' as http;

import '../animal/animalFormView.dart';
import '../firebase/storageService.dart';
import '../userHome/homePage.dart';
import '../user/UserManager.dart';

class LandFormView extends StatefulWidget {
  const LandFormView({Key? key}) : super(key: key);

  @override
  State<LandFormView> createState() => _LandFormViewState();
}

class _LandFormViewState extends State<LandFormView> {
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
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
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

  Future<void> registerLandAd() async {
    final String name = _nameController.text;
    final String location = _locationController.text;
    final double price = double.parse(_priceController.text);
    final String description = _descriptionController.text;
    final String area = _areaController.text;
    const String priceType = "ha";
    final List<String> images = imageNames;

    LandAd landRequest = LandAd(
        name: name,
        price: price,
        localization: location,
        area: area,
        priceType: priceType,
        description: description,
        batch: null,
        images: images);
    String requestBody = jsonEncode(landRequest.toJson());

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:8080/api/users/${UserManager.instance.loggedUser!.id}/ads/land'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
        },
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        print('Registration successful!');
        //TODO FIX THE IMAGE UPLOADER
        // await storage
        //     .uploadFiles(imagePaths, imageNames)
        //     .then((value) => print("Done"));
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 101, 32),
        title: const Text(
          "Novo Anúncio de Terra",
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
        child: ListView(children: [
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
                        "Área",
                        controller: _areaController,
                        suffixText: "ha",
                      )),
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
                        allowedExtensions: ['png', 'jpg', 'jpeg']);
                    if (results == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Nenhum arquivo selecionado!')));
                      return null;
                    }
                    addImage(
                        results.files.single.path!, results.files.single.name);
                  }),
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
                      registerLandAd();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pedido Enviado')),
                      );
                      Navigator.pop(context);
                    }
                  })
            ]
                .map((widget) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: widget,
                    ))
                .toList(),
          ),
        ]),
      ),
    );
  }
}
