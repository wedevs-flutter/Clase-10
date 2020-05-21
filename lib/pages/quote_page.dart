import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quote_character/models/quote.dart';
import 'package:quote_character/providers/preferences_provider.dart';
import 'package:quote_character/providers/rest_provider.dart';
import 'package:quote_character/utils/image_convert.dart';
import 'package:quote_character/utils/my_colors.dart';

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  File _fileImage;

  final _userNameController = TextEditingController();
  final _quoteController = TextEditingController();
  final _characterController = TextEditingController();

  final _restProvider = RestProvider();
  final _prefs = PreferenceProvider();

  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.colorGreen1,
      width: 1.7,
    ),
    borderRadius: BorderRadius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: FutureBuilder(
        future: _prefs.getDataString(KeyList.USER_NAME),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            String userName = snapshot.data;
            _userNameController.text = userName;
            
            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: _userNameTextEditing('User'),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: _characterTextEditing(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: _quoteTextEditing(),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: _imageCharacter(),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: MyColors.colorGreen1,
      title: Text('Frase'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () async {
            Quote quote = Quote(
              author: await _prefs.getDataString(KeyList.USER_NAME),
              authorId: await _prefs.getDataString(KeyList.USER_ID),
              character: _characterController.text.trim(),
              quote: _quoteController.text.trim(),
              image: ImageConverter.imageFileToString(_fileImage),
            );
            bool resp = await _restProvider.createQuote(quote);
            if (resp) Navigator.pop(context);
          },
        ),
        IconButton(icon: Icon(Icons.camera_alt), onPressed: () => getImage()),
      ],
    );
  }

  Widget _userNameTextEditing(String user) {
    return TextField(
      controller: _userNameController,
      readOnly: true,
      decoration: InputDecoration(
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder,
        labelText: 'User name',
      ),
    );
  }

  Widget _quoteTextEditing() {
    return TextField(
      controller: _quoteController,
      maxLines: 3,
      decoration: InputDecoration(
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder,
        labelText: 'Frase',
      ),
    );
  }

  Widget _characterTextEditing() {
    return TextField(
      controller: _characterController,
      decoration: InputDecoration(
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder,
        labelText: 'Personaje',
      ),
    );
  }

  Widget _imageCharacter() {
    return _fileImage == null
        ? Center(child: Text('Ninguna imagen seleccionada'))
        : Image.file(_fileImage, fit: BoxFit.cover);
  }

  Future getImage() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _fileImage = img;
    });
  }
}
