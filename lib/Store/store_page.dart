import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'detail_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_sign_page/Admin/admin_page.dart';
import 'package:http/http.dart' as http; //-----------------------backend
import 'dart:convert'; //--------------------------------backend

class StorePage extends StatefulWidget {
  final Function(Map<String, dynamic>) addToWishlist;
  final List<Map<String, dynamic>> wishlist;
  final String userRole;
  final List<Map<String, dynamic>> videotapes;

  StorePage({
    required this.addToWishlist,
    required this.wishlist,
    required this.userRole,
    required this.videotapes,
  });

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  //Versi JSON tulis manual, untuk percobaan agar data MySQL dari backend ke flutter ada di bawah
  List<Map<String, dynamic>> tapes = [
    {
      'image':
          'https://drive.google.com/uc?id=1DER8lafKQWAp_MpkouxbTJTl68Sj-J4y',
      'name': 'Starlight Knight',
      'description':
          'After the meteor shower, it was no longer the peaceful city it once was. The appearance of evil monsters with unknown purposes plunged humanity into a great crisis. At this same time, the sworn enemy of the monsters, the Starlight Knights appeared!',
      'price': '\$1.00',
      'videoTapeId': 'VT001',
      'genreName': 'Action',
      'genreId': 'SSZ01',
      'level': '1',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1UIGtsvavWeFFeoFS9dOHZBHWKtlJB5We',
      'name': 'Don\'t Touch',
      'description':
          'Dr. Samier leads research on aliens who can shapeshift through touch, but the team is unaware that the first thing the aliens touched on Earth was him, posing unforeseen risks as they attempt to turn them into human tools or resources.',
      'price': '\$1.50',
      'videoTapeId': 'VT002',
      'genreName': 'Fantasy',
      'genreId': 'SSZ08',
      'level': '1',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1b_KQK3tI3Hyg5qLhOMOefJTkTYC8C879',
      'name': 'Coffee Mate',
      'description':
          'In the time it takes to enjoy just one cup of coffee, beautiful customer Angelina and a coffee machine named Mr. Rob fall in love. This is ...no more than an ordinary love story.',
      'price': '\$1.99',
      'videoTapeId': 'VT003',
      'genreName': 'Comedy',
      'genreId': 'SSZ04',
      'level': '1',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1pK24f41VqLzFMMBMgHm8wXFDNHPHxcCH',
      'name': 'Nihility',
      'description':
          'A scientist discovers an impending Hollow disaster from ancient images. Ignored by others, he tries to stop it alone but ultimately fails, proving too weak to prevent the catastrophe.',
      'price': '\$2.00',
      'videoTapeId': 'VT005',
      'genreName': 'Action',
      'genreId': 'SSZ01',
      'level': '1',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1cE7ouC-4ei2RsCc6xKaL6tvyXeX4ZFtD',
      'name': 'The Big Hollow',
      'description':
          'An intern Hollow Investigator from one of the survivor cities encounters a massive crisis on the very first day at work. An enormous Hollow suddenly expands and is predicted to engulf the entire city.',
      'price': '\$2.49',
      'videoTapeId': 'VT006',
      'genreName': 'Thriller',
      'genreId': 'SSZ13',
      'level': '1',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1UmA6IeBQMLGzQGCLkhbZmN4w9oZTx5zv',
      'name': 'The Ridu Tour',
      'description':
          'A video series for city residents or wanderers and other survivors who have recently entered the city. It introduces the different districts of New Eridu as well as how to live in the city.',
      'price': '\$2.50',
      'videoTapeId': 'VT007',
      'genreName': 'Urban',
      'genreId': 'SSZ16',
      'level': '1',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1X7UjeJuC3ZzeIIn3jq7TdxspPEEzHbRn',
      'name': 'Invasion: Next Gen',
      'description':
          'An unusual Hollow appears in a city that contains Ethereals that can exist in environments outside of the Hollows. These frightening creatures leave their nest in the Hollow, and enter the city...',
      'price': '\$2.99',
      'videoTapeId': 'VT008',
      'genreName': 'Action',
      'genreId': 'SSZ01',
      'level': '1',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1Q3GYUmmSngFVX8qEn1cfIezfsstyZn7H',
      'name': 'First Piece of Soil',
      'description':
          'A documentary about the Mayflower family, founders of Eridu, who overcame great odds. Before release, the producer changed a title word to "Cup", allegedly at the family\'s request.',
      'price': '\$2.99',
      'videoTapeId': 'VT009',
      'genreName': 'Documentary',
      'genreId': 'SSZ06',
      'level': '1',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1LX0OFXXYgP320uqvwcPE3CxQCXFOOFcc',
      'name': 'Oh~ Sweetie',
      'description':
          'Tells the tale of a beautiful lady: Monica, who has lost her memory, and the various stories that unfold in a strange city. Bold performances and scenes made it quite popular.',
      'price': '\$4.99',
      'videoTapeId': 'VT011',
      'genreName': 'Romantic',
      'genreId': 'SSZ11',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1kZYcV5t3QcBS9rpey70MgLxnYb0Au6Kb',
      'name': 'Bangboo knows!',
      'description':
          'A kids\' show featuring Bangboo teaches Hollow safety with "accidents" cleverly resolved by the host. Many believe these mishaps are scripted for entertainment.',
      'price': '\$5.00',
      'videoTapeId': 'VT014',
      'genreName': 'Documentary',
      'genreId': 'SSZ06',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1yDlP7uQxrGdNl9ChWH02MB8cBFOpvl6k',
      'name': 'Small Body Big Crisis',
      'description':
          'One day, Bob woke up as an old Bangboo in a scrapyard. In order to return to his own body, he embarked upon a tumultuous journey.',
      'price': '\$5.49',
      'videoTapeId': 'VT015',
      'genreName': 'Comedy',
      'genreId': 'SSZ04',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1q5NDVKN7YjuWI6aS2NdC31kjjs2zQsi-',
      'name': 'Final Punch',
      'description':
          'After a car crash leaves a couple as amputees, the man uses mechanical legs to join underground boxing, hoping to pay bills and uplift his girlfriend.',
      'price': '\$5.50',
      'videoTapeId': 'VT016',
      'genreName': 'Action',
      'genreId': 'SSZ01',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1sgfBdLWRTrBlvBabikxeS5xDXswm1lg-',
      'name': 'Attack on Cyberz',
      'description':
          'A virus infects robots, devices, and even Cyborgs, turning them into aggressive Cyberz. As chaos spreads, survivors flee the city and fight to resist.',
      'price': '\$5.50',
      'videoTapeId': 'VT017',
      'genreName': 'Thriller',
      'genreId': 'SSZ13',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1MgJ3tq7ihL0XGhQwqloZGQRLH2hV6auB',
      'name': 'Dimensional Musketeer',
      'description':
          'A sniper known as the Dimensional Musketeer wields Ether bullets in an epic showdown. He attempts a breathtaking 2,000-meter kill on the Ethereal King.',
      'price': '\$5.99',
      'videoTapeId': 'VT018',
      'genreName': 'Trendy',
      'genreId': 'SSZ15',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1nVmxsuDLU931Vw4OFxT776U2bSdUenJa',
      'name': '7710 and Its Cat',
      'description':
          'Based on a true story, Bangboo IGC-7710, abandoned in a Hollow, mistakes a stray cat as its rescue target. Together, they escape the Hollow and reunite the cat with its owner.',
      'price': '\$5.99',
      'videoTapeId': 'VT019',
      'genreName': 'Adventure',
      'genreId': 'SSZ02',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1o_OdyJpf1LNdyyKg4-HO6FeZrk3BYZ2G',
      'name': 'Encore',
      'description':
          'After losing her orphanage at seven, Ariely becomes a star dancer. She reimagines her childhood and the orphanage in a performance, hoping to reconnect with her old playmates.',
      'price': '\$6.00',
      'videoTapeId': 'VT020',
      'genreName': 'Tragic',
      'genreId': 'SSZ14',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1bBV_vbBoJsYqfOtiazIitK0ky9pTWKvS',
      'name': 'Family',
      'description':
          'A retired Hollow Investigator receives a message from his son, long declared MIA in a Hollow operation. Determined to uncover the truth, he embarks on a final mission.',
      'price': '\$6.49',
      'videoTapeId': 'VT022',
      'genreName': 'Action',
      'genreId': 'SSZ01',
      'level': '2',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1MhnHXUP9p2sybUMIptV0pu4008gM5Uh9',
      'name': 'This Is How I Am',
      'description':
          'A documentary explores old civilization life through multimedia. Once banned for promoting "false illusions," it was reinstated after public outcry from devoted fans.',
      'price': '\$6.99',
      'videoTapeId': 'VT024',
      'genreName': 'Documentary',
      'genreId': 'SSZ06',
      'level': '3',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1-k3hOTVMF51Mswgfg0AoPbs4ZRYLv8Ty',
      'name': 'More Than One Truth',
      'description':
          'A detective\'s cases soar after adopting his friend\'s child. Each time he nears the truth, he blacks out and wakes to find the case solved that always with conclusions that differ from his deductions.',
      'price': '\$6.99',
      'videoTapeId': 'VT025',
      'genreName': 'Comedy',
      'genreId': 'SSZ04',
      'level': '3',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1Iv-dGcJ9-vLBqG4e93u93kAEXxFE2ucx',
      'name': 'The Port Peak',
      'description':
          'A true story of young people venturing into forbidden Port Mountain, where they face the robotic monster "Lumberjack" lurking in the shadows.',
      'price': '\$7.49',
      'videoTapeId': 'VT028',
      'genreName': 'Thriller',
      'genreId': 'SSZ13',
      'level': '3',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1mNI_eyTR4Udbgdvz41RSqlxorUmcvB2m',
      'name': 'Raiders of the Hollow',
      'description':
          'A former top Hollow Investigator down on his luck joins an adventure into a Hollow to recover a mysterious treasure from the old civilization period.',
      'price': '\$7.50',
      'videoTapeId': 'VT029',
      'genreName': 'Adventure',
      'genreId': 'SSZ02',
      'level': '3',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1mf827TLkAfbcqLEGMz-mI0tA8aM9ScZM',
      'name': 'Last Flight',
      'description':
          'Stunt pilot Joseph dies in a risky stunt to prove his love. Irenda, his fiancée, uses a magical ring to go back in time to save him, but unseen forces ensure his death, and each attempt gives her less time to change their fate.',
      'price': '\$7.99',
      'videoTapeId': 'VT030',
      'genreName': 'Romantic',
      'genreId': 'SSZ11',
      'level': '3',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1N3I-Pw2tHS3uZVF2C8Wkeh51qpAtzCB1',
      'name': 'Never Overtime',
      'description':
          'An office worker at the cruel Olympus company teams up with "Teambuilding Goddess Athena" and others to wage war for one goal: getting off work on time, despite endless meetings and fitness-obsessed bosses.',
      'price': '\$7.99',
      'videoTapeId': 'VT031',
      'genreName': 'Fantasy',
      'genreId': 'SSZ08',
      'level': '3',
    },
    {
      'image':
          'https://drive.google.com/uc?id=18s_4tPt22DW2Pbyx2UCibTyPsYGgtetu',
      'name': 'Sunset Plaza',
      'description':
          'A talk show where actors, workers, scholars, entrepreneurs, and citizens share their views on recent events in New Eridu.',
      'price': '\$8.00',
      'videoTapeId': 'VT032',
      'genreName': 'Urban',
      'genreId': 'SSZ16',
      'level': '3',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1LZK5tz75zNgej2E1XwVdCB8NqnBJFL1j',
      'name': 'Best Bid',
      'description':
          'A TV shopping show sells anything imaginable, with the host\'s assistant hilariously demonstrating every item live.',
      'price': '\$8.99',
      'videoTapeId': 'VT036',
      'genreName': 'Trendy',
      'genreId': 'SSZ15',
      'level': '3',
    },
    {
      'image':
          'https://drive.google.com/uc?id=1d-zuFFEOIkKuSONnnVzP4jteKVTurdxV',
      'name': 'Black Tales',
      'description':
          'A dark stage play blends fairy tales. Gwen, a girl in a paper world, embarks on an adventure to find missing adults after they vanish one night.',
      'price': '\$9.00',
      'videoTapeId': 'VT038',
      'genreName': 'Tragic',
      'genreId': 'SSZ14',
      'level': '3',
    },
  ];

