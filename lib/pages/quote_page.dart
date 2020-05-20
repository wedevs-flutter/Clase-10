import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.colorGreen1,
      width: 1.7,
    ),
    borderRadius: BorderRadius.circular(20),
  );

  @override
  void initState() {
    _userNameController.text = 'Juanito';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
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
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: MyColors.colorGreen1,
      title: Text('Frase'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.check), onPressed: () {
          // TODO: make post quote
          Navigator.pop(context);
        }),
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
