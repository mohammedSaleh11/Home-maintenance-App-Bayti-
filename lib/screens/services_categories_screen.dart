import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:grad_project/components/service_cat_card.dart';
import 'package:grad_project/screens/search_screen.dart';

class servicesCategories extends StatelessWidget {
  const servicesCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: AutoSizeText(
          'Choose the Service',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return searchScreen(serviceCato:"electrical");
                        }),
                      );
                    },
                    child: serviceCard(
                        Icons.electrical_services, 'Electrical', Colors.amber),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return searchScreen(serviceCato:"plumbing");
                        }),
                      );
                    },
                    child: serviceCard(
                        Icons.plumbing, 'Plumbing', Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return searchScreen(serviceCato:"carpentry");
                          }),
                        );
                      },
                      child: serviceCard(
                          Icons.carpenter, 'Carpentry', Colors.brown)),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return searchScreen(serviceCato:"hvac services");
                          }),
                        );
                      },
                      child: serviceCard(
                          Icons.hvac, 'Hvac services', Colors.cyan)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return searchScreen(serviceCato:"painting");
                          }),
                        );
                      },
                      child: serviceCard(
                          Icons.format_paint, 'Painting', Colors.green)),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return searchScreen( serviceCato:"satellite television");
                        }),
                      );
                    },
                    child: serviceCard(Icons.satellite_alt,
                        'Satellite television', Colors.blueGrey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
