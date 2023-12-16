// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/homepage.dart';
import 'pages/likedpage.dart';
import 'pages/dislikedpage.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  // List of pages to display
  final List<Widget> _pages = [
    DislikedImagesPage(),
    HomePage(),
    LikedImagesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text('Navigation App'),
      //),
      body: SafeArea(
        child: Center(
          child: Stack(children: [
            Container(
              //height: MediaQuery.of(context).size.height / 4 * 3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 255, 220, 239),
                    Colors.white
                  ], // Gradient from pink to white
                ),
              ),
            ),
            _pages.elementAt(_selectedIndex),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(
            horizontal: 10), // Adds horizontal margin
        decoration: BoxDecoration(
          color: Colors.pink[200], // Sets the background color
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), // Top left corner
            topRight: Radius.circular(10), // Top right corner
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'images/disliked.svg', // Replace with your asset path
                  height: 50,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'images/home.svg', // Replace with your asset path
                  height: 50,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'images/liked.svg', // Replace with your asset path
                  height: 60,
                ),
                label: ''),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Page 1 Content'));
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Page 3 Content'));
  }
}
