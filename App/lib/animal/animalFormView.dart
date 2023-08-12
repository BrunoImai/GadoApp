import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gado_app/animal/Animal.dart';
import 'package:gado_app/user/UserAds.dart';
import 'package:gado_app/user/UserManager.dart';
import 'package:gado_app/firebase/storageService.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../userHome/homePage.dart';
import 'Animal.dart';


class NewAnimalAdForm extends StatefulWidget {

  final AnimalAd? updatedData; // Updated attribute

  const NewAnimalAdForm({super.key, this.updatedData});

  @override
  NewAnimalAdFormState createState() {
    return NewAnimalAdFormState();
  }


}

class NewAnimalAdFormState extends State<NewAnimalAdForm> {

  final _buyFormKey = GlobalKey<FormState>();

  List<ImageFile> loadedImages = [];

  List<Widget> imagePillButtons = [];

  final Storage storage = Storage();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController= TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _qttController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatedData != null) {
      _nameController.text = widget.updatedData!.name;
      _locationController.text = widget.updatedData!.localization;
      _priceController.text = widget.updatedData!.price.toString();
      _weightController.text = widget.updatedData!.weight ?? '';
      _qttController.text = widget.updatedData!.quantity?.toString() ?? '';
      _descriptionController.text = widget.updatedData!.description ?? '';
      priceTypeValue = widget.updatedData!.priceType ?? "Unid";
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

  bool isAUpdate() {
    return widget.updatedData != null;
  }

  List<String> getAllImageNames() {
    List<String> imageNames = [];
    for (var element in loadedImages) {
      imageNames.add(element.fileName);
    }
    return imageNames;
  }


  Future<void> registerAnimalAd() async {
    final String name =  _nameController.text;
    final String location =  _locationController.text;
    final double price =  double.parse(_priceController.text);
    final String weight =  _weightController.text;
    final int qtt =  int.parse(_qttController.text);
    final String description =  _descriptionController.text;
    final String priceType =  priceTypeValue;
    final List<String> images = getAllImageNames();

    AnimalAd animalRequest = AnimalAd(name: name, price: price, weight: weight, localization: location, quantity: qtt,priceType: priceType,description: description, batch: null, id: null , images: images);
    String requestBody = jsonEncode(animalRequest.toJson());

    http.Response response;

    try {
      if (isAUpdate()) {
        response = await http.put(
          Uri.parse('http://localhost:8080/api/users/${UserManager.instance
              .loggedUser!.id}/ads/animal/${widget.updatedData!.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
          },
          body: requestBody,
        );
    } else {
        response = await http.post(
          Uri.parse('http://localhost:8080/api/users/${UserManager.instance
              .loggedUser!.id}/ads/animal'),
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
  Widget build(BuildContext context) {

    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 101, 32),
          title: Text(
            (widget.updatedData == null) ? "Novo Anúncio de Animal" : "Atualizar Anúncio",
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Form(
            key: _buyFormKey,
            child: ListView(
              children: [Column(
                children: <Widget>[
                  LogoBox,
                  OneLineInputField(
                      "Titulo", controller: _nameController,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: OneLineInputField(
                          "Valor",
                          controller: _priceController,
                          suffixText: "R\$",
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        flex: 4,
                        child: DropdownButtonExample(
                          list: const ["Unid", "KG"],
                          selectedValue: priceTypeValue,
                          onChanged: handleDropdownValueChanged,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: OneLineInputField(
                          "Peso", controller: _weightController, suffixText: "KG",
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      )
                      ,
                      Flexible(
                        flex: 4,
                        child: OneLineInputField(
                          "Quantidade", controller: _qttController,
                        ),
                      ),
                    ],
                  ),

                  OneLineInputField(
                    "Local", controller: _locationController,
                  ),

                  FlatMenuButton(
                    icon: const Icon(Icons.image),
                    buttonName: "Adicionar imagem",
                      onPress: () async {
                        final results = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', 'jpeg']
                        );
                        if (results == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nenhum arquivo selecionado!'))
                          );
                          return null;
                        }
                        print(results.files.single.path);
                        addImage(results.files.single.path!, results.files.single.name);

                      }
                  ),

                  Wrap(
                    children: imagePillButtons,
                  ),

                  MultiLineInputField(
                    controller: _descriptionController, fieldLabelText: 'Descrição', visibleRows: 5,
                  ),
                  FlatMenuButton(
                    icon: const Icon(Icons.send),
                    buttonName: "Enviar",
                    onPress: () {
                      if (_buyFormKey.currentState!.validate()) {
                        registerAnimalAd();
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
          ),
        )
    );
  }
}

class OneLineInputField extends StatelessWidget {
  final String fieldLabelText;
  final TextEditingController controller;
  final String? suffixText;
  final String? prefixText;
  final String? pastText;
  const OneLineInputField(this.fieldLabelText, {super.key, required this.controller, this.suffixText, this.prefixText, this.pastText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      decoration:  InputDecoration(
          hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Colors.deepOrange,
                  width: 10
              )
          ),


          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 0, 101, 32))
          ),
          suffix: suffixText != null ? Text(suffixText!) : const Text(""),
          prefix: prefixText != null ? Text(prefixText!) : const Text(""),

          labelText: fieldLabelText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32), fontWeight: FontWeight.bold)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}

class PassWordInputField extends StatelessWidget {
  final String fieldLabelText;
  final TextEditingController controller;
  final String? suffixText;
  final String? prefixText;

  const PassWordInputField(this.fieldLabelText, {super.key, required this.controller, this.suffixText, this.prefixText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration:  InputDecoration(
          hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Colors.deepOrange,
                  width: 10
              )
          ),


          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 0, 101, 32))
          ),
          suffix: suffixText != null ? Text(suffixText!) : const Text(""),
          prefix: prefixText != null ? Text(prefixText!) : const Text(""),

          labelText: fieldLabelText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32), fontWeight: FontWeight.bold)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}

