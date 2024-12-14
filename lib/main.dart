import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_sign_page/Register/login_page.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const LoginPage(),
  ));
}
