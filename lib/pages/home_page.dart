import 'package:flutter/material.dart';
import 'package:quote_character/models/quote.dart';
import 'package:quote_character/providers/rest_provider.dart';
import 'package:quote_character/utils/my_colors.dart';
import 'package:quote_character/widgets/item_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _provider = RestProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFab(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<Quote>>(
          future: _provider.getAllQuotes(),
          builder: (context, snapshot) {
            if (ConnectionState.done == snapshot.connectionState) {
              if (snapshot.hasData) {
                List<Quote> list = snapshot.data;

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => ItemList(
                    quoteImage: list[index].image,
                    quoteText: list[index].quote,
                  ),
                );
              }
            }
            return Center(child: CircularProgressIndicator());
          },
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
