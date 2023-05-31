import 'package:flutter/material.dart';
import 'package:gado_app/productsInfoPages/LandInfoPage.dart';

import '../productsInfoPages/animalInfoPage.dart';

class LandListPage extends StatefulWidget {
  const LandListPage({super.key});


  @override
  State<LandListPage> createState() => _LandListPageState();
}

class _LandListPageState extends State<LandListPage> {
  bool searchBarInUse = false;

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
              "Anúncios de Gado",
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
                    child: ListView(children: [
                      productLand(
                          "https://media-cdn.tripadvisor.com/media/photo-s/07/48/b4/c7/pousada-agua-azul.jpg",
                          "Terra a Venda",
                          "0000",
                          "Curitiba/PR",
                          "120,00",
                          ),

                      productLand(
                          "https://images.freeimages.com/images/large-previews/d93/the-open-field-1361608.jpg",
                          "Fazenda em Pinhais",
                          "0000",
                          "Curitiba/PR",
                          "2",
                          price: "20.000,00",
                          priceType: "ha",
                          ),

                      productLand(
                          "https://www.10wallpaper.com/wallpaper/1366x768/1107/Open_field_in_San_Luis_Valley_1366x768.jpg",
                          "Terra em Campo Comprido",
                          "0000",
                          "Curitiba/PR",
                          "2",
                          )
                    ]),
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
    imageLink, productName, batch, localization, area,
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
                    MaterialPageRoute(builder: (context) => const LandInfoPage()),
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