  String searchQuery = '';
  String selectedGenre = '';
  List<Map<String, dynamic>> cart = [];

  final List<String> genres = [
    'All',
    'Action',
    'Adventure',
    'Comedy',
    'Documentary',
    'Fantasy',
    'Romantic',
    'Thriller',
    'Tragic',
    'Trendy',
    'Urban',
  ];

  final List<String> carouselImages = [
    'backend/images_videotape/1&39.Starlight_Knight-Action.png',
    'backend/images_videotape/27.TreCarls-Family.png',
    'backend/images_videotape/34.Unlimited_Players-Suspense.png',
    'backend/images_videotape/38.Black_Tales-Tragic.png',
  ];

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} ditambah ke cart!')),
    );
  }

  void initState() {
    super.initState();
    fetchTapes(); //---------------------------------------backend
    searchQuery = '';
    selectedGenre = 'All';
  }

  //----------------------------------------------backend

  Future<void> fetchTapes() async {
    try {
      final uri = Uri.parse('http://localhost:3000/videotapes/read')
          .replace(queryParameters: {'genreName': selectedGenre});
      final response = await http.get(uri);

      if(response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          tapes = fetchedData.map((tape) {
            return {
              'image': 'http://localhost:3000' + tape['imagePath'],
              'name': tape['title'],
              'description': tape['description'],
              'price': tape['price'],
              'videoTapeId': tape['videoTapeId'],
              'genreName': tape['genreName'],
              'genreId': tape['genreId'],
              'level': tape['tapeLevel'],
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load tapes');
      }
    } catch (e) {
      print('Error mengambil tape: $e');
    }
  }

  // yang atas (baru) ada perubahan sedikit aja dari yang bawah (lama)
  // Future<void> fetchTapes() async { PESAN: dibekukan sebentar
  //   try {
  //     final response = await http.get(Uri.parse('http://localhost:3000/videotapes/read'));

  //     if (response.statusCode == 200) {
  //       final List<dynamic> fetchedData = json.decode(response.body);
  //       setState(() {
  //         tapes = fetchedData.map((tape) {
  //           return {
  //             'image': 'http://localhost:3000' + tape['imagePath'], // Path gambar yang diterima
  //             'name': tape['title'],
  //             'description': tape['description'],
  //             'price': tape['price'],
  //             'videoTapeId': tape['videoTapeId'],
  //             'genreName': tape['genreName'],
  //             'genreId': tape['genreId'],
  //             'level': tape['tapeLevel'],
  //           };
  //         }).toList();
  //       });
  //     } else {
  //       throw Exception('Failed to load tapes');
  //     }
  //   } catch (e) {
  //     print('Error mengambil tape: $e');
  //   }
  // }

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
              'lib/images/SSZlogo.png',
              height: 50,
            ),
            const SizedBox(width: 10),
          ],
        ),
        actions: [
          if(widget.userRole == 'admin') ...[
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () async {
                final newTape = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPage(),
                  ),
                );

                if(newTape != null && newTape is Map<String, dynamic>) {
                  setState(() {
                    tapes.add(newTape);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("${newTape['name']} ditambah ke store!")),
                  );
                }
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
                  prefixIcon: Icon(Icons.search),
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
                autoPlayInterval: Duration(seconds: 3),
              ),
              items: carouselImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(imagePath),
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
                  SizedBox(width: 10),
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
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
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
                                  Text(
                                    tape['price'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
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
              childAspectRatio: 0.57,
            ),
          ),
        ],
      ),
    );
  }
}
