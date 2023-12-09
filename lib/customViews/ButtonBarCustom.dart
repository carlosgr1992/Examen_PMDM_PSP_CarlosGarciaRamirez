import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../APIS/Chistes_API.dart';

class ButtonBarCustom extends StatelessWidget {
  final VoidCallback onListPressed;
  final VoidCallback onGridPressed;

  ButtonBarCustom({required this.onListPressed, required this.onGridPressed});

  void _showJokeDialog(BuildContext context, String joke) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chiste'),
          content: Text(joke),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: onListPressed,
          child: Text('Lista'),
        ),
        ElevatedButton(
          onPressed: onGridPressed,
          child: Text('Grid'),
        ),
        ElevatedButton(
          onPressed: () => _muestraChiste(context),
          child: Text('Chiste'),
        ),
      ],
    );
  }

  void _muestraChiste(BuildContext context) async {
    String joke = await buscaChistes();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chiste'),
          content: Text(joke),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

}
