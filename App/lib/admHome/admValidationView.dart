
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../animal/Animal.dart';
import '../animal/AnimalList.dart';
import '../firebase/storageService.dart';
import '../land/land.dart';
import '../land/landList.dart';
import '../machine/machine.dart';
import '../machine/machineList.dart';
import '../user/UserManager.dart';

class AdmAdsListPage extends StatefulWidget {
  const AdmAdsListPage({super.key});

  @override
  State<AdmAdsListPage> createState() => _AdmAdsListPageState();
}

class _AdmAdsListPageState extends State<AdmAdsListPage> {
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
        'http://localhost:8080/api/users/adm/ads'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      });


    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Entrou");
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      final animalAdsData = jsonData['animalAdList'] as List<dynamic>;
      final landAdsData = jsonData['landAdList'] as List<dynamic>;
      final machineryAdsData = jsonData['machineryAdList'] as List<dynamic>;

      List<AnimalAd> animalAds = [];

      for (var item in animalAdsData) {
        final images = item['images'].cast<String>();
        print(images);
        String imageUrl;
        if (images.isNotEmpty) {
          imageUrl = await storage.getImageUrl(images[0]);
        } else {
          imageUrl = await storage.getImageUrl("imgNotFound.jpeg");
        }
        animalAds = animalAdsData.map((item) {
          return AnimalAd(
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
              imageUrl: imageUrl
          );
        }).toList();
      }
      print(animalAds);

      List<LandAd> landAds = [];
      for (var item in landAdsData) {
        final images = item['images'].cast<String>();
        String imageUrl;
        if (images.isNotEmpty) {
          imageUrl = await storage.getImageUrl(images[0]);
        } else {
          imageUrl = await storage.getImageUrl("imgNotFound.jpeg");
        }
        landAds = landAdsData.map((item) {
          return LandAd(
              id: item['id'],
              name: item['name'],
              price: item['price'].toDouble(),
              localization: item['localization'],
              batch: item['batch'],
              area: item['area'],
              priceType: item['priceType'],
              description: item['description'],
              images: images,
              imageUrl: imageUrl
          );
        }).toList();
      }
      print(landAds);

      List<MachineryAd> machineryAds = [];
      for (var item in machineryAdsData) {
        final images = item['images'].cast<String>();
        String imageUrl;
        if (images.isNotEmpty) {
          imageUrl = await storage.getImageUrl(images[0]);
        } else {
          imageUrl = await storage.getImageUrl("imgNotFound.jpeg");
        }
        machineryAds = machineryAdsData.map((item) {
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
      print(machineryAds);

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
              // Body code remains the same
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
                              if (index < snapshot.data!.length) {
                                final data = snapshot.data![index];
                                if (data is AnimalAd) {
                                  var product =  ProductAnimal(
                                    imageLink: data.imageUrl!,
                                    productName: data.name,
                                    batch: data.batch!,
                                    localization: data.localization,
                                    id: data.id!,
                                    priceType: data.priceType,
                                    price: data.price,
                                    weight: data.weight,
                                    qtt: data.quantity!,
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
                                  );
                                  return product;
                                } else {
                                  return const SizedBox(); // Return an empty container if the data type is not recognized
                                }
                              } else {
                                return const SizedBox(); // Return an empty container if the index is out of range.
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
