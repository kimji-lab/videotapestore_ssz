import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'detail_page.dart';
import 'package:flutter_sign_page/Admin/admin_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StorePage extends StatefulWidget {
  final Function(Map<String, dynamic>) addToWishlist;
  final List<Map<String, dynamic>> wishlist;
  final String userRole;

  StorePage({
    required this.addToWishlist,
    required this.wishlist,
    required this.userRole,
  });

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<Map<String, dynamic>> tapes = [
    {
      'image': 'https://picsum.photos/200',
      'name': 'Starlight Knight',
      'description':
          'After the meteor shower, it was no longer the peaceful city it once was. The appearance of evil monsters with unknown purposes plunged humanity into a great crisis. At this same time, the sworn enemy of the monsters, the Starlight Knights appeared!',
      'price': '\$50',
      'videoTapeId': 'VT001',
      'genreName': 'Action',
      'genreId': 'SSZ01',
      'level': '1',
    },
    {
      'image': 'https://picsum.photos/200',
      'name': 'Don\'t Touch',
      'description':
          'Dr. Samier leads research on aliens who can shapeshift through touch, but the team is unaware that the first thing the aliens touched on Earth was him, posing unforeseen risks as they attempt to turn them into human tools or resources.',
      'price': '\$75',
      'videoTapeId': 'VT002',
      'genreName': 'Fantasy',
      'genreId': 'SSZ08',
      'level': '1',
    },
    {
      'image': 'https://picsum.photos/200',
      'name': 'Coffee Mate',
      'description': 'In the time it takes to enjoy just one cup of coffee',
      'price': '\$40',
      'videoTapeId': 'VT003',
      'genreName': 'Comedy',
      'genreId': 'SSZ04',
      'level': '1',
    },
  ];

  String searchQuery = '';
  String selectedGenre = '';
  List<Map<String, dynamic>> cart = [];

  final List<String> genres = [
    'All',
    'Action',
    'Adventure',
    'Advert',
    'Comedy',
    'Disaster',
    'Documentary',
    'Family',
    'Fantasy',
    'Interview',
    'Retro',
    'Romantic',
    'Suspense',
    'Thriller',
    'Tragic',
    'Trendy',
    'Urban',
  ];

  final List<String> carouselImages = [
    // 'backend/images_videotape/1&39.Starlight_Knight-Action.png',
    // 'backend/images_videotape/27.TreCarls-Family.png',
    // 'backend/images_videotape/34.Unlimited_Players-Suspense.png',
    // 'backend/images_videotape/38.Black_Tales-Tragic.png',
  ];

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} added to cart!')),
    );
  }

  @override
  void initState() {
    super.initState();
    searchQuery = '';
    selectedGenre = 'All';
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTapes = tapes.where((tape) {
      final matchesQuery =
          tape['name']!.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre =
          selectedGenre == 'All' || tape['genreName'] == selectedGenre;
      return matchesQuery && matchesGenre;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'backend/images_videotape/SSZlogo.png', // Path logo
              height: 50, // Tinggi logo
            ),
            const SizedBox(width: 10), // Jarak antara logo dan teks
          ],
        ),
        actions: [
          if (widget.userRole == 'admin') ...[
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPage(onCreate: (newTape) {
                      setState(() {
                        tapes.add(newTape);
                      });
                    }),
                  ),
                );
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: carouselImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image:
                              NetworkImage('http://localhost:3000/$imagePath'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    "Selected Genre:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedGenre.isEmpty ? 'All' : selectedGenre,
                      isExpanded: true,
                      items: genres.map((genre) {
                        return DropdownMenuItem<String>(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGenre = value ?? 'All';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tape = filteredTapes[index];
                final isWishlisted = widget.wishlist
                    .any((item) => item['videoTapeId'] == tape['videoTapeId']);

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        tape: tape,
                        addToCart: addToCart,
                        addToWishlist: widget.addToWishlist,
                      ),
                    ),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: Image.network(
                            tape['image'],
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tape['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                tape['description'],
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      tape['price'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isWishlisted
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isWishlisted
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      widget.addToWishlist(tape);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: filteredTapes.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.615,
            ),
          ),
        ],
      ),
    );
  }
}
