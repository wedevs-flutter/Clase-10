import 'package:flutter/material.dart';
import 'package:quote_character/models/quote.dart';
import 'package:quote_character/providers/preferences_provider.dart';
import 'package:quote_character/utils/image_convert.dart';

class ItemList extends StatelessWidget {
  final Quote quote;
  final _prefs = PreferenceProvider();

  ItemList({this.quote});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        if (await _validate()) {
          Navigator.of(context).pushNamed('update_quote', arguments: quote);
        }
      },
      child: Container(
        margin: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(
                  ImageConverter.dataFromBase64String(quote.image),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                _bgColor(Colors.black),
                _quoteText(quote.quote),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bgColor(Color black) {
    return Container(
      color: Colors.black.withOpacity(0.5),
    );
  }

  Widget _quoteText(String quote) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          '"$quote"',
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<bool> _validate() async {
    String userId = await _prefs.getDataString(KeyList.USER_ID);
    if (userId == quote.authorId)
      return true;
    else
      return false;
  }
}
