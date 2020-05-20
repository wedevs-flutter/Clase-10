import 'package:flutter/material.dart';
import 'package:quote_character/utils/image_convert.dart';

class ItemList extends StatelessWidget {
  final String quoteText;
  final String quoteImage;

  ItemList({this.quoteText, this.quoteImage});

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
                ImageConverter.dataFromBase64String(quoteImage),
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              _bgColor(Colors.black),
              _quoteText(quoteText),
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
}
