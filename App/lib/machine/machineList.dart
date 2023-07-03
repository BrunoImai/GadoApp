import 'package:flutter/material.dart';
import 'package:gado_app/land/LandInfoPage.dart';
import 'package:gado_app/machine/machineInfoPage.dart';

import '../animal/animalInfoPage.dart';

class MachineryListPage extends StatefulWidget {
  const MachineryListPage({super.key});


  @override
  State<MachineryListPage> createState() => _MachineryListPageState();
}

class _MachineryListPageState extends State<MachineryListPage> {
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
                    child: ListView(children: [
                      productMachine(
                        "https://imagens.mfrural.com.br/mfrural-produtos-us/105054-413525-2173339-ensiladeira.jpg",
                        "Ensiladeira",
                        "0000",
                        "Curitiba/PR",
                        1,
                        price: "75.000,00",
                        priceType: "unid"
                      ),

                      productMachine(
                        "https://upload.wikimedia.org/wikipedia/commons/6/61/2018_Ford_Ranger_%28PX%29_XLT_4WD_4-door_utility_%282018-10-22%29_01.jpg",
                        "Ford Ranger",
                        "0000",
                        "Curitiba/PR",
                        2,
                        price: "139.075,00",
                        priceType: "unid",
                      ),

                      productMachine(
                        "https://motortudo.com/wp-content/uploads/2021/02/Mercedes-Benz-1519-1981-caminhoes-antigos-1a.jpg",
                        "Caminhão Mercedes-Benz",
                        "0000",
                        "Curitiba/PR",
                        2,
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

Widget productMachine(
    imageLink, productName, batch, localization, qtt,
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
                        children: [Text("Quantidade: $qtt" ,
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
                    MaterialPageRoute(builder: (context) => const MachineInfoPage()),
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
