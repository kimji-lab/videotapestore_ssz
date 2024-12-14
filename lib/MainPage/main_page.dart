import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sign_page/Profile/profile_page.dart';
import 'package:flutter_sign_page/Store/store_page.dart';
import 'package:flutter_sign_page/Wishlist/wishlist_page.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _wishlist = [];
  final List<Widget> _pages = [];
  String userRole = '';
  final storage = const FlutterSecureStorage();

  void _addToWishlist(Map<String, dynamic> item) {
    setState(() {
      if (!_wishlist
          .any((element) => element['videoTapeId'] == item['videoTapeId'])) {
        _wishlist.add(item); // Tambahkan item jika belum ada di wishlist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['name']} added to wishlist!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['name']} is already in wishlist!')),
        );
      }
    });
  }

 @override
  void initState() {
    super.initState();
    _initializePages();
  }

  Future<void> _initializePages() async {
    // Membaca role dari FlutterSecureStorage
    String? role = await storage.read(key: 'role');
    setState(() {
      userRole = role ?? '';
      _pages.addAll([
        StorePage(
          addToWishlist: _addToWishlist,
          wishlist: _wishlist,
          userRole: userRole,
        ), // halaman store
        WishlistPage(wishlist: _wishlist), // halaman wishlist
        ProfilePage(), // halaman profile
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
