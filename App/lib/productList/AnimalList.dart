import 'package:flutter/material.dart';
import 'package:gado_app/productsInfoPages/animalInfoPage.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});


  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
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
                          text: 'Bovino',
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
                      productAnimal(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Cow_female_black_white.jpg/1280px-Cow_female_black_white.jpg",
                          "gado",
                          "0000",
                          "ctba",
                          "2",
                          price: "5000,00",
                          priceType: "Unid"),

                      productAnimal(
                          "https://s2.glbimg.com/V4XsshzNU57Brn3e127b80Rbk24=/e.glbimg.com/og/ed/f/original/2016/05/30/gado.jpg",
                          "gado",
                          "0000",
                          "ctba",
                          "2",
                          price: "200,00",
                          priceType: "KG",
                          weight: "200"),

                      productAnimal(
                          "https://dicas.boisaude.com.br/wp-content/uploads/2020/12/rac%CC%A7as-de-gado-brasileiro.jpg",
                          "gado",
                          "0000",
                          "Curitiba/PR",
                          "2",
                          weight: "200")
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

Widget productAnimal(
    imageLink, productName, batch, localization, qtt,
    {price, priceType, weight}) {
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
                  children: [Text("Qtde: $qtt" ,
                      style: const TextStyle(fontWeight: FontWeight.w300,
                          color: Colors.black)),
                    if (weight != null) Text("Peso Aprox.: $weight KG",
                        style: const TextStyle(fontWeight: FontWeight.w300,
                        color: Colors.black))],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                  MaterialPageRoute(builder: (context) => const AnimalInfoPage()),
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
