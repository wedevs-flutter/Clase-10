import 'package:flutter/material.dart';
import 'package:quote_character/utils/my_colors.dart';
import 'package:quote_character/widgets/item_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFab(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 3));
        },
        child: ListView(
          children: <Widget>[
            ItemList(
              quoteText: 'Esto es una frase super chevere',
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, 'quote');
      },
      child: Icon(Icons.add),
      backgroundColor: MyColors.colorGreen1,
    );
  }
}
