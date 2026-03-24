import 'package:eazyshop/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EazyShop());
}

class EazyShop extends StatelessWidget {
  const EazyShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

