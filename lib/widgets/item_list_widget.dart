import 'package:flutter/material.dart';
import 'package:quote_character/models/quote.dart';
import 'package:quote_character/utils/image_convert.dart';

class ItemList extends StatelessWidget {
  final Quote quote;

  ItemList({this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(
                  ImageConverter.dataFromBase64String(quote.image)),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              _bgColor(Colors.black),
              _quoteText(quote.quote, quote.author),
            ],
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

  Widget _quoteText(String quote, String author) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
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
            SizedBox(height: 15),
            Text(
              '"$author"',
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
