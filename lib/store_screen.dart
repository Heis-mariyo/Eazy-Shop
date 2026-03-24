import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<Map> _prods = [];
  final List<int> _cartItems = [];
  List<Map> _searchItems = [];

  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Uri uri = Uri.parse("https://fakestoreapi.com/products");
    get(uri).then((res) {
      final data = jsonDecode(res.body) as List;
      setState(() {
        _prods.addAll(data.map((e) => e as Map));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: appBar(),
      bottomNavigationBar: navigationBar(),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          searchBar(),
          SizedBox(height: 15.0),
          if (_prods.isEmpty) ...[
            Spacer(),
            SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Colors.orange.shade300,
              ),
            ),
            Spacer(),
          ] else
            _page ==0 ? carouselSlider() : listWidget(),
        ],
      ),
    );
  }

  listWidget() {
    var items = _prods;
    if (_searchItems.isNotEmpty) {
      items = _searchItems;
    }
    return Expanded(
      child: ListView(
        children: items.map((e) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10.0,
                  offset: Offset(0, 3),
                )
                ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20.0, 
              vertical: 15.0,
            ),
            margin: EdgeInsets.symmetric( vertical: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  e['image'], 
                  height: 100.0,
                  width: 60.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0),
                      Text(e['title']),
                      SizedBox(height: 5.0),
                      addCartBtn(e),
                    ],
                  ),
                ),
                prodRating(e),
              ],
            )
          );
        }).toList(),
      ),
    );
  }

  Container searchBar() {
    return Container(
          margin: EdgeInsets.symmetric(horizontal: 25.0),
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 10.0),
              Expanded(
                child: TextField(
                  onChanged: (v) {
                    setState(() {
                      _searchItems = _prods
                        .where(
                          (prod) => (prod['title'] as String)
                              .toLowerCase()
                              .contains(v.toLowerCase()),
                        )
                        .toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search for any product",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex:_page,
      onTap: (v) {
        setState(() {
          _page = v;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.swipe),
          label: "Swipe",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "List",
        )
      ],
    );
  }

  CarouselSlider carouselSlider() {
    var items = _prods;
    if (_searchItems.isNotEmpty) {
      items = _searchItems;
    }
    return CarouselSlider(
      items: items.map((e) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10.0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child:  prodRating(e),
                  ),
                  Spacer(),
                  Image.network(e['image'], height: 200),
                  Spacer(),
                  Text(
                    e["title"],
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    e['description'],
                    maxLines: 3,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                  SizedBox(height: 20.0),
                  addCartBtn(e),
                ],
              ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 480,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        autoPlay: true,
        autoPlayAnimationDuration: Duration(seconds: 2),
      ),
    );
  }

  Container prodRating(Map<dynamic, dynamic> e) {
    return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.blueGrey.shade50,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 15.0),
                        SizedBox(width: 5.0),
                        Text(
                          "${e['rating']['rate']} out of 5",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
  }

  Row addCartBtn(Map<dynamic, dynamic> e) {
    return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "\$${e['price']}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_cartItems.contains(e['id'])) {
                            _cartItems.remove(e['id']);
                          } else {
                            _cartItems.add(e['id']);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.shade50,
                        ),
                        child: Icon(
                          _cartItems.contains(e['id'])
                              ? Icons.remove_shopping_cart_rounded
                              : Icons.shopping_cart_rounded,
                          size: 20.0,
                          color: Colors.orange.shade500,
                        ),
                      ),
                    ),
                  ],
                );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.orange.shade50,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Color(0xFFC8B893)),
      title: Center(
        child: Text(
          "EazyShop",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xffc8b893),
          ),
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart_rounded),
            ),
            Positioned(
              top: 5.0,
              right: 5.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(5.0),
                child: Text(
                  _cartItems.length.toString(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffc8b893),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
