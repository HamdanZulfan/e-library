import 'package:e_library/screen/explore/explore_screen.dart';
import 'package:e_library/screen/favorite/favorite_screen.dart';
import 'package:e_library/screen/profile/profile_screen.dart';
import 'package:e_library/screen/search/search_screen.dart';
import 'package:e_library/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/navbar_provider.dart';

class NavBarScreen extends StatefulWidget {
  final int pageIndex;
  const NavBarScreen({super.key, this.pageIndex = 0});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  List<dynamic> screens = [
    const ExploreScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    context.read<NavBarProvider>().screenIndex = widget.pageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarProvider>(builder: (context, provider, _) {
      return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            backgroundColor: navyColor,
            unselectedItemColor: greyColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: yellowColor,
            elevation: 1.5,
            currentIndex: provider.screenIndex,
            showUnselectedLabels: true,
            onTap: (value) => provider.updateScreenIndex(value),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                label: 'Explore',
                icon: Icon(
                  Icons.home,
                  size: 27,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Search',
                icon: Icon(
                  Icons.search,
                  size: 27,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Favorite',
                icon: Icon(
                  Icons.favorite,
                  size: 27,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(
                  Icons.person,
                  size: 27,
                ),
              ),
            ],
          ),
        ),
        body: screens[provider.screenIndex],
      );
    });
  }
}
