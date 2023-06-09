import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/home/homePage.dart';

class LandInfoPage extends StatefulWidget {
  const LandInfoPage({Key? key}) : super(key: key);

  @override
  State<LandInfoPage> createState() => _LandInfoPageState();
}

class _LandInfoPageState extends State<LandInfoPage> {
  bool isFavorite = false;
  String productName = "Fazenda em Pinhais";
  String batch = "9839";
  String localization = "Curitiba/PR";
  String area = "1.200";
  String price = "2300";
  String priceType = "ha";

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      "https://media-cdn.tripadvisor.com/media/photo-s/07/48/b4/c7/pousada-agua-azul.jpg",
      "https://images.freeimages.com/images/large-previews/d93/the-open-field-1361608.jpg",
      "https://www.10wallpaper.com/wallpaper/1366x768/1107/Open_field_in_San_Luis_Valley_1366x768.jpg",
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
              LandDetails(
                  productName: productName,
                  batch: batch,
                  localization: localization,
                  area: "1.200",
                  price: price,
                  priceType: priceType),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                    """  Bem-vindo à Fazenda Vista Verde, um verdadeiro paraíso rural localizado em Pinhais, com uma vasta extensão de 1200 hectares. Situada em uma região privilegiada, esta fazenda oferece uma combinação perfeita de uma localização tranquila e de fácil acesso às comodidades da cidade.""",
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

class LandDetails extends StatelessWidget {
  const LandDetails({
    super.key,
    required this.productName,
    required this.batch,
    required this.localization,
    required this.area,
    required this.price,
    required this.priceType,
  });

  final String productName;
  final String batch;
  final String localization;
  final String area;
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
          Text("Área: $area ha",
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
