import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/land/landFormView.dart';
import '../user/user.dart';
import '../userHome/homePage.dart';
import 'package:gado_app/land/land.dart';
import 'package:gado_app/user/UserManager.dart';

import 'package:http/http.dart' as http;

import '../animal/animalInfoPage.dart';

class LandInfoPage extends StatefulWidget {
  const LandInfoPage({Key? key, required this.landId}) : super(key: key);
  final int landId;

  @override
  State<LandInfoPage> createState() => _LandInfoPageState();
}

class _LandInfoPageState extends State<LandInfoPage> {

  late Future<LandAdAndOwner> _landAdAndOwnerFuture;

  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _landAdAndOwnerFuture = _fetchLandAd();
  }

  Future<LandAdAndOwner> _fetchLandAd() async {
    LandAd landAd;
    UserRequest ownerInfo;
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/users/ads/land/${widget.landId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },);
    if (response.statusCode == 200) {
      // Parse the response JSON and return the data.
      final jsonData = json.decode(response.body);
      landAd = LandAd(
        id: jsonData['id'],
        name: jsonData['name'],
        price: jsonData['price'].toDouble(),
        localization: jsonData['localization'],
        batch: jsonData['batch'],
        area: jsonData['area'],
        priceType: jsonData['priceType'],
        description: jsonData['description'],
          isFavorite: jsonData['isFavorite'],
          ownerId: jsonData['ownerId'],
          images: jsonData['images'].cast<String>(),
          status: jsonData['status']
      );
    } else {
      // Handle API call errors, you can show an error message or throw an exception.
      throw Exception('Failed to load land ad');
    }

    final ownerResponse = await http.get(
      Uri.parse(
          'http://localhost:8080/api/users/${landAd.ownerId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },
    );
    if (ownerResponse.statusCode == 200) {
      // Parse the response JSON and return the data.
      final jsonData = json.decode(ownerResponse.body);
      ownerInfo = UserRequest(
          name: jsonData['name'],
          cellphone: jsonData['cellphone'],
          email: jsonData['email'],
          password: ""
      );
    } else {
      throw Exception('Failed to load animal ad');
    }

    return LandAdAndOwner(landAd, ownerInfo);

  }

  Future<void> deleteAdAsAdm() async {
    final response = await http.delete(
      Uri.parse(
          'http://localhost:8080/api/users/adm/landAd/${widget.landId}'),
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

  Future<void> validateAd() async {
    final response = await http.put(
      Uri.parse(
          'http://localhost:8080/api/users/adm/landAd/${widget.landId}'),
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
      Uri.parse('http://localhost:8080/api/users/landAd/${widget.landId}'),
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

  Future<void> toggleFavorite() async {

    final userId = UserManager.instance.loggedUser!.id; // Replace with the actual user ID
    final favoriteId = widget.landId;

    if (!isFavorite) {
      // Add the land ad to user's favorites
      final response = await http.post(Uri.parse('http://localhost:8080/api/users/$userId/favorites/landAd/$favoriteId'),
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
      final response = await http.delete(Uri.parse('http://localhost:8080/api/users/$userId/favorites/landAd/$favoriteId'),
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
    return FutureBuilder<LandAdAndOwner>(
        future: _landAdAndOwnerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the data, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If there was an error in the API call, show an error message.
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Data fetched successfully, use it to populate the AnimalDetails widget.
          final landAdAndOwner = snapshot.data!;
          final landAd = landAdAndOwner.landAd;
          final ownerData = landAdAndOwner.ownerData;
          isFavorite = landAd.isFavorite!;
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
                    CarouselProducts(landAd.images),
                    LandDetails(
                      productName: landAd.name,
                      batch: landAd.batch!,
                      localization: landAd.localization,
                      area: landAd.area.toString(),
                      price: landAd.price.toString(),
                      priceType: landAd.priceType!,
                    ),
                     Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                      landAd.description!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black)),
                    ),
                    if (UserManager.instance.loggedUser!.isAdm)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FlatMenuButton(
                                icon: const Icon(Icons.refresh),
                                buttonName: "Atualizar Anúncio",
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewLandAdForm(
                                          updatedData: landAd),
                                    ),
                                  );
                                }),
                          ),

                          if (landAd.status != "Aprovado")
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: FlatMenuButton(
                                  buttonName: "Validar anúncio",
                                  icon: const Icon(Icons.check),
                                  onPress: () {
                                    validateAd();
                                  }),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FlatMenuButton(
                                buttonName: "Excluir anúncio",
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPress: () {
                                  deleteAdAsAdm();
                                }),
                          ),

                        ],
                      )
                    else if (UserManager.instance.loggedUser!.id ==
                        landAd.ownerId)
                      Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FlatMenuButton(
                                icon: const Icon(Icons.refresh),
                                buttonName: "Atualizar Anúncio",
                              onPress: () async {
                                // Navigate to the AnimalInfoPage and wait for the result.
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewLandAdForm(updatedData: landAd),
                                  ),
                                );
                                // Check if the result is true, and reload the list.
                                if (result == true) {
                                  setState(() {
                                    _landAdAndOwnerFuture = _fetchLandAd();
                                  });
                                }
                              },
                                ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FlatMenuButton(
                                buttonName: "Excluir anúncio",
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPress: () {
                                  deleteAdAsOwner();
                                }),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FlatMenuButton(
                                icon: const Icon(Icons.email),
                                buttonName: "Enviar proposta",
                                onPress: () {
                                  print("Owner id: ${landAd.ownerId} \n"
                                      "self id: ${UserManager.instance.loggedUser!.id}");
                                }),
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
                    Text("${landAd.status}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 101, 32),
                            fontWeight: FontWeight.bold,
                            fontSize: 18))
                      ],
                    ),

                  ],
              ),
            ),
          );
        }
      }
    );
  }
}

class LandDetails extends StatelessWidget {
  const LandDetails({
    super.key,
    required this.productName,
    required this.batch,
    required this.localization,
    required this.area,
    required this.price,
    required this.priceType,
  });

  final String productName;
  final String batch;
  final String localization;
  final String area;
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
          Text("Área: $area ha",
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

class LandAdAndOwner {
  final LandAd landAd;
  final UserRequest ownerData;

  LandAdAndOwner(this.landAd, this.ownerData);
}