import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/home/homePage.dart';

class AnimalInfoPage extends StatefulWidget {
  const AnimalInfoPage({Key? key}) : super(key: key);

  @override
  State<AnimalInfoPage> createState() => _AnimalInfoPageState();
}

class _AnimalInfoPageState extends State<AnimalInfoPage> {
  bool isFavorite = false;
  String productName = "Gado";
  String batch = "9839";
  String localization = "Curitiba/PR";
  int qtt = 12;
  String weight = "20";
  String price = "2300";
  String priceType = "Unidade";

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      "https://dicas.boisaude.com.br/wp-content/uploads/2020/12/rac%CC%A7as-de-gado-brasileiro.jpg",
      "https://s2.glbimg.com/V4XsshzNU57Brn3e127b80Rbk24=/e.glbimg.com/og/ed/f/original/2016/05/30/gado.jpg",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Cow_female_black_white.jpg/1280px-Cow_female_black_white.jpg",
    ];

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
              CarouselProducts(images),
              AnimalDetails(
                  productName: productName,
                  batch: batch,
                  localization: localization,
                  qtt: qtt,
                  weight: weight,
                  price: price,
                  priceType: priceType),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                    """Animais com boas referências, as mais produz em média 25 litros dia, regime de pasto. Fazenda produz 2000 litros dia .""",
                    style: TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FlatMenuButton(
                    icon: const Icon(Icons.email),
                    buttonName: "Enviar proposta",
                    onPress: () {}),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: FlatMenuButton(
                    icon: const Icon(FontAwesomeIcons.whatsapp),
                    buttonName: "Chamar WhatsApp",
                    onPress: () {}),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: FlatMenuButton(
                    icon: const Icon(Icons.paste_rounded),
                    buttonName: "Solicitar Financiamento",
                    onPress: () {}),
              ),
            ],
          ),
        ]),
      ),
    );
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
          if (weight != null)
            Text("Peso Aprox.: $weight KG",
                style: const TextStyle(
                    fontWeight: FontWeight.w300, color: Colors.black)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              price != null
                  ? Text("R\$ $price $priceType",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 101, 32),
                          fontWeight: FontWeight.bold,
                          fontSize: 18))
                  : const Text("Consultar valor",
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
    );
  }
}

class CarouselProducts extends StatefulWidget {
  final List<String> images;
  int pageIndex = 1;

  CarouselProducts(this.images, {super.key});

  @override
  State<CarouselProducts> createState() => _CarouselProductsState();
}

class _CarouselProductsState extends State<CarouselProducts> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        items: super.widget.images.map<Widget>((image) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: 300.0,
          viewportFraction: 1,
          onPageChanged: (index, reason) => {
            setState(() {
              super.widget.pageIndex = index + 1;
            })
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(90, 0, 0, 0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                '${super.widget.pageIndex}/${super.widget.images.length}',
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
    ]);
  }
}
