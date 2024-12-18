import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sign_page/Profile/profile_page.dart';
import 'package:flutter_sign_page/Store/store_page.dart';
import 'package:flutter_sign_page/Wishlist/wishlist_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _wishlist = [];
  List<Widget> _pages = [];
  String userRole = '';
  List<Map<String, dynamic>> _videotapes = [];

  @override
  void initState() {
    super.initState();
    _initializePages();
    _fetchVideotapes();
  }

  Future<void> _fetchVideotapes() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/videotapes'),
      );

      if(response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _videotapes = data
              .map((item) => {
                    'videoTapeId': item['videoTapeId'],
                    'title': item['title'],
                    'price': item['price'],
                    'description': item['description'],
                    'genreId': item['genreId'],
                    'tapeLevel': item['tapeLevel'],
                    'imagePath': 'http://localhost:3000/${item['imagePath']}',
                  })
              .toList();
        });
      }
    } catch (e) {
      print('Error mengambil videotape: $e');
    }
  }

  void _addToWishlist(Map<String, dynamic> item) {
    setState(() {
      if(!_wishlist
          .any((element) => element['videoTapeId'] == item['videoTapeId'])) {
        _wishlist.add(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['title']} ditambah ke wishlist!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['title']} sudah ada di wishlist!')),
        );
      }
    });
  }

  Future<void> _initializePages() async {
    try {
      final storage = await SharedPreferences.getInstance();
      String? role = storage.getString('role');

      setState(() {
        userRole = role ?? '';
      });

      await _fetchVideotapes();

      setState(() {
        _pages = [
          StorePage(
            addToWishlist: _addToWishlist,
            wishlist: _wishlist,
            userRole: userRole,
            videotapes: _videotapes,
          ),
          WishlistPage(wishlist: _wishlist),
          ProfilePage(),
        ];
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.isNotEmpty
          ? _pages[_selectedIndex]
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.store, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
