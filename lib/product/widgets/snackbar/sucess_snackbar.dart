import 'package:flutter/material.dart';

class SucessSnackBar extends SnackBar {
  SucessSnackBar() : super(content: Row(children: [Icon(Icons.check), Text('Sucess to add')]));
}
