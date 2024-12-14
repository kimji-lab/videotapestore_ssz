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
  bool _isWishlisted = false;  //untuk membuat tombol wishlist nya jadi merah saat dipencet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        //tombol wishlist
        actions: [
          IconButton(
            icon: Icon(
              _isWishlisted ? Icons.favorite : Icons.favorite_border, // Ganti ikon berdasarkan status
              color: _isWishlisted ? Colors.red : Colors.black, // Ganti warna berdasarkan status
            ),
            onPressed: () {
              setState(() {
                _isWishlisted = !_isWishlisted; // Toggle status
              });
              if (_isWishlisted) {
                widget.addToWishlist(widget.tape);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.tape['name']} added to wishlist')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.tape['name']} removed from wishlist')),
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
            // Gambar Produk
            Center(
              child: Image.network(
                widget.tape['image'],
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // Informasi Produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Barang
                  Text(
                    widget.tape['name'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  // Genre dan Level
                  Row(
                    children: [
                      Text(
                        'Genre: ${widget.tape['genreName']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          backgroundColor: Colors.grey[300]
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Level: ${widget.tape['level']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                            backgroundColor: Colors.grey[300]
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Harga
                  Text(
                    '${widget.tape['price']}',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                  SizedBox(height: 16),

                  // Deskripsi
                  Text(
                    isDescriptionExpanded
                        ? widget.tape['description']
                        : '${widget.tape['description'].substring(0, 50)}...', // Potong teks jika tidak diperluas
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Tombol Add to Cart
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 120),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        widget.addToCart(widget.tape);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${widget.tape['name']} added to cart!')),
                        );
                      },
                      child: Text(
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
