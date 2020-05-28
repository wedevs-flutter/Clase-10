import 'package:flutter/material.dart';
import 'package:quote_character/models/quote.dart';
import 'package:quote_character/providers/preferences_provider.dart';
import 'package:quote_character/providers/rest_provider.dart';
import 'package:quote_character/utils/my_colors.dart';
import 'package:quote_character/widgets/item_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RestProvider _provRest = RestProvider();
  PreferenceProvider _provPrefs = PreferenceProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFab(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getAllData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Quote> list = snapshot.data['list'];
                String userId = snapshot.data['userId'];
                // pintar datos
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: ItemList(quote: list[index]),
                      onTap: (list[index].authorId == userId)
                          ? () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35),
                                )),
                                builder: (context) {
                                  return _contentBottomSheet(
                                      context, list[index]);
                                },
                              );
                            }
                          : null,
                    );
                  },
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

  Widget _contentBottomSheet(BuildContext context, Quote quote) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete_forever),
            onTap: () async {
              bool resp = await _provRest.deleteQuote(quote);
              if (resp) {
                setState(() {
                  Navigator.of(context).pop();
                });
              }
            },
          ),
          ListTile(
            title: Text('Update'),
            leading: Icon(Icons.update),
            onTap: () async {
              bool resp = await _provRest.updateQuote(quote);
              if (resp) {
                setState(() {
                  Navigator.of(context).pop();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _getAllData() async {
    List<Quote> list = await _provRest.getAllQuotes();
    String userId = await _provPrefs.getDataString(KeyList.USER_ID);
    return {
      'list': list,
      'userId': userId,
    };
  }
}
