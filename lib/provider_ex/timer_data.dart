import 'package:flutter/cupertino.dart';

class TimerData extends ChangeNotifier{
  int _time_remain_provider = 11;
  int getRemainProvider() => _time_remain_provider;
  updateRemainingTime(){
    _time_remain_provider--;
    notifyListeners();
  }
}