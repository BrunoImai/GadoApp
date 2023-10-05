import 'package:flutter/material.dart';

import '../publicity/AdvertisingInfo.dart';
import '../user/InitialView.dart';
import '../userHome/homePage.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomePageScreen(),

  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onItemTapped,
        children: _screens,
      ),
      floatingActionButton: const ExpandableFab(),
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
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Meus Anúncios",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}


class HomePageScreen extends StatelessWidget {
  const HomePageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const HomePageLogo(),
        FlatMenuButton(
          icon: const Icon(Icons.exit_to_app),
          buttonName: "Sair",
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InitialView()),
            );
          },
        ),
        Expanded(
          child: ListView(
            children: [
              categoriesSection,
              regulationBox,
              socialMediaBox("facebookLink", "instagramLink", "youtubeLink"),
              const AdvertisingCard(
                imageLink:
                "https://imagens.mfrural.com.br/mfrural-produtos-us/245984-250772-2050402-sementes-de-capim-mpg-produtos-agropecuarios.jpg",
                description: 'Sementes boas a um preco barato',
                title: 'Sementes',
                destination: AdvertisingInfoPage( advertisingId: 1,),
              )
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
  }
}