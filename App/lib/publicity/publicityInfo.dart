import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/home/homePage.dart';
import 'package:gado_app/machine/machine.dart';
import 'package:http/http.dart' as http;

import '../animal/animalInfoPage.dart';
import '../user/UserManager.dart';

class PublicityInfoPage extends StatefulWidget {
  const PublicityInfoPage({Key? key, required this.machineId}) : super(key: key);
  final int machineId;

  @override
  State<PublicityInfoPage> createState() => _PublicityInfoPageState();
}

class _PublicityInfoPageState extends State<PublicityInfoPage> {
  late Future<MachineryAd> _machineAdFuture;

  @override
  void initState() {
    super.initState();
    // _machineAdFuture = _fetchAnimalAd();
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
          images: jsonData['images'].cast<String>()
      );
    } else {
      // Handle API call errors, you can show an error message or throw an exception.
      throw Exception('Failed to load machinery ad');
    }
  }

  @override
  Widget build(BuildContext context) {

    // return FutureBuilder<MachineryAd>(
    //     future: _machineAdFuture,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         // While waiting for the data, show a loading spinner.
    //         return const Center(child: CircularProgressIndicator());
    //       } else if (snapshot.hasError) {
    //         // If there was an error in the API call, show an error message.
    //         return Center(child: Text('Error: ${snapshot.error}'));
    //       } else {
    //         // Data fetched successfully, use it to populate the AnimalDetails widget.
    //         final machineryAd = snapshot.data!;

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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: Image.network(
                          "https://imagens.mfrural.com.br/mfrural-produtos-us/245984-250772-2050402-sementes-de-capim-mpg-produtos-agropecuarios.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const PublicityDetails(
                        // productName: machineryAd.name,
                        productName: "Semente",
                      ),
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Sementes boas a um preco barato",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black)),
                        // child: Text(machineryAd.description!,
                        //     style: const TextStyle(
                        //         fontWeight: FontWeight.w300,
                        //         color: Colors.black)),
                      ),
                    ],
                  ),
                ]),
              ),
            );
        //   }
        // });
  }
}

class PublicityDetails extends StatelessWidget {
  const PublicityDetails({
    Key? key,
    required this.productName,
  }) : super(key: key);
  final String productName;

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
