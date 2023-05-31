import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/productList/landList.dart';
import 'package:gado_app/productList/machineList.dart';

import 'package:url_launcher/link.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../newProductFile/newProductView.dart';
import '../productList/AnimalList.dart';
// import 'package:gado_app/home/widgets/widgetsHome';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [homePageScreen, const NewProductView()];

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
          socialMediaBox("facebookLink", "instagramLink", "youtubeLink"),
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

Widget categoriesSection = const Column(
  children: [
    Padding(
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
          child: CategoryBox(
              imageLink:
                  "https://s2.glbimg.com/V4XsshzNU57Brn3e127b80Rbk24=/e.glbimg.com/og/ed/f/original/2016/05/30/gado.jpg",
              categoryText: "GADO",
          destination: ProductListPage(),
          ),
        ),
        Flexible(
          child: CategoryBox(
            imageLink:
                "https://humanidades.com/wp-content/uploads/2016/04/campo-1-e1558303226877.jpg",
            categoryText: "TERRA",
            destination: LandListPage(),
          ),
        ),
        Flexible(
          child: CategoryBox(
            imageLink:
                "https://blog.buscarrural.com/wp-content/uploads/elementor/thumbs/maquinas-agricolas-p1pbgi0lbgjhgun9dzsoe1x3of68qs2xhp67wstl68.jpg",
            categoryText: "MÁQUINA",
              destination: MachineryListPage()
          ),
        ),
      ],
    ),
  ],
);

class CategoryBox extends StatelessWidget {
  final String imageLink;
  final String categoryText;
  final Widget destination;

  const CategoryBox({
    super.key,
    required this.imageLink,
    required this.categoryText, required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 101, 32),
        borderRadius: BorderRadius.circular(10),
        // border:
        //     Border.all(color: const Color.fromARGB(255, 0, 101, 32), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.expand,
            children: [
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.8,
                  widthFactor: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageLink,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
      ),
    );
  }
}

Widget homePageLogo = SizedBox(
  height: 100,
  child: ClipRect(
    child: Image.network(
      "https://upload.wikimedia.org/wikipedia/commons/f/fd/Crowd_Cow_logo.png?20210119092057",
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
  FlatMenuButton(
      icon: Icon(Icons.file_copy_rounded),
      buttonName: "Regulamento",
      onPress: () {

      },
  ),
]);

class FlatMenuButton extends StatelessWidget {
  final Icon icon;
  final Function()? onPress;
  final String buttonName;
  const FlatMenuButton(
      {Key? key, this.onPress, required this.icon, required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: onPress,
        icon: icon,
        label: Text(
          buttonName,
          style: const TextStyle(color: Colors.white),
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
  }
}

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
        iconSize: 42,
        icon: icon,
        color: color,
        onPressed: followLink,
      ),
    );
  });
}

class SearchBarWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 0, 101, 32), width: 3.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            return states.contains(MaterialState.focused)
                ? const Color.fromARGB(255, 0, 101, 32)
                : Colors.grey;
          }),
          suffixIconColor: const Color.fromARGB(255, 0, 101, 32),
          border: InputBorder.none,
          hintText: 'Search...',
          prefixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (kDebugMode) {
                print('Search button pressed');
              }
            },
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              if (kDebugMode) {
                print('Filter button pressed');
              }
            },
          ),
        ),
      ),
    );
  }
}