class MultiLineInputField extends StatelessWidget {
  final String fieldLabelText;
  final TextEditingController controller;
  final int visibleRows;

  const MultiLineInputField({super.key, required this.fieldLabelText, required this.controller, required this.visibleRows});

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      maxLines: visibleRows,
      controller: controller,

      decoration:  InputDecoration(
          hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32)),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),

          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 0, 101, 32))
          ),
          labelText: fieldLabelText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32), fontWeight: FontWeight.bold)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}

class MoneyField extends StatelessWidget {
  final String fieldLabelText;
  final TextEditingController controller;
  const MoneyField(this.fieldLabelText, {super.key, required this.controller});


  @override
  Widget build(BuildContext context) {
    final moneyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration:  InputDecoration(
          prefix: const Text("R\$ "),
          hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
          ),

          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 0, 101, 32))
          ),
          labelText: fieldLabelText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32), fontWeight: FontWeight.bold)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
      onChanged: (value) {
        final numberValue = double.tryParse(value.replaceAll(',', ''));
        if (numberValue != null) {
          final formattedValue = moneyFormatter.format(numberValue);
          if (value != formattedValue) {
            // Update the text field with formatted value
            WidgetsBinding.instance.addPostFrameCallback((_) {
              (context as Element).markNeedsBuild();
            });
          }
        }
      },
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  final List<String> list;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;

  const DropdownButtonExample({
    Key? key,
    required this.list,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 101, 32),
              fontWeight: FontWeight.bold,
            ),
            underline: null,
            isExpanded: true,
            value: widget.selectedValue,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: widget.onChanged,
            items: widget.list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ImagePillButton extends StatelessWidget {
  final String imageName;
  final Function() onPressed;

  const ImagePillButton({super.key,
    required this.imageName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var imageNameUpdated = imageName.length > 20 ? "${imageName.substring(0, 19)}..." : imageName;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(imageNameUpdated),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
