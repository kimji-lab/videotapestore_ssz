import 'dart:async';
import 'dart:io'; // masih error ya ges, keknya gabisa difix deh
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var videoTapeId = TextEditingController();
  var title = TextEditingController();
  var price = TextEditingController();
  var description = TextEditingController();
  var genreId = TextEditingController();
  var tapeLevel = TextEditingController();

  File? _imageFile;
  bool isLoading = false;

  Future<void> _pickImage() async {
    if(isLoading) return;

    try {
      setState(() {
        isLoading = true;
      });

      final picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if(!mounted) return;

      if(pickedImage != null) {
        final file = File(pickedImage.path);
        setState(() {
          _imageFile = file;
        });
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error image: $e')),
        );
      }
    } finally {
      if(mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    try {
      if(_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image harus dipilih')),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      var uri = Uri.parse('http://localhost:3000/api/videotapes/create');
      var request = http.MultipartRequest('POST', uri);

      request.fields['videoTapeId'] = videoTapeId.text;
      request.fields['title'] = title.text;
      request.fields['price'] = price.text;
      request.fields['description'] = description.text;
      request.fields['genreId'] = genreId.text;
      request.fields['tapeLevel'] = tapeLevel.text;

      var stream = http.ByteStream(_imageFile!.openRead());
      var length = await _imageFile!.length();
      
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: _imageFile!.path.split('/').last
      );
      
      request.files.add(multipartFile);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if(response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Videotape berhasil ditambahkan')),
        );
        setState(() {
          videoTapeId.clear();
          title.clear();
          price.clear();
          description.clear();
          genreId.clear();
          tapeLevel.clear();
          _imageFile = null;
        });
        Navigator.pop(context);
      } else {
        var error = json.decode(responseData);
        if(error['message'].contains('Duplicate entry')) {
          throw Exception('VideoTape ID sudah digunakan');
        } else {
          throw Exception('Gagal, status: ${response.statusCode}');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Admin Page'),
      backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: videoTapeId,
                decoration: const InputDecoration(labelText: 'VideoTape Id')),
            TextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: price,
                decoration: const InputDecoration(labelText: 'Price')),
            TextField(
                controller: description,
                decoration: const InputDecoration(labelText: 'Description')),
            TextField(
                controller: genreId,
                decoration: const InputDecoration(labelText: 'Genre ID')),
            TextField(
                controller: tapeLevel,
                decoration: const InputDecoration(labelText: 'Tape Level')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
              ),
              child: const Text('Pilih Gambar',),
            ),
            if (_imageFile != null) ...[
              const SizedBox(height: 10),
              Image.file(_imageFile!),
            ],
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white
                    ),
                    child: const Text('Insert'),
                  ),
          ],
        ),
      ),
    );
  }
}