import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rown/templates/trend.dart';
import 'beranda.dart';
import 'templates/riwayat.dart';
import 'profil.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _widgetOptions = [
  const BerandaPage(),
   RiwayatPage(),
  const TrendPage(),  
  const ProfilPage(),
];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          'Rown Division',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 211, 33, 33),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: const Color.fromARGB(40, 0, 0, 0),
            height: 0.7,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.grey,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.redAccent,
            gap: 18,
            padding: const EdgeInsets.all(16),
            duration: const Duration(milliseconds: 200),
            tabs: const [
              GButton(icon: Icons.home, text: 'Beranda'),
              GButton(icon: Icons.history, text: 'Riwayat'),
              GButton(icon: Icons.local_fire_department, text: 'Trend'),
              GButton(icon: Icons.person, text: 'Profil'),
              
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
