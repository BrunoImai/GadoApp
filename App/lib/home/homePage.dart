import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/link.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../productList/productListPage.dart';
// import 'package:gado_app/home/widgets/widgetsHome';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    homePageScreen,
    const ProductListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 0, 101, 32),
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(100, 215, 208, 208),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Comprar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront),
              label: "Vender",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoritos",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

Widget homePageScreen = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ListView(
                children: [
                  homePageLogo,
                  SearchBarWidget(),
                  categoriesSection,
                  regulationBox,
                  socialMediaBox(
                      "facebookLink", "instagramLink", "youtubeLink"),
                ]
                    .map((widget) => Padding(
                          padding: const EdgeInsets.all(24),
                          child: widget,
                        ))
                    .toList(),
              ),
            ),
          ],
        );
// Rest of the code...

Widget categoriesSection = Column(
  children: [
    const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        "CATEGORIAS",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: categorieBox(
                "https://s2.glbimg.com/V4XsshzNU57Brn3e127b80Rbk24=/e.glbimg.com/og/ed/f/original/2016/05/30/gado.jpg",
                "GADO")),
        Flexible(
            child: categorieBox(
                "https://humanidades.com/wp-content/uploads/2016/04/campo-1-e1558303226877.jpg",
                "TERRA")),
        Flexible(
            child: categorieBox(
                "https://rothobras.com.br/wp-content/uploads/2020/03/m%C3%A1quina-do-campo-1-1000x650.jpg",
                "MÁQUINA")),
      ],
    ),
  ],
);

Widget categorieBox(imageLink, categoryText) {
  return Builder(
    builder: (context) {
      return Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 101, 32),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: const Color.fromARGB(255, 0, 101, 32), width: 3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              TextButton(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                          imageLink,
                          fit: BoxFit.cover,
                        ),
                ),
                            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductListPage()),
                  )
                },
              ),
              FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.2,
                child: Container(
                  color: const Color.fromARGB(255, 0, 101, 32),
                  child: Center(
                    child: Text(
                      categoryText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
}

Widget homePageLogo = SizedBox(
  height: 200,
  child: ClipRect(
      child: Image.network(
        "https://i.pinimg.com/736x/a9/44/6a/a9446ab738df002bd4bb77eccfec11c9.jpg",
    ),
  ),
);


Widget regulationBox = Column(children: [
  const Padding(
    padding: EdgeInsets.only(bottom: 16),
    child: Text(
      "REGULAMENTO",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  ),
  regulationButton,
]);

Widget regulationButton = SizedBox(
  width: double.infinity,
  height: 40,
  child: ElevatedButton.icon(
    onPressed: () {
      // Add your button click logic here
    },
    icon: const Icon(Icons.file_copy_rounded),
    label: const Text(
      'Abrir',
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 0, 101, 32),
      // padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);

Widget socialMediaBox(facebookLink, instagramLink, youtubeLink) {
  return Column(
    children: [
      const Text(
        "REDES SOCIAIS",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          iconButtonSocialMedia(
              "https://www.youtube.com/channel/UCxuPRi2hPqJdfnIEJH4lb_Q",
              const Icon(FontAwesomeIcons.youtube),
              Colors.red),
          iconButtonSocialMedia(
              "https://www.instagram.com/brunoyli/",
              const Icon(FontAwesomeIcons.instagram),
              const Color.fromARGB(255, 225, 48, 108)),
          iconButtonSocialMedia(
              "https://www.instagram.com/brunoyli/",
              const Icon(FontAwesomeIcons.facebook),
              const Color.fromARGB(255, 66, 103, 178)),
        ],
      )
    ],
  );
}

Widget iconButtonSocialMedia(externalLink, icon, color) {
  return Builder(builder: (context) {
    return Link(
      uri: Uri.parse(externalLink),
      builder: (context, followLink) => IconButton(
        iconSize: 32,
        icon: icon,
        color: color,
        onPressed: followLink,
      ),
    );
  });
}

class SearchBarWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (kDebugMode) {
              print('Search button pressed');
            }
          },
        ),
      ),
    );
  }
}