import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/screens/account_screen/account_screen.dart';
import 'package:ktechshop/screens/auth_ui/welcome/welcome.dart';
import 'package:ktechshop/screens/cart_screen/cart_screen.dart';

import 'package:ktechshop/screens/home/home.dart';
import 'package:ktechshop/screens/order_screen/order_screen.dart';
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

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        bool isLoggedIn = snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData;
        return isLoggedIn
            ? _buildCustomBottomBar(context)
            : Welcome(); // Show Welcome screen when not logged in
      },
    );
  }

  Widget _buildCustomBottomBar(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

  List<Widget> _buildScreens() => [
        Home(),
        CartScreen(),
        OrderScreen(),
        AccountScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          inactiveIcon: Icon(Icons.home_outlined),
          title: "Home",
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          activeColorPrimary: Colors.purple,
          inactiveColorPrimary: Colors.grey,
          inactiveColorSecondary: Colors.purple,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          inactiveIcon: Icon(Icons.shopping_cart_outlined),
          title: "Cart",
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_bag_sharp),
          inactiveIcon: Icon(Icons.shopping_bag_outlined),
          title: "Orders",
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
}
