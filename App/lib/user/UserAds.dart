import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gado_app/animal/animalInfoPage.dart';

import 'package:http/http.dart' as http;

import '../animal/Animal.dart';
import '../animal/AnimalList.dart';
import '../firebase/storageService.dart';
import '../land/land.dart';
import '../land/landList.dart';
import '../machine/machine.dart';
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
  late List<String> animalImages;
  late List<String> landImages;
  late List<String> machineryImages;

  final Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    futureData = fetchAllAds();
  }


  Future<List<dynamic>> fetchAllAds() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/users/${UserManager.instance.loggedUser!.id}/ads'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      final animalAdsData = jsonData['animalAds'] as List<dynamic>;
      final landAdsData = jsonData['landAds'] as List<dynamic>;
      final machineryAdsData = jsonData['machineryAds'] as List<dynamic>;

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
        colorFilter: ColorFilter.mode(searchBarInUse ? Colors.black54 : const Color.fromARGB(0, 0, 101, 32), BlendMode.darken),
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
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              if (data is AnimalAd) {
                                return productAnimal(
                                  Future.value(animalImages[index]),
                                  data.name,
                                  data.batch,
                                  data.localization,
                                  data.quantity,
                                  data.id,
                                  priceType: data.priceType,
                                  price: data.price,
                                  weight: data.weight,
                                );
                              } else
                                if (data is LandAd) {
                                return productLand(
                                  Future.value(landImages[index]),
                                  data.name,
                                  data.batch,
                                  data.localization,
                                  data.area,
                                  data.id,
                                  priceType: data.priceType,
                                  price: data.price,
                                );
                              } else if (data is MachineryAd) {
                                return productMachine(
                                  Future.value(machineryImages[index]),
                                  data.name,
                                  data.batch,
                                  data.localization,
                                  data.quantity,
                                  data.id,
                                  priceType: data.priceType,
                                  price: data.price,
                                );
                              } else {
                                return const SizedBox(); // Return an empty container if the data type is not recognized
                              }
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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