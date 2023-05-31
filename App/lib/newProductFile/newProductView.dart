import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home/homePage.dart';

class NewProductView extends StatefulWidget {
  const NewProductView({Key? key}) : super(key: key);


  @override
  State<NewProductView> createState() => _NewProductViewState();
}

class _NewProductViewState extends State<NewProductView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: const SafeArea(
          child: Scaffold(
            body: NewProductForm(),
          ),
        ),
      ),
    );
  }
}

class NewProductForm extends StatefulWidget {
  const NewProductForm({super.key});

  @override
  NewProductFormState createState() {
    return NewProductFormState();
  }
}

class NewProductFormState extends State<NewProductForm> {

  final _buyFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _buyFormKey,
      child: ListView(
        children: [Column(
          children: <Widget>[
            homePageLogo,
            const NewProductField("Nome Completo"),
            const NewProductField("Celular / WhatsApp"),
            const NewProductField("E-mail (opcional)"),
            const NewProductField("Cidade"),
            const NewProductField("O que deseja vender?"),
            FlatMenuButton(
              icon: const Icon(Icons.send),
              buttonName: "Enviar",
              onPress: () {
                if (_buyFormKey.currentState!.validate()) {
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

class NewProductField extends StatelessWidget {
  final String fieldLabelText;
  const NewProductField(this.fieldLabelText, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:  InputDecoration(
        hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 101, 32)),
        border: const UnderlineInputBorder(),

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
