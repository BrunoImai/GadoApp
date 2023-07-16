import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/home/homePage.dart';
import 'package:gado_app/machine/machine.dart';
import 'package:http/http.dart' as http;

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
          isFavorite: jsonData['isFavorite']
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
    final List<String> images = [
      "https://imagens.mfrural.com.br/mfrural-produtos-us/105054-413525-2173339-ensiladeira.jpg",
    ];

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
                      CarouselProducts(images),
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

class CarouselProducts extends StatefulWidget {
  final List<String> images;
  int pageIndex = 1;

  CarouselProducts(this.images, {super.key});

  @override
  State<CarouselProducts> createState() => _CarouselProductsState();
}

class _CarouselProductsState extends State<CarouselProducts> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        items: super.widget.images.map<Widget>((image) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: 300.0,
          viewportFraction: 1,
          onPageChanged: (index, reason) => {
            setState(() {
              super.widget.pageIndex = index + 1;
            })
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(90, 0, 0, 0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                '${super.widget.pageIndex}/${super.widget.images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      )
    ]);
  }
}
