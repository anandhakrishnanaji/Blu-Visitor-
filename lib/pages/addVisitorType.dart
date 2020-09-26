import 'package:flutter/material.dart';
import '../widgets/homeGridTile.dart';

class VisitorType extends StatelessWidget {
  final List<String> _tiles = [
    'Guest',
    'Cab',
    'Delivery',
    'Maintenance',
    'Emergency'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a visitor'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text('Choose the type of visitor'),
            Expanded(
              child: GridView.builder(
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) => HomeGridTile(_tiles[index])),
            )
          ],
        ),
      ),
    );
  }
}
