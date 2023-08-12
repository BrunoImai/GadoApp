import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:gado_app/machine/machine.dart';

import 'package:http/http.dart' as http;

import '../animal/animalFormView.dart';
import '../firebase/storageService.dart';
import '../user/UserAds.dart';
import '../userHome/homePage.dart';
import '../user/UserManager.dart';


class NewMachineryAdForm extends StatefulWidget {

  final MachineryAd? updatedData;

  const NewMachineryAdForm({super.key, this.updatedData});

  @override
  NewMachineryAdFormState createState() {
    return NewMachineryAdFormState();
  }

}

class NewMachineryAdFormState extends State<NewMachineryAdForm> {

  final _buyFormKey = GlobalKey<FormState>();

  List<ImageFile> loadedImages = [];

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
      ImageFile image = ImageFile(imageName, imagePath);
      loadedImages.add(image);
      imagePillButtons.add(
        ImagePillButton(
          imageName: imageName,
          onPressed: () => removeImage(image),
        ),
      );
    });
  }

  void removeImage(ImageFile image) {
    setState(() {
      int index = loadedImages.indexOf(image);
      loadedImages.remove(image);
      imagePillButtons.removeAt(index);
    });
  }

  List<String> getAllImageNames() {
    List<String> imageNames = [];
    for (var element in loadedImages) {
      imageNames.add(element.fileName);
    }
    return imageNames;
  }


  bool isAUpdate() {
    return widget.updatedData != null;
  }


  Future<void> registerMachineryAd() async {
    final String name =  _nameController.text;
    final String location =  _locationController.text;
    final double price =  double.parse(_priceController.text);
    final String description =  _descriptionController.text;
    final int qtt = int.parse(_qttController.text);
    const String priceType =  "Unid";
    final List<String> images = getAllImageNames();

    MachineryAd machineryRequest = MachineryAd(name: name, price: price, localization: location, quantity: qtt,priceType: priceType,description: description, id: 0, images: images );
    String requestBody = jsonEncode(machineryRequest.toJson());

    try {

      http.Response response;

      if (isAUpdate()) {
        response = await http.put(
          Uri.parse('http://localhost:8080/api/users/${UserManager.instance.loggedUser!.id}/ads/machinery/${widget.updatedData!.id}'),

          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
          },
          body: requestBody,
        );
      } else {
        response = await http.post(
          Uri.parse('http://localhost:8080/api/users/${UserManager.instance.loggedUser!.id}/ads/machinery'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
          },
          body: requestBody,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        await storage.uploadFiles(loadedImages).
        then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        )
        );
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
      ),
    );
  }

}