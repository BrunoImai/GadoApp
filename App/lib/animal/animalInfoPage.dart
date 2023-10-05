import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/animal/Animal.dart';
import 'package:gado_app/user/user.dart';
import '../userHome/homePage.dart';

import 'package:http/http.dart' as http;

import '../firebase/storageService.dart';
import '../user/UserManager.dart';
import 'animalFormView.dart';

class AnimalInfoPage extends StatefulWidget {
  const AnimalInfoPage({Key? key, required this.animalId,}) : super(key: key);
  final int animalId;


  @override
  State<AnimalInfoPage> createState() => _AnimalInfoPageState();
}

class _AnimalInfoPageState extends State<AnimalInfoPage> {
  late Future<AnimalAdAndOwner> _animalAdAndOwnerFuture;

  @override
  void initState() {
    super.initState();
    _animalAdAndOwnerFuture = _fetchAnimalAd();
  }

  Future<AnimalAdAndOwner> _fetchAnimalAd() async {
    AnimalAd animalAd;
    UserRequest ownerInfo;
    final animalAdresponse = await http.get(
      Uri.parse(
          'http://localhost:8080/api/users/ads/animal/${widget.animalId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },
    );
    if (animalAdresponse.statusCode == 200) {
      // Parse the response JSON and return the data.
      final jsonData = json.decode(animalAdresponse.body);
       animalAd = AnimalAd(
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
          images: jsonData['images'].cast<String>(),
          ownerId: jsonData['ownerId'],
          status: jsonData['status']);
    } else {
      throw Exception('Failed to load animal ad');
    }

    final ownerResponse = await http.get(
      Uri.parse(
          'http://localhost:8080/api/users/${animalAd.ownerId}'),
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

    return AnimalAdAndOwner(animalAd, ownerInfo);
  }

  late bool isFavorite = false;

  Future<void> validateAd() async {
    final response = await http.put(
      Uri.parse(
          'http://localhost:8080/api/users/adm/animalAd/${widget.animalId}'),
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



  Future<void> deleteAdAsAdm() async {
    final response = await http.delete(
      Uri.parse(
          'http://localhost:8080/api/users/adm/animalAd/${widget.animalId}'),
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
      Uri.parse('http://localhost:8080/api/users/animalAd/${widget.animalId}'),
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
    final userId = UserManager.instance.loggedUser!.id;
    final favoriteId = widget.animalId;

    if (!isFavorite) {
      // Add the land ad to user's favorites
      final response = await http.post(
        Uri.parse(
            'http://localhost:8080/api/users/$userId/favorites/animalAd/$favoriteId'),
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
      final response = await http.delete(
        Uri.parse(
            'http://localhost:8080/api/users/$userId/favorites/animalAd/$favoriteId'),
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
    }
  }

  @override
  Widget build(BuildContext bdcontext) {
    return FutureBuilder<AnimalAdAndOwner>(
        future: _animalAdAndOwnerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error in the API call, show an error message.
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data fetched successfully, use it to populate the AnimalDetails widget.
            final animalAdAndOwner = snapshot.data!;
            final animalAd = animalAdAndOwner.animalAd;
            final ownerData = animalAdAndOwner.ownerData;
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
                        child: Text(animalAd.description!,
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
                                  onPress: (){
                                    Navigator.push(
                                      bdcontext,
                                      MaterialPageRoute(
                                          builder: (context) => NewAnimalAdForm(updatedData: animalAd,)),
                                    );
                                  }),
                            ),
                            if (animalAd.status != "Aprovado")
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
                                  color: Colors.red,
                                  icon: const Icon(Icons.delete),
                                  onPress: () {
                                    deleteAdAsAdm();
                                  }),
                            ),
                          ],
                        )
                      else if (UserManager.instance.loggedUser!.id ==
                          animalAd.ownerId)
                        Column(
                          children: [
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
                                          NewAnimalAdForm(updatedData: animalAd),
                                    ),
                                  );
                                  // Check if the result is true, and reload the list.
                                  if (result == true) {
                                    setState(() {
                                      _animalAdAndOwnerFuture = _fetchAnimalAd();
                                    });
                                  }
                                },
                                  ),
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
                                    print("Owner id: ${animalAd.ownerId} \n"
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
                      Text("${animalAd.status}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 101, 32),
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),

                      const SizedBox(height: 10),


                      Text(
                        "Owner Information:\nName: ${ownerData.name}\nCellphone: ${ownerData.cellphone}\nEmail: ${ownerData.email}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 101, 32),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
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
          Text("Peso Aprox.: $weight KG",
              style: const TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.black)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("R\$ $price $priceType",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 101, 32),
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

class OwnerDetails extends StatelessWidget {

  const OwnerDetails({
    super.key,
    required this.name,
    required this.cellphone,
    required this.email
  });

  final String name;
  final String cellphone;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Dados do dono do anúncio",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 101, 32),
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nome: $name",
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
              Text(email,
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black))
            ],
          ),
          Text("Telefone: $cellphone",
              style: const TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.black)),
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


class AnimalAdAndOwner {
  final AnimalAd animalAd;
  final UserRequest ownerData;

  AnimalAdAndOwner(this.animalAd, this.ownerData);
}