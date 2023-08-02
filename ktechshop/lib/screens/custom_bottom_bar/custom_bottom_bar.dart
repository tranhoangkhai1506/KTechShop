import 'package:flutter/material.dart';
import 'package:ktechshop/screens/cart_screen/cart_screen.dart';
import 'package:ktechshop/screens/favourite_screen/favourite_screen.dart';
import 'package:ktechshop/screens/home/home.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({final Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late PersistentTabController _controller;
  late bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() => [
        Home(),
        CartScreen(),
        FavouriteScreen(),
        FavouriteScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.home),
            inactiveIcon: Icon(Icons.home_outlined),
            title: "Home",
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            activeColorPrimary: Colors.purple,
            inactiveColorPrimary: Colors.grey,
            inactiveColorSecondary: Colors.purple),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          inactiveIcon: Icon(Icons.shopping_cart_outlined),
          title: "Cart",
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite),
          inactiveIcon: Icon(Icons.favorite_border),
          title: "Fovourite",
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          activeColorPrimary: Colors.pinkAccent,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          inactiveIcon: const Icon(Icons.person_2_outlined),
          title: "Profile",
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          activeColorPrimary: Colors.deepOrange,
          inactiveColorPrimary: Colors.grey,
        ),
      ];

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          resizeToAvoidBottomInset: true,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          bottomScreenMargin: 0,

          backgroundColor: Colors.white70,
          hideNavigationBar: _hideNavBar,
          decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
          ),
          navBarStyle:
              NavBarStyle.style1, // Choose the nav bar style with this property
        ),
      );
}
