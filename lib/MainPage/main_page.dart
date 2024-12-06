import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'Home/home_page.dart';
import 'Profile/profile_page.dart';
import 'Store/store_page.dart';
import 'Wishlist/wishlist_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),  //pergi ke halaman home
    StorePage(),  //pergi ke halaman store
    WishlistPage(),  //pergi ke halaman wishtlist
    ProfilePage(),  //pergi ke halaman profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SSZ"),
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(

        //tampilan bottom navigation bar
        backgroundColor: Colors.white,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        height: 60,
        animationDuration: Duration(milliseconds: 300),

        //Icon bottom navigation bar
        index: _selectedIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.store, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],

        //perintah sentuh modifikasi curved_navigation_bar
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}