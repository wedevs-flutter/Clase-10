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
  final _userNameController = TextEditingController();
  final _quoteController = TextEditingController();
  final _characterController = TextEditingController();
  final _prefs = PreferenceProvider();
  final _restProvider = RestProvider();

  File _fileImage;
  Future _futurePrefs;

  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.colorGreen1,
      width: 1.7,
    ),
    borderRadius: BorderRadius.circular(20),
  );

  @override
  void initState() {
    _futurePrefs = _prefs.getDataString(KeyList.USER_NAME);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: FutureBuilder<String>(
        future: _futurePrefs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String userName = snapshot.data;

            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: _userNameTextEditing(userName),
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

  Future<bool> _doPostQuote(String img) async {
    if (_quoteController.text.isEmpty ||
        _characterController.text.isEmpty ||
        _fileImage == null) {
      return false;
    } else {
      Quote quote = Quote(
        quote: _quoteController.text.trim(),
        character: _characterController.text.trim(),
        image: img,
      );
      return await _restProvider.createNewQuote(quote);
    }
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: MyColors.colorGreen1,
      title: Text('Frase'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () async {
            var imgBase64 = ImageConverter.imageFileToString(_fileImage);
            bool statusSend = await _doPostQuote(imgBase64);
            if (statusSend) Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
          },
        ),
        IconButton(icon: Icon(Icons.camera_alt), onPressed: () => getImage()),
      ],
    );
  }

  Widget _userNameTextEditing(String user) {
    _userNameController.text = user;
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
