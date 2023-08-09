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

class UserFavListPage extends StatefulWidget {
  const UserFavListPage({super.key});

  @override
  State<UserFavListPage> createState() => _UserFavListPageState();
}

class _UserFavListPageState extends State<UserFavListPage> {
  bool searchBarInUse = false;
  late List<String> animalImages;
  late List<String> landImages;
  late List<String> machineryImages;
  final Storage storage = Storage();
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchAllAds();
  }

  Future<List<dynamic>> fetchAllAds() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/users/${UserManager.instance.loggedUser!.id}/favorites'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      final animalAdsData = jsonData['animalAdList'] as List<dynamic>;
      final landAdsData = jsonData['landAdList'] as List<dynamic>;
      final machineryAdsData = jsonData['machineryAdList'] as List<dynamic>;

      final animalAds = animalAdsData.map((item) {
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
          images: item['images'].cast<String>(),
        );
      }).toList();

      var animalImageUrlList = [];

      for (var element in animalAds) {
        animalImageUrlList.add(await storage.getImageUrl(element.images[0]));
      }

      animalImages = animalImageUrlList.cast<String>();

      final landAds = landAdsData.map((item) {
        return LandAd(
          id: item['id'],
          name: item['name'],
          price: item['price'].toDouble(),
          localization: item['localization'],
          batch: item['batch'],
          area: item['area'],
          priceType: item['priceType'],
          description: item['description'],
          images: item['images'].cast<String>(),
        );
      }).toList();

      var landImageUrlList = [];

      for (var element in landAds) {
        landImageUrlList.add(await storage.getImageUrl(element.images[0]));
      }

      landImages = landImageUrlList.cast<String>();

      final machineryAds = machineryAdsData.map((item) {
        return MachineryAd(
          id: item['id'],
          name: item['name'],
          price: item['price'].toDouble(),
          localization: item['localization'],
          quantity: item['quantity'],
          priceType: item['priceType'],
          description: item['description'],
          images: item['images'].cast<String>(),
        );
      }).toList();

      var machineryImageUrlList = [];

      for (var element in machineryAds) {
        machineryImageUrlList.add(await storage.getImageUrl(element.images[0]));
      }

      machineryImages = machineryImageUrlList.cast<String>();

      return [...animalAds, ...landAds, ...machineryAds];
    } else {
      throw Exception('Failed to load ads');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ColorFiltered(
        colorFilter: ColorFilter.mode(
          searchBarInUse ? Colors.black54 : const Color.fromARGB(0, 0, 101, 32),
          BlendMode.darken,
        ),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 0, 101, 32),
            title: const Text(
              "Seus Anúncios Favoritos",
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
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          final data = snapshot.data;
                          if (data == null || data.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Você não possuí nenhum anúncio favoritado',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];
                                if (item is AnimalAd) {
                                  return ProductAnimal(
                                    imageLink: Future.value(animalImages[index]),
                                    productName: item.name,
                                    batch: item.batch!,
                                    localization: item.localization,
                                    id: item.id!,
                                    priceType: item.priceType,
                                    price: item.price,
                                    weight: item.weight,
                                    qtt: item.quantity!,
                                  );
                                } else if (item is LandAd) {
                                  return ProductLand(
                                    imageLink: Future.value(landImages[index]),
                                    productName: item.name,
                                    batch: item.batch!,
                                    localization: item.localization,
                                    area: item.area!,
                                    id: item.id!,
                                    priceType: item.priceType,
                                    price: item.price,
                                  );
                                } else if (item is MachineryAd) {
                                  return ProductMachine(
                                    imageLink: Future.value(machineryImages[index]),
                                    productName: item.name,
                                    batch: item.batch!,
                                    localization: item.localization,
                                    qtt: item.quantity!,
                                    id: item.id!,
                                    priceType: item.priceType,
                                    price: item.price,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          }
                        }
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
