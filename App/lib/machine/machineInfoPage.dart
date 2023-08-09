import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../userHome/homePage.dart';
import 'package:gado_app/machine/machine.dart';
import 'package:http/http.dart' as http;

import '../animal/animalInfoPage.dart';
import '../user/UserManager.dart';

class MachineInfoPage extends StatefulWidget {
  const MachineInfoPage({Key? key, required this.machineId}) : super(key: key);
  final int machineId;

  @override
  State<MachineInfoPage> createState() => _MachineInfoPageState();
}

class _MachineInfoPageState extends State<MachineInfoPage> {
  late Future<MachineryAd> _machineAdFuture;

  @override
  void initState() {
    super.initState();
    _machineAdFuture = _fetchAnimalAd();
  }

  Future<void> deleteAd() async {
    final response = await http.delete(
      Uri.parse(
          'http://localhost:8080/api/users/adm/machineryAd/${widget.machineId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        Navigator.pop(context, true);
      });
    }
  }

  Future<void> deleteAdAsOwner() async {
    final response = await http.delete(
      Uri.parse(
          'http://localhost:8080/api/users/machineAd/${widget.machineId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        Navigator.pop(context, true);
      });
    }
  }

  Future<MachineryAd> _fetchAnimalAd() async {
    // Make the API call to get the animal ad data based on the animalId
    // Replace 'your_api_endpoint' with the actual API endpoint to get animal details.
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/users/ads/machinery/${widget.machineId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },
    );
    if (response.statusCode == 200) {
      // Parse the response JSON and return the data.
      final jsonData = json.decode(response.body);
      return MachineryAd(
        id: jsonData['id'],
        name: jsonData['name'],
        price: jsonData['price'].toDouble(),
        localization: jsonData['localization'],
        quantity: jsonData['quantity'],
        priceType: jsonData['priceType'],
        description: jsonData['description'],
        batch: jsonData['batch'],
          isFavorite: jsonData['isFavorite'],
          images: jsonData['images'].cast<String>(),
          ownerId: jsonData['ownerId']
      );
    } else {
      // Handle API call errors, you can show an error message or throw an exception.
      throw Exception('Failed to load machinery ad');
    }
  }
  Future<void> toggleFavorite() async {

    final userId = UserManager.instance.loggedUser!.id;
    final favoriteId = widget.machineId;

    if (!isFavorite) {
      // Add the land ad to user's favorites
      final response = await http.post(Uri.parse('http://localhost:8080/api/users/$userId/favorites/machineryAd/$favoriteId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isFavorite = !isFavorite;
        });
      }
    } else {

      // Remove the land ad from user's favorites
      final response = await http.delete(Uri.parse('http://localhost:8080/api/users/$userId/favorites/machineryAd/$favoriteId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
        },);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isFavorite = !isFavorite;
        });
      }
    }
  }

  late bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MachineryAd>(
        future: _machineAdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error in the API call, show an error message.
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data fetched successfully, use it to populate the AnimalDetails widget.
            final machineryAd = snapshot.data!;
            isFavorite = machineryAd.isFavorite!;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: const Color.fromARGB(255, 0, 101, 32),
                  title: const Text(
                    "Anúncio",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      onPressed: () {
                        toggleFavorite();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                body: ListView(children: [
                  Column(
                    children: [
                      CarouselProducts(machineryAd.images),
                      MachineDetails(
                        productName: machineryAd.name,
                        batch: machineryAd.batch!,
                        localization: machineryAd.localization,
                        qtt: machineryAd.quantity!,
                        price: machineryAd.price.toString(),
                        priceType: machineryAd.priceType!,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(machineryAd.description!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black)),
                      ),
                      if (UserManager.instance.loggedUser!.isAdm)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: FlatMenuButton(
                              buttonName: "Excluir anúncio",
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPress: () {

                                deleteAd();
                              }
                          ),
                        )
                      else if (UserManager.instance.loggedUser!.id == machineryAd.ownerId)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: FlatMenuButton(
                              buttonName: "Excluir anúncio",
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPress: () {
                                deleteAdAsOwner();
                              }
                          ),
                        )
                      else
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FlatMenuButton(
                                icon: const Icon(Icons.email),
                                buttonName: "Enviar proposta",
                                onPress: () {}),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 12),
                            child: FlatMenuButton(
                                icon: const Icon(FontAwesomeIcons.whatsapp),
                                buttonName: "Chamar WhatsApp",
                                onPress: () {}),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 12),
                            child: FlatMenuButton(
                                icon: const Icon(Icons.paste_rounded),
                                buttonName: "Solicitar Financiamento",
                                onPress: () {}),
                          ),
                        ],
                      ),

                    ],
                  ),
                ]),
              ),
            );
          }
        });
  }
}

class MachineDetails extends StatelessWidget {
  const MachineDetails({
    super.key,
    required this.productName,
    required this.batch,
    required this.localization,
    required this.qtt,
    required this.price,
    required this.priceType,
  });

  final String productName;
  final String batch;
  final String localization;
  final int qtt;
  final String price;
  final String priceType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(productName,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 101, 32),
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Lote: $batch",
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
              Text(localization,
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black))
            ],
          ),
          Text("Quandidade: $qtt",
              style: const TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.black)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              price != null
                  ? Text("R\$ $price $priceType",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 101, 32),
                          fontWeight: FontWeight.bold,
                          fontSize: 18))
                  : const Text("Consultar valor",
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))
            ],
          ),
        ]
            .map((widget) => Padding(
                  padding: const EdgeInsets.all(3),
                  child: widget,
                ))
            .toList(),
      ),
    );
  }
}
