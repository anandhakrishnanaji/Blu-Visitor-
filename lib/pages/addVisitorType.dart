import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../widgets/homeGridTile.dart';
import '../providers/auth.dart';
import '../widgets/alertBox.dart';

class VisitorType extends StatelessWidget {
  static const routeName = '/addvisitor';
  @override
  Widget build(BuildContext context) {
    print(context.locale.toString());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('adav').tr(),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: FutureBuilder(
            future: Provider.of<Auth>(context, listen: false).obtainIcons(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (snapshot.hasError) {
                showDialog(
                    context: context,
                    child: Alertbox(snapshot.error.toString()));
                return SizedBox();
              } else
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'chosavis'.tr(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) =>
                              HomeGridTile(snapshot.data[index])),
                    )
                  ],
                );
            }),
      ),
    );
  }
}
