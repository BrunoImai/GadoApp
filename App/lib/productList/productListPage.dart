import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 101, 32),
          title: const Text("Anúncios de Gado", style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            const Text("O que você procura?", style: TextStyle(color: Color.fromARGB(255, 0, 101, 32)),),
            SizedBox(
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
                    }
                  ),
                  PillButton(
                    text: 'Bovino',
                    onPressed: () {
                      // Handle button press
                      print('Button pressed!');
                    }
                  ),
                ].map((widget) => Padding(
                  padding: const EdgeInsets.all(3),
                  child: widget,
                ))
                    .toList(),
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView(
                    children: [
                      productCard(
                          "https://s2.glbimg.com/V4XsshzNU57Brn3e127b80Rbk24=/e.glbimg.com/og/ed/f/original/2016/05/30/gado.jpg",
                          "gado",
                          "0000",
                          "ctba",
                          "2"),
                      productCard(
                          "https://s2.glbimg.com/V4XsshzNU57Brn3e127b80Rbk24=/e.glbimg.com/og/ed/f/original/2016/05/30/gado.jpg",
                          "gado",
                          "0000",
                          "ctba",
                          "2",
                          weight: "200")
                    ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget productCard(imageLink, productName, batch, localization, qtt, {weight}) {
  return Center(
    child: Card(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Text(productName),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(batch), Text(localization)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(qtt), if (weight != null) Text(weight)],
          ),
        ],
      ),
    ),
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
        backgroundColor: const Color.fromARGB(255, 0, 101, 32), // Change the color as per your preference
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Adjust the radius as per your preference
        ),
      ),
      child: Text(
        text,
        
        style: const TextStyle(fontSize: 12.0), // Adjust the font size as per your preference
      ),
    );
  }
}