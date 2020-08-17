import 'package:flutter/cupertino.dart';

class Classifier extends ChangeNotifier {

  String _group;

  String get group => _group;

  void setGroupName(String group){
    _group = group;
    notifyListeners();
  }
}