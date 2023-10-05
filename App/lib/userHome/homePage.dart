import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gado_app/favorite/favoriteView.dart';
import 'package:gado_app/land/landFormView.dart';
import 'package:gado_app/land/landList.dart';
import 'package:gado_app/machine/machineList.dart';
import 'package:gado_app/machine/machineryFormView.dart';
import 'package:gado_app/publicity/Advertising.dart';
import 'package:gado_app/publicity/AdvertisingForm.dart';
import 'package:gado_app/publicity/AdvertisingInfo.dart';
import 'package:gado_app/user/InitialView.dart';
import 'package:gado_app/user/UserManager.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/link.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../admHome/admValidationView.dart';
import '../animal/animalFormView.dart';
import '../animal/AnimalList.dart';
import '../firebase/storageService.dart';
import '../user/UserAds.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);
  static const String routeName = '/user_home';
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  final Storage storage = Storage();
  late Future<List<Advertising>> futureData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futureData = getAllAdvertising();
  }


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    futureData = getAllAdvertising();
    futureData.toString();// Fetch advertising data
  }

  Future<List<Advertising>> getAllAdvertising() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/users/adm/advertising'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      List<Advertising> adList = [];
      for (var item in jsonData) {
        final images = item['images'].cast<String>();
        String imageUrl;
        if (images.isNotEmpty) {
          imageUrl = await storage.getImageUrl(images[0]);
        } else {
          imageUrl = await storage.getImageUrl("imgNotFound.jpeg");
        }
        final advertising = Advertising(
          id: item['id'],
          description: item['description'],
          name: item['name'],
          images: images,
          imageUrl: imageUrl,
        );
        adList.add(advertising);
      }

      return adList;
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load advertising data');
    }
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
            children: [
              FutureBuilder<List<Advertising>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomePageScreen(advertisingList: snapshot.data!);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              UserManager.instance.loggedUser!.isAdm
                  ? const AdmAdsListPage()
                  : const UserFavListPage(),
              const UserAdsListPage(),
            ]),
        floatingActionButton: const ExpandableFab(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 0, 101, 32),
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(100, 215, 208, 208),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Comprar",
            ),
            UserManager.instance.loggedUser!.isAdm
                ? const BottomNavigationBarItem(
                    icon: Icon(Icons.pending),
                    label: "Anúncios Pendentes",
                  )
                : const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: "Favoritos",
                  ),
            const BottomNavigationBarItem(
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
  final List<Advertising> advertisingList;

  const HomePageScreen({
    Key? key,
    required this.advertisingList,
  }) : super(key: key);

  List<Widget> _buildAdvertisingCards() {
    return advertisingList.map((advertising) {
      return AdvertisingCard(
        imageLink: advertising.imageUrl!,
        title: advertising.name!,
        description: advertising.description!,
        destination: AdvertisingInfoPage(advertisingId: advertising.id!),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // SearchBarWidget(),
        Expanded(
          child: ListView(
            children: [
              const HomePageLogo(),
              FlatMenuButton(
                icon: const Icon(Icons.exit_to_app),
                buttonName: "Sair",
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InitialView(),
                    ),
                  );
                },
              ),
              categoriesSection,
              regulationBox,
              socialMediaBox("facebookLink", "instagramLink", "youtubeLink"),
              ..._buildAdvertisingCards(), // Display advertising cards
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


class AdvertisingCard extends StatelessWidget {
  const AdvertisingCard(
      {super.key,
      required this.imageLink,
      required this.description,
      required this.title,
      required this.destination});
  final String imageLink;
  final String title;
  final String description;
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
                            title,
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
                          description,
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
            imagePath:
              "assets/images/AnimalIcon.png",
            categoryText: "ANIMAIS",
            destination: AnimalListPage(),
          ),
        ),
        Flexible(
          child: CategoryBox(
            imagePath:
              "assets/images/LandIcon.png",
            categoryText: "TERRAS",
            destination: LandListPage(),
          ),
        ),
        Flexible(
          child: CategoryBox(
              imagePath:
                "assets/images/MachineryIcon.png",
              categoryText: "MÁQUINARIO",
              destination: MachineryListPage()),
        ),
      ],
    ),
  ],
);

class CategoryBox extends StatelessWidget {
  final String imagePath;
  final String categoryText;
  final Widget destination;

  const CategoryBox({
    super.key,
    required this.imagePath,
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
                    heightFactor: 0.9,
                    widthFactor: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.fitWidth,
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
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.fitWidth,
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
  final Color? color;
  const FlatMenuButton(
      {Key? key,
      this.onPress,
      required this.icon,
      required this.buttonName,
      this.color})
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
          backgroundColor: color ?? const Color.fromARGB(255, 0, 101, 32),
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
  width: double.infinity,
  child: Image.asset(
    "assets/images/logo.png",
    fit: BoxFit.fitWidth,
  ),

);

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;

  SearchBarWidget({Key? key, required this.searchController}) : super(key: key);

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
          controller: searchController,
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
                MaterialPageRoute(
                    builder: (context) => const NewAnimalAdForm()),
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
                    builder: (context) => const NewMachineryAdForm()),
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
                MaterialPageRoute(builder: (context) => const NewLandAdForm()),
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
        Column(
          children: [
            if (UserManager.instance.loggedUser!.isAdm)
              Visibility(
                visible: _isExpanded,
                child: _buildOption(
                  icon: Icons.shop_2_rounded,
                  label: 'Publicidade',
                  onPressed: () {
                    _toggleExpanded();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdvertisingForm()),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16.0),
          ],
        ),
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
                  )
                else
                  AnimatedIcon(
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
        backgroundColor: const Color.fromARGB(255, 32, 100, 44),
        onPressed: onPressed,
        elevation: 10,
        label: Text(label),
        icon: Icon(icon),
      ),
    );
  }
}
