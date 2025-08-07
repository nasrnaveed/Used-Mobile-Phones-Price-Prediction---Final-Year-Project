import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:phone_lo/condition.dart';
import 'package:phone_lo/home.dart';
import 'package:phone_lo/price.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  void _navBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Condition(),
    UserHome(onNavigate: (index) => {}),
    const Price()
  ];
  @override
  Widget build(BuildContext context) {
    _pages[1] = UserHome(onNavigate: _navBottomBar);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Phone Lo',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: GNav(
              backgroundColor: Colors.deepPurple,
              color: Colors.white,
              gap: 8,
              padding: const EdgeInsets.all(12),
              activeColor: Colors.deepPurple,
              tabBackgroundColor: Colors.white,
              selectedIndex: _selectedIndex,
              onTabChange: _navBottomBar,
              tabs: const [
                GButton(
                  icon: Icons.camera_alt,
                  text: "Condition",
                  iconSize: 30,
                ),
                GButton(
                  icon: Icons.home,
                  text: "Home",
                  iconSize: 30,
                ),
                GButton(
                  icon: Icons.money,
                  text: "Price",
                  iconSize: 30,
                ),
              ]),
        ),
      ),
    );
  }
}
