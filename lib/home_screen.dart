import 'package:eazyshop/store_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade400.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(150.0),
                      topRight: Radius.circular(150.0),
                    )
                  )
                ),
                Positioned.fill(
                  bottom: -20,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "EazyShop",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ],
            ), 
            SizedBox(height: 50.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StoreScreen(),
                  ),
                );
              }, 
              child: Text(
                "Open Store",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                ),
            )
            ]),
      ) ,
    );
  }
} 