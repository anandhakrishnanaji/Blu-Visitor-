import 'package:flutter/material.dart';
import '../widgets/homeGridTile.dart';

class VisitorType extends StatelessWidget {
  static const routeName = '/addvisitor';
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add a visitor'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Choose the type of visitor',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) => HomeGridTile(_tiles[index])),
            )
          ],
        ),
      ),
    );
  }
}
