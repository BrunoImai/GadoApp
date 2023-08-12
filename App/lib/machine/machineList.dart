import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gado_app/machine/machine.dart';
import 'package:gado_app/machine/machineInfoPage.dart';
import 'package:http/http.dart' as http;

import '../firebase/storageService.dart';

class MachineryListPage extends StatefulWidget {
  const MachineryListPage({super.key});

  @override
  State<MachineryListPage> createState() => _MachineryListPageState();
}

class _MachineryListPageState extends State<MachineryListPage> {
  bool searchBarInUse = false;
  late Future<List<MachineryAd>> futureData;
  late List<String> images;
  final Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    futureData = getAllMachineryAds();
  }

  Future<List<MachineryAd>> getAllMachineryAds() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/users/ads/machinery'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      List<MachineryAd> machineryAds = [];
      for (var item in jsonData) {
        final images = item['images'].cast<String>();
        String imageUrl;
        if (images.isNotEmpty) {
          imageUrl = await storage.getImageUrl(images[0]);
        } else {
          imageUrl = await storage.getImageUrl("imgNotFound.jpeg");
        }
        machineryAds = jsonData.map((item) {
          return MachineryAd(
              id: item['id'],
              name: item['name'],
              price: item['price'].toDouble(),
              localization: item['localization'],
              quantity: item['quantity'],
              priceType: item['priceType'],
              description: item['description'],
              images: images,
              imageUrl: imageUrl
          );
        }).toList();
      }

      var imageUrlList = [];

      for (var element in machineryAds) {
        imageUrlList.add(await storage.getImageUrl(element.images[0]));
      }

      images = imageUrlList.cast<String>();

      return machineryAds;
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load machinery ads');
      // Request failed
      throw Exception('Failed to load animal ads');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ColorFiltered(
        colorFilter: ColorFilter.mode(
            searchBarInUse
                ? Colors.black54
                : const Color.fromARGB(0, 0, 101, 32),
            BlendMode.darken),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 0, 101, 32),
            title: const Text(
              "Anúncios de Máquinas",
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
                icon: const Icon(
                  Icons.search_rounded,
                ),
                onPressed: () {
                  setState(() {
                    searchBarInUse = !searchBarInUse;
                  });
                },
              ),
            ],
          ),
          body: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0, bottom: 6, top: 6),
                    child: Text(
                      "O que você procura?",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 101, 32),
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ],
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
                          onPressed: () {
                            // Handle button press
                            print('Button pressed!');
                          }),
                      PillButton(
                          text: 'Cabines',
                          onPressed: () {
                            // Handle button press
                            print('Button pressed!');
                          }),
                      PillButton(
                          text: 'Colheitadeiras',
                          onPressed: () {
                            // Handle button press
                            print('Button pressed!');
                          }),
                      PillButton(
                          text: 'Escavadeiras',
                          onPressed: () {
                            // Handle button press
                            print('Button pressed!');
                          }),
                      PillButton(
                          text: 'Grades',
                          onPressed: () {
                            // Handle button press
                            print('Button pressed!');
                          }),
                      PillButton(
                          text: 'Plantadeiras',
                          onPressed: () {
                            // Handle button press
                            print('Button pressed!');
                          }),
                    ]
                        .map((widget) => Padding(
                              padding: const EdgeInsets.all(3),
                              child: widget,
                            ))
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<List<MachineryAd>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return ProductMachine(
                                imageLink: data.imageUrl!,
                                productName: data.name,
                                batch: data.batch!,
                                localization: data.localization,
                                id: data.id!,
                                priceType: data.priceType,
                                price: data.price,
                                qtt: data.quantity!,
                                onPressed: () async {
                                  // Navigate to the AnimalInfoPage and wait for the result.
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MachineInfoPage(machineId: data.id!),
                                    ),
                                  );
                                  // Check if the result is true, and reload the list.
                                  if (result == true) {
                                    setState(() {
                                      futureData = getAllMachineryAds();
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

class ProductMachine extends StatefulWidget {
  final String imageLink;
  final String productName;
  final String batch;
  final String localization;
  final int qtt;
  final int id;
  final Function? onPressed;
  final dynamic price;
  final dynamic priceType;

  const ProductMachine({
    Key? key,
    required this.imageLink,
    required this.productName,
    required this.batch,
    required this.localization,
    required this.qtt,
    required this.id,
    this.price,
    this.priceType,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ProductMachine> createState() => _ProductMachineState();
}

class _ProductMachineState extends State<ProductMachine> {
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
                    "Quantidade: ${widget.qtt}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      MachineInfoPage(machineId: widget.id),
                ),
              );
            }
          },
        ),
      ),
    );
  }
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
        backgroundColor: const Color.fromARGB(
            255, 0, 101, 32), // Change the color as per your preference
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Adjust the radius as per your preference
        ),
      ),
      child: Text(
        text,

        style: const TextStyle(
            fontSize: 12.0), // Adjust the font size as per your preference
      ),
    );
  }
}
