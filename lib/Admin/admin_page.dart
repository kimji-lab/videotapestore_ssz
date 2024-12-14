import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreate;

  AdminPage({required this.onCreate});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _videoTapeIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _genreIdController = TextEditingController();
  final _tapeLevelController = TextEditingController();
  final _imagePathController = TextEditingController();

  void _createTape() {
    if (_formKey.currentState!.validate()) {
      final newTape = {
        'videoTapeId': _videoTapeIdController.text,
        'name': _titleController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'genreId': _genreIdController.text,
        'level': _tapeLevelController.text,
        'image': _imagePathController.text,
      };

      widget.onCreate(newTape);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('VideoTape created successfully!')),
      );

      Navigator.pop(context); // Kembali ke StorePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _videoTapeIdController,
                decoration: const InputDecoration(labelText: 'VideoTape ID'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter VideoTape ID'
                    : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter title'
                    : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter price'
                    : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter description'
                    : null,
              ),
              TextFormField(
                controller: _genreIdController,
                decoration: const InputDecoration(labelText: 'Genre ID'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter genre ID'
                    : null,
              ),
              TextFormField(
                controller: _tapeLevelController,
                decoration: const InputDecoration(labelText: 'Tape Level'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter tape level'
                    : null,
              ),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(labelText: 'Image Path'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter image path'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createTape,
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
