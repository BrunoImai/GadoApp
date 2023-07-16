import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gado_app/land/LandInfoPage.dart';
import 'package:gado_app/land/land.dart';

import 'package:http/http.dart' as http;

import '../animal/animalInfoPage.dart';

class LandListPage extends StatefulWidget {
  const LandListPage({super.key});


  @override
  State<LandListPage> createState() => _LandListPageState();
}

class _LandListPageState extends State<LandListPage> {
  bool searchBarInUse = false;
  late Future<List<LandAd>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = getAllLandAds();
  }

  Future<List<LandAd>> getAllLandAds() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/users/ads/land'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      // Map the JSON data to a list of AnimalAdResponse objects
      final landAds = jsonData.map((item) {
        return LandAd(
          id: item['id'],
          name: item['name'],
          price: item['price'].toDouble(),
          localization: item['localization'],
          batch: item['batch'],
          area: item['area'],
          priceType: item['priceType'],
          description: item['description'],
        );
      }).toList();

      return landAds;
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load land ads');
      // Request failed
      throw Exception('Failed to load animal ads');
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
              "Anúncios de Terra",
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
                          text: 'Arrendamento',
                          onPressed: () {
                            // Handle button press
                            print('Button pressed!');
                          }),
                      PillButton(
                          text: 'Venda',
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
                    child: FutureBuilder<List<LandAd>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return productLand(
                                  "https://s2.glbimg.com/V4XsshzNU57Brn3e127b80Rbk24=/e.glbimg.com/og/ed/f/original/2016/05/30/gado.jpg",
                                  data.name,
                                  data.batch,
                                  data.localization,
                                  data.area,
                                  data.id,
                                  priceType: data.priceType,
                                  price: data.price,
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

Widget productLand(
    imageLink, productName, batch, localization, area, id,
    {price, priceType}) {
  return Builder(
      builder: (context) {
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
                          imageLink,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(productName,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 101, 32),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Lote: $batch",
                            style: const TextStyle(fontWeight: FontWeight.w300,
                                color: Colors.black)),
                        Text(localization,
                            style: const TextStyle(fontWeight: FontWeight.w300,
                                color: Colors.black))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Area: $area ha" ,
                          style: const TextStyle(fontWeight: FontWeight.w300,
                              color: Colors.black))]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        price != null ?
                        Text("R\$ $price $priceType",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 101, 32),
                                fontWeight: FontWeight.bold,
                                fontSize: 18))
                            :
                        const Text("Consultar valor",
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
                onPressed: () =>
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LandInfoPage(landId: id,)),
                  )
                }
            ),
          ),
        );
      }
  );
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
