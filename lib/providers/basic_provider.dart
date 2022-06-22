import 'package:flutter/material.dart';

class BasicProvider extends ChangeNotifier{
  int temp = 0;

  void updateValue(int temp){
    this.temp = temp;
    notifyListeners();
  }
}