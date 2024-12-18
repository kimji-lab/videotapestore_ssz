import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> tape;
  final Function(Map<String, dynamic>) addToCart;
  final Function(Map<String, dynamic>) addToWishlist;

  DetailPage({
    required this.tape,
    required this.addToCart,
    required this.addToWishlist
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isDescriptionExpanded = false;
  bool _isWishlisted = false;  //buat membuat tombol wishlist nya jadi merah saat dipencet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        //tombol wishlist
        actions: [
          IconButton(
            icon: Icon(
              _isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: _isWishlisted ? Colors.red : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isWishlisted = !_isWishlisted;
              });
              if (_isWishlisted) {
                widget.addToWishlist(widget.tape);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.tape['name']} ditambah ke wishlist')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.tape['name']} dihapus dari wishlist')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.tape['image'],
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tape['name'],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        'Genre: ${widget.tape['genreName']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Level: ${widget.tape['level']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Harga
                  Text(
                    '${widget.tape['price']}',
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    isDescriptionExpanded
                        ? widget.tape['description']
                        : '${widget.tape['description'].substring(0, 50)}...', 
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDescriptionExpanded = !isDescriptionExpanded;
                      });
                    },
                    child: Text(
                      isDescriptionExpanded ? 'Show less' : 'Read more',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 120),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        widget.addToCart(widget.tape);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${widget.tape['name']} ditambah ke cart!')),
                        );
                      },
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
