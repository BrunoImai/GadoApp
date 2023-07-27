import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/animal/Animal.dart';
import 'package:gado_app/home/homePage.dart';

import 'package:http/http.dart' as http;

import '../firebase/storageService.dart';
import '../user/UserManager.dart';

class AnimalInfoPage extends StatefulWidget {
  const AnimalInfoPage({Key? key, required this.animalId}) : super(key: key);
  final int animalId;

  @override
  State<AnimalInfoPage> createState() => _AnimalInfoPageState();
}

class _AnimalInfoPageState extends State<AnimalInfoPage> {

  late Future<AnimalAd> _animalAdFuture;

  @override
  void initState() {
    super.initState();
    _animalAdFuture = _fetchAnimalAd();
  }

  Future<AnimalAd> _fetchAnimalAd() async {
    // Make the API call to get the animal ad data based on the animalId
    // Replace 'your_api_endpoint' with the actual API endpoint to get animal details.
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/users/ads/animal/${widget.animalId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },
    );
    if (response.statusCode == 200) {
      // Parse the response JSON and return the data.
      final jsonData = json.decode(response.body);
      return AnimalAd(
        id: jsonData['id'],
        name: jsonData['name'],
        price: jsonData['price'].toDouble(),
        localization: jsonData['localization'],
        batch: jsonData['batch'],
        weight: jsonData['weight'],
        quantity: jsonData['quantity'],
        priceType: jsonData['priceType'],
        description: jsonData['description'],
        isFavorite: jsonData['isFavorite'],
        images: jsonData['images'].cast<String>()
      );
    } else {
      // Handle API call errors, you can show an error message or throw an exception.
      throw Exception('Failed to load animal ad');
    }
  }

  late bool isFavorite = false;

  Future<void> toggleFavorite() async {

    final userId = UserManager.instance.loggedUser!.id;
    final favoriteId = widget.animalId;

    if (kDebugMode) {
      print("Print funfa");
    }

    if (!isFavorite) {
      // Add the land ad to user's favorites
      final response = await http.post(Uri.parse('http://localhost:8080/api/users/$userId/favorites/animalAd/$favoriteId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isFavorite = !isFavorite;
          print("Entrei");
        });
      }
    } else {

      // Remove the land ad from user's favorites
      final response = await http.delete(Uri.parse('http://localhost:8080/api/users/$userId/favorites/animalAd/$favoriteId'),
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

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<AnimalAd>(
        future: _animalAdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error in the API call, show an error message.
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data fetched successfully, use it to populate the AnimalDetails widget.
            final animalAd = snapshot.data!;
            isFavorite = animalAd.isFavorite!;
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
                      CarouselProducts(animalAd.images),
                      AnimalDetails(
                        productName: animalAd.name,
                        batch: animalAd.batch!,
                        localization: animalAd.localization,
                        qtt: animalAd.quantity!,
                        weight: animalAd.weight.toString(),
                        price: animalAd.price.toString(),
                        priceType: animalAd.priceType!,
                      ),
                       Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text( animalAd.description!,
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
        }
    );
  }
}
class AnimalDetails extends StatelessWidget {
  const AnimalDetails({
    super.key,
    required this.productName,
    required this.batch,
    required this.localization,
    required this.qtt,
    required this.weight,
    required this.price,
    required this.priceType,
  });

  final String productName;
  final String batch;
  final String localization;
  final int qtt;
  final String weight;
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
          Text("Qtde: $qtt",
              style: const TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.black)),
          if (weight != null)
            Text("Peso Aprox.: $weight KG",
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

  CarouselProducts(this.images, {Key? key}) : super(key: key);

  @override
  State<CarouselProducts> createState() => _CarouselProductsState();
}

class _CarouselProductsState extends State<CarouselProducts> {
  final Storage storage = Storage();
  List<Widget> carouselItems = [];

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
  }

  Future<void> fetchCarouselImages() async {
    for (final image in widget.images) {
      final imageUrl = await storage.getImageUrl(image);
      setState(() {
        carouselItems.add(
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: carouselItems,
          options: CarouselOptions(
            height: 300.0,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                widget.pageIndex = index + 1;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(90, 0, 0, 0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  '${widget.pageIndex}/${widget.images.length}',
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
      ],
    );
  }
}
