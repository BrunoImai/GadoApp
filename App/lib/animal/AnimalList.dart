import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../firebase/storageService.dart';
import 'Animal.dart';
import 'AnimalInfoPage.dart';

class AnimalListPage extends StatefulWidget {
  const AnimalListPage({Key? key}) : super(key: key);

  @override
  State<AnimalListPage> createState() => _AnimalListPageState();
}

class _AnimalListPageState extends State<AnimalListPage> {
  bool searchBarInUse = false;
  late Future<List<AnimalAd>> futureData;

  TextEditingController searchController = TextEditingController();


  late List<String> images;
  final Storage storage = Storage();

  late List<AnimalAd> animalAds; // Add this line
  late List<AnimalAd> filteredAnimalAds; // Add this line

  @override
  void initState() {
    super.initState();
    futureData = getAllAnimalAds();
    searchController.addListener(_onSearchChanged);
    animalAds = []; // Initialize the list
    filteredAnimalAds = []; // Initialize the list
  }


  void _onSearchChanged() {
    // Update the UI to reflect the filtered list based on the search query
    setState(() {
      // Filter the data based on the search query
      filteredAnimalAds = animalAds.where((ad) {
        final name = ad.name.toLowerCase();
        final query = searchController.text.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<List<AnimalAd>> getAllAnimalAds() async {
    final response =
    await http.get(Uri.parse('http://localhost:8080/api/users/ads/animal'));
    print("Status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      final List<AnimalAd> animalAds = [];
      for (var item in jsonData) {
        final images = item['images'].cast<String>();
        String imageUrl;
        if (images.isNotEmpty) {
          imageUrl = await storage.getImageUrl(images[0]);
        } else {
          imageUrl = await storage.getImageUrl("imgNotFound.jpeg");
        }
        final animalAd = AnimalAd(
          id: item['id'],
          name: item['name'],
          price: item['price'].toDouble(),
          localization: item['localization'],
          batch: item['batch'],
          weight: item['weight'],
          quantity: item['quantity'],
          priceType: item['priceType'],
          description: item['description'],
          images: images,
          imageUrl: imageUrl,
        );
        animalAds.add(animalAd);
      }

      print(animalAds);

      return animalAds;
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load animal ads');
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => {
          FocusManager.instance.primaryFocus?.unfocus(),
          searchBarInUse = false
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 0, 101, 32),
            title: const Text(
              "Anúncios de Animais",
              style: TextStyle(color: Colors.white),
            ),
            leading: searchBarInUse ? null :
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: searchBarInUse ?
                    const Icon(
                      Icons.close,
                    ) :
                  const Icon(
                    Icons.search_rounded,
                  ),
                onPressed: () {
                  setState(() {
                    searchBarInUse = !searchBarInUse;
                  });
                },
              ),
              if (searchBarInUse)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by ad name...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0, bottom: 6, top: 6),
                child: Text(
                  "O que você procura?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 101, 32),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 4),
                child: SizedBox(
                  height: 38,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      PillButton(
                        text: 'Tudo',
                        onPressed: () {},
                      ),
                      PillButton(
                        text: 'Bovino',
                        onPressed: () {
                          // Handle button press
                          print('Button pressed!');
                        },
                      ),
                    ]
                        .map(
                          (widget) => Padding(
                            padding: const EdgeInsets.all(3),
                            child: widget,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<List<AnimalAd>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // Store the fetched data in animalAds list
                          animalAds = snapshot.data!;
                          // Filter the data based on the search query
                          filteredAnimalAds = animalAds.where((ad) {
                            final name = ad.name.toLowerCase();
                            final query = searchController.text.toLowerCase();
                            return name.contains(query);
                          }).toList();

                          return ListView.builder(
                            itemCount: filteredAnimalAds.length,
                            itemBuilder: (context, index) {
                              final data = filteredAnimalAds[index];
                              return ProductAnimal(
                                imageLink: data.imageUrl!,
                                productName: data.name,
                                batch: data.batch!,
                                localization: data.localization,
                                id: data.id!,
                                priceType: data.priceType,
                                price: data.price,
                                weight: data.weight,
                                qtt: data.quantity!,
                                onPressed: () async {
                                  // Navigate to the AnimalInfoPage and wait for the result.
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AnimalInfoPage(animalId: data.id!),
                                    ),
                                  );
                                  // Check if the result is true, and reload the list.
                                  if (result == true) {
                                    setState(() {
                                      futureData = getAllAnimalAds();
                                    });
                                  }
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductAnimal extends StatefulWidget {
  final String imageLink;
  final String productName;
  final String batch;
  final String localization;
  final int qtt;
  final int id;
  final Function? onPressed;
  final dynamic price;
  final dynamic priceType;
  final dynamic weight;
  bool? isOwner = false;

   ProductAnimal({
    Key? key,
    required this.imageLink,
    required this.productName,
    required this.batch,
    required this.localization,
    required this.qtt,
    required this.id,
    this.onPressed,
    this.price,
    this.priceType,
    this.weight, this.isOwner,
  }) : super(key: key);

  @override
  State<ProductAnimal> createState() => _ProductAnimalState();
}

class _ProductAnimalState extends State<ProductAnimal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.imageLink,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 101, 32),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lote: ${widget.batch}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.localization,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Qtde: ${widget.qtt}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                  if (widget.weight != null)
                    Text(
                      "Peso Aprox.: ${widget.weight} KG",
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.price != null
                      ? Text(
                    "R\$ ${widget.price} ${widget.priceType}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 101, 32),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                      : const Text(
                    "Consultar valor",
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ]
                .map(
                  (widget) => Padding(
                padding: const EdgeInsets.all(3),
                child: widget,
              ),
            )
                .toList(),
          ),
          onPressed: () async {
            if (widget.onPressed != null) {
              await widget.onPressed!();
            } else {
              // Navigate to the AnimalInfoPage and wait for the result.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnimalInfoPage(animalId: widget.id),
                ),
              );
            }
          },
        ),
      ),
    );  }
}

class PillButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const PillButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 101, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.0),
      ),
    );
  }
}


