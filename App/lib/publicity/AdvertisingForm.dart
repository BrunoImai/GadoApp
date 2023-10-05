import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../animal/animalFormView.dart';
import '../firebase/storageService.dart';
import '../user/UserManager.dart';
import '../userHome/homePage.dart';
import 'Advertising.dart';

class AdvertisingForm extends StatefulWidget {

  final Advertising? updatedData;

  const AdvertisingForm({super.key, this.updatedData}); // Updated att

  @override
  _AdvertisingFormState createState() => _AdvertisingFormState();
}

class _AdvertisingFormState extends State<AdvertisingForm> {
  final _formKey = GlobalKey<FormState>();

  List<ImageFile> loadedImages = [];
  List<Widget> imagePillButtons = [];

  final Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    if (widget.updatedData != null) {
      _descriptionController.text = widget.updatedData!.description ?? '';
      _titleController.text = widget.updatedData!.name ?? "";
      for (var element in widget.updatedData!.images) {
        ImageFile image = ImageFile(element, "");
        loadedImages.add(image);
        imagePillButtons.add(
          ImagePillButton(
            imageName: image.fileName,
            onPressed: () => removeImage(image),
          ),
        );
      }
    }
  }


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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

  Future<void> createAdvertising() async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final List<String> images = getAllImageNames();

    Advertising adRequest = Advertising(
      name: title,
      description: description,
      images: images,
    );
    String requestBody = jsonEncode(adRequest.toJson());

    http.Response response;

    bool isAUpdate() {
      return widget.updatedData != null;
    }


    try {
      if (isAUpdate()) {
        response = await http.put(
          Uri.parse('http://localhost:8080/api/users/adm/advertising/${widget.updatedData!.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
          },
          body: requestBody,
        );
      } else {
        response = await http.post(
          Uri.parse('http://localhost:8080/api/users/adm/advertising'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
          },
          body: requestBody,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicidade Criada')),
        );
        await storage.uploadFiles(loadedImages);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 101, 32),
          title: const Text(
            "Nova Publicidade",
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
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  LogoBox,
                  OneLineInputField(
                    "Titulo",
                    controller: _titleController,
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
                          const SnackBar(
                            content: Text('Nenhuma Imagem selecionada!'),
                          ),
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
                      if (_formKey.currentState!.validate()) {
                        createAdvertising();

                      }
                    },
                  )
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