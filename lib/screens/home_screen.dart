import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:grad_project/screens/search_screen.dart';
import 'package:grad_project/screens/services_categories_screen.dart';

import '../models/JobRatingService.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> myitems = [
    Image.asset('images/Carpenter-home-maintenance.jpeg'),
    Image.asset('images/electrician-home-maintenance.jpg'),
    Image.asset('images/hvac-home-maintenance.jpg'),
    Image.asset('images/painter-home-maintenance.jpg'),
    Image.asset('images/plumbing.jpeg'),


  ];
  int mycurrentindex = 0;

  int slider_index = 0;

  @override
  Widget build(BuildContext context) {
    jobRatingService jobratingservice =jobRatingService(context);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CarouselSlider(
              items: myitems,
              options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    slider_index = index;
                  });
                },
              ),
            ),
            DotsIndicator(
              dotsCount: myitems.length,
              position: slider_index.toInt(),
            ),
            Container(
              width: double.infinity,
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () { Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return servicesCategories();
                  }),
                );},
                child: Flexible(
                  child: Text(
                    'Search for Service Providers',
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
