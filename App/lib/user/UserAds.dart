import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gado_app/animal/AnimalInfoPage.dart';
import 'package:gado_app/land/LandInfoPage.dart';
import 'package:gado_app/userHome/homePage.dart';
import 'package:http/http.dart' as http;

import '../animal/Animal.dart';
import '../animal/AnimalList.dart';
import '../animal/animalFormView.dart';
import '../firebase/storageService.dart';
import '../land/land.dart';
import '../land/landList.dart';
import '../machine/machine.dart';
import '../machine/machineInfoPage.dart';
import '../machine/machineList.dart';
import 'UserManager.dart';

class UserAdsListPage extends StatefulWidget {
  const UserAdsListPage({super.key});

  @override
  State<UserAdsListPage> createState() => _UserAdsListPageState();
}

class _UserAdsListPageState extends State<UserAdsListPage> {
  bool searchBarInUse = false;
  late Future<List<dynamic>> futureData;

  final Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    futureData = fetchAllAds();
  }

  Future<List<dynamic>> fetchAllAds() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/users/${UserManager.instance.loggedUser!.id}/ads'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      final animalAdsData = jsonData['animalAds'] as List<dynamic>;
      final landAdsData = jsonData['landAds'] as List<dynamic>;
      final machineryAdsData = jsonData['machineryAds'] as List<dynamic>;

      List<AnimalAd> animalAds = [];

      for (var item in animalAdsData) {
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
              ownerId: item['ownerId'],
              images: images,
              imageUrl: imageUrl
          );
        animalAds.add(animalAd);
      }

      List<LandAd> landAds = [];
      for (var item in landAdsData) {
        final images = item['images'].cast<String>();
        String imageUrl;
        if (images.isNotEmpty) {
          imageUrl = await storage.getImageUrl(images[0]);
        } else {
          imageUrl = await storage.getImageUrl("imgNotFound.jpeg");
        }
        final landAd = LandAd(
              id: item['id'],
              name: item['name'],
              price: item['price'].toDouble(),
              localization: item['localization'],
              batch: item['batch'],
              area: item['area'],
              priceType: item['priceType'],
              description: item['description'],
            ownerId: item['ownerId'],
              images: images,
              imageUrl: imageUrl
          );
        landAds.add(landAd);
      }

      List<MachineryAd> machineryAds = [];
      for (var item in machineryAdsData) {
        final images = item['images'].cast<String>();
        String imageUrl;
        if (images.isNotEmpty) {
          imageUrl = await storage.getImageUrl(images[0]);
        } else {
          imageUrl = await storage.getImageUrl("imgNotFound.jpeg");
        }
        final machineryAd = MachineryAd(
              id: item['id'],
              name: item['name'],
              price: item['price'].toDouble(),
              localization: item['localization'],
              quantity: item['quantity'],
              priceType: item['priceType'],
              description: item['description'],
              ownerId: item['ownerId'],
              batch: item['batch'],
              images: images,
              imageUrl: imageUrl
          );
        machineryAds.add(machineryAd);
      }

      return [...animalAds, ...landAds, ...machineryAds];
    } else {
      throw Exception('Failed to load ads');
    }
  }

  Future<List<String>> fetchImages(List<dynamic> adsData) async {
    final imageUrlList = <String>[];

    for (var item in adsData) {
      final images = item['images'].cast<String>();
      if (images.isNotEmpty) {
        imageUrlList.add(await storage.getImageUrl(images[0]));
      } else {
        imageUrlList.add('');
      }
    }

    return imageUrlList;
  }

  @override
  Widget build(BuildContext bdcontext) {
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
               "Meus Anúncios",
              style: TextStyle(color: Colors.white),
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
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<List<dynamic>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            itemCount: snapshot.data!.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final data = snapshot.data;
                              if (data == null || data.isEmpty) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.report_gmailerrorred,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Você não possuí nenhum anúncio cadastrado',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }else {
                                if (index < snapshot.data!.length) {
                                  final data = snapshot.data![index];
                                  if (data is AnimalAd) {
                                    var product = ProductAnimal(
                                      imageLink: data.imageUrl!,
                                      productName: data.name,
                                      batch: data.batch!,
                                      localization: data.localization,
                                      id: data.id!,
                                      priceType: data.priceType,
                                      price: data.price,
                                      weight: data.weight,
                                      qtt: data.quantity!,
                                      ownerId: data.ownerId!,
                                      onPressed: () async {
                                        // Navigate to the MachineInfoPage and wait for the result.
                                        Navigator.push(
                                          bdcontext,
                                          MaterialPageRoute(
                                              builder: (bdcontext) => AnimalInfoPage(animalId: data.id!)),
                                        );
                                      },
                                    );

                                    return product;
                                  } else if (data is LandAd) {
                                    var product = ProductLand(
                                      imageLink: data.imageUrl!,
                                      productName: data.name,
                                      batch: data.batch!,
                                      localization: data.localization,
                                      area: data.area!,
                                      id: data.id!,
                                      priceType: data.priceType,
                                      price: data.price,
                                      ownerId: data.ownerId!,
                                      onPressed: () async {
                                        // Navigate to the MachineInfoPage and wait for the result.
                                        final result = await Navigator.push(
                                          bdcontext,
                                          MaterialPageRoute(
                                            builder: (bdcontext) =>
                                                LandInfoPage(landId: data.id!),
                                          ),
                                        );
                                        // Check if the result is true, and reload the list.
                                        if (result == true) {
                                          setState(() {
                                            futureData = fetchAllAds();
                                          });
                                        }
                                      },
                                    );
                                    return product;
                                  } else if (data is MachineryAd) {
                                    var product = ProductMachine(
                                      imageLink: data.imageUrl!,
                                      productName: data.name,
                                      batch: data.batch!,
                                      localization: data.localization,
                                      qtt: data.quantity!,
                                      id: data.id!,
                                      priceType: data.priceType,
                                      price: data.price,
                                      ownerId: data.ownerId!,
                                      onPressed: () async {
                                        // Navigate to the MachineInfoPage and wait for the result.
                                        final result = await Navigator.push(
                                          bdcontext,
                                          MaterialPageRoute(
                                            builder: (bdcontext) =>
                                                MachineInfoPage(
                                                    machineId: data.id!),
                                          ),
                                        );
                                        // Check if the result is true, and reload the list.
                                        if (result == true) {
                                          setState(() {
                                            futureData = fetchAllAds();
                                          });
                                        }
                                      },
                                    );
                                    return product;
                                  } else {
                                    return const SizedBox(); // Return an empty container if the data type is not recognized
                                  }
                                } else {
                                  return const SizedBox(); // Return an empty container if the index is out of range.
                                }
                              }
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                    ,
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
