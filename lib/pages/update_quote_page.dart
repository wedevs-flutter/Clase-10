import 'package:flutter/material.dart';
import 'package:quote_character/models/quote.dart';
import 'package:quote_character/providers/rest_provider.dart';
import 'package:quote_character/utils/image_convert.dart';
import 'package:quote_character/utils/my_colors.dart';

class UpdateQuotePage extends StatefulWidget {
  @override
  _UpdateQuotePageState createState() => _UpdateQuotePageState();
}

class _UpdateQuotePageState extends State<UpdateQuotePage> {
  final _restProvider = RestProvider();

  final _characterController = TextEditingController();
  final _quoteController = TextEditingController();

  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.colorGreen1,
      width: 1.7,
    ),
    borderRadius: BorderRadius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    Quote quote = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _appBar(quote),
      body: ListView(
        children: <Widget>[
          _image(quote.image),
          _nameCharacter(quote.character),
          _quoteCharacter(quote.quote),
        ],
      ),
    );
  }

  Widget _appBar(Quote quote) {
    return AppBar(
      title: Text('Modificar frase'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () async {
            if (_quoteController.text.isNotEmpty &&
                _characterController.text.isNotEmpty) {
              quote.quote = _quoteController.text.trim();
              quote.character = _characterController.text.trim();

              bool status = await _restProvider.updateQuote(quote);

              if (status) Navigator.of(context).pop();
            } else
              Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            bool status = await _restProvider.deleteQuote(quote);
            if (status) Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _image(String image) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ImageConverter.imageFromBase64String(image),
    );
  }

  Widget _nameCharacter(String character) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: TextField(
        controller: _characterController,
        decoration: InputDecoration(
          enabledBorder: _inputBorder,
          focusedBorder: _inputBorder,
          labelText: 'Personaje',
        ),
      ),
    );
  }

  Widget _quoteCharacter(String character) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _quoteController,
        decoration: InputDecoration(
          enabledBorder: _inputBorder,
          focusedBorder: _inputBorder,
          labelText: 'Frase del personaje',
        ),
      ),
    );
  }
}
