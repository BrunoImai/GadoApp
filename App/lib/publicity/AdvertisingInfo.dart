import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gado_app/publicity/Advertising.dart';
import 'package:gado_app/publicity/AdvertisingForm.dart';
import 'package:http/http.dart' as http;

import '../animal/animalInfoPage.dart';
import '../firebase/storageService.dart';
import '../user/UserManager.dart';
import '../userHome/homePage.dart';

class AdvertisingInfoPage extends StatefulWidget {
  const AdvertisingInfoPage({Key? key, required this.advertisingId}) : super(key: key);
  final int advertisingId;

  @override
  State<AdvertisingInfoPage> createState() => _AdvertisingInfoPageState();
}

class _AdvertisingInfoPageState extends State<AdvertisingInfoPage> {
  late Future<Advertising> _publicityFuture;

  final Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    _publicityFuture = _fetchPublicityAd();
  }


  Future<Advertising> _fetchPublicityAd() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/users/adm/advertising/${widget.advertisingId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse the response JSON and return the data.
      final jsonData = json.decode(response.body);
      print(jsonData);
      return Advertising(
          id: jsonData['id'],
          description: jsonData['description'],
          images: jsonData['images'].cast<String>(),
          name: jsonData['name']
      );
    } else {
      // Handle API call errors, you can show an error message or throw an exception.
      throw Exception('Failed to load machinery ad');
    }
  }

  Future<void> deleteAdAsAdm() async {
    final response = await http.delete(
      Uri.parse(
          'http://localhost:8080/api/users/adm/advertising/${widget.advertisingId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager.instance.loggedUser!.token}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        );

      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Advertising>(
        future: _publicityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error in the API call, show an error message.
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data fetched successfully, use it to populate the AnimalDetails widget.
            final advertisingData = snapshot.data!;

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
                      CarouselProducts(advertisingData.images),
                       PublicityDetails(
                        // productName: machineryAd.name,
                        productName: advertisingData.name!,
                      ),
                       Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(advertisingData.description!,
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
                                        builder: (context) => AdvertisingForm(
                                            updatedData: advertisingData),
                                      ),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: FlatMenuButton(
                                  buttonName: "Excluir Publicidade",
                                  color: Colors.red,
                                  icon: const Icon(Icons.delete),
                                  onPress: () {
                                    deleteAdAsAdm();
                                  }),
                            ),
                          ],
                        )
                    ],
                  ),
                ]),
              ),
            );
          }
        });
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
