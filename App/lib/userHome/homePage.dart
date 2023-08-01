import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/favorite/favoriteView.dart';
import 'package:gado_app/land/landFormView.dart';
import 'package:gado_app/land/landList.dart';
import 'package:gado_app/machine/machineList.dart';
import 'package:gado_app/machine/machineryFormView.dart';
import 'package:gado_app/publicity/publicityInfo.dart';
import 'package:gado_app/user/UserManager.dart';
import 'package:gado_app/user/registerView.dart';

import 'package:url_launcher/link.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../animal/animalFormView.dart';
import '../animal/AnimalList.dart';
import '../user/UserAds.dart';
// import 'package:gado_app/home/widgets/widgetsHome';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}
class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomePageScreen(),
    const UserFavListPage(),
    const UserAdsListPage(),
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
        SearchBarWidget(),
        Expanded(
          child: ListView(
            children: [
              categoriesSection,
              regulationBox,
              socialMediaBox("facebookLink", "instagramLink", "youtubeLink"),
               const PublicityCard(
                imageLink:
                "https://imagens.mfrural.com.br/mfrural-produtos-us/245984-250772-2050402-sementes-de-capim-mpg-produtos-agropecuarios.jpg",
                publicityDescription: 'Sementes boas a um preco barato',
                publicityTitle: 'Sementes',
                destination: PublicityInfoPage( machineId: 1,),
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
            destination: AnimalListPage(),
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
              destination: MachineryListPage()),
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
    required this.categoryText,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 101, 32),
        borderRadius: BorderRadius.circular(10),
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
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

class HomePageLogo extends StatelessWidget {
  const HomePageLogo({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 80,
          child: Image.network(
            "https://upload.wikimedia.org/wikipedia/commons/f/fd/Crowd_Cow_logo.png?20210119092057",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

Widget regulationBox = Column(children: [
  const Padding(
    padding: EdgeInsets.only(bottom: 16),
    child: Text(
      "REGULAMENTO",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  ),
  FlatMenuButton(
    icon: const Icon(Icons.file_copy_rounded),
    buttonName: "Regulamento",
    onPress: () {},
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

Widget LogoBox = SizedBox(
  height: 100,
  child: Image.network(
    "https://upload.wikimedia.org/wikipedia/commons/f/fd/Crowd_Cow_logo.png?20210119092057",
  ),
);

class SearchBarWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
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
      ),
    );

  }
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key}) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16.0),
        Visibility(
          visible: _isExpanded,
          child: _buildOption(
            icon: Icons.pets,
            label: 'Animais',
            onPressed: () {
              _toggleExpanded();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnimalFormView()),
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
        Visibility(
          visible: _isExpanded,
          child: _buildOption(
            icon: Icons.factory,
            label: 'Maquinário',
            onPressed: () {
              _toggleExpanded();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MachineryFormView()),
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
        Visibility(
          visible: _isExpanded,
          child: _buildOption(
            icon: Icons.landscape,
            label: 'Terra',
            onPressed: () {
              _toggleExpanded();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LandFormView()),
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 80,
          width: 80,
          child: FloatingActionButton(
            onPressed: _toggleExpanded,
            tooltip: 'Expand',
            backgroundColor: const Color.fromARGB(255, 0, 101, 32),
            elevation: 10,
            child: Stack(
              children: [

                if (!_isExpanded)
                  const Text(
                  "Criar Anúncio",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ) else AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animationController,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      )),
      child: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 0, 101, 32),
        onPressed: onPressed,
        elevation: 10,
        label: Text(label),
        icon: Icon(icon),
      ),
    );
  }
}


class PublicityCard extends StatelessWidget {
  const PublicityCard({super.key, required this.imageLink, required this.publicityDescription,required this.publicityTitle, required this.destination});
  final String imageLink;
  final String publicityTitle;
  final String publicityDescription;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 400,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 101, 32),
        borderRadius: BorderRadius.circular(10),
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
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
              ),
              FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.2,
                child: Container(
                  color: const Color.fromARGB(255, 0, 101, 32),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            publicityTitle,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Text(
                          publicityDescription,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
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
