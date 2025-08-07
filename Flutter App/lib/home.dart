import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  final Function(int) onNavigate;
  final carouselItems = [
    Image.asset('assets/images/1.png'),
    Image.asset('assets/images/2.png'),
    Image.asset('assets/images/3.png'),
  ];
  UserHome({super.key, required this.onNavigate});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: carouselItems,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.cyan,
              ),
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      iconSize: 50,
                      color: Colors.white,
                      onPressed: () => {onNavigate(0)},
                      icon: const Icon(Icons.camera_alt)),
                  const Text("Condition",
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.cyan,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 30),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      iconSize: 50,
                      color: Colors.white,
                      onPressed: () => {onNavigate(2)},
                      icon: const Icon(Icons.money)),
                  const Text("Price",
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                ],
              ),
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 8.0,
              color: Colors.white,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.deepPurple,
                offset: Offset(3.0, 3.0),
                spreadRadius: 2.0,
                blurRadius: 5.0,
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Image.asset(
            "assets/images/accuracy.png",
          ),
        ),
      ],
    );
  }
}
