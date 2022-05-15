import 'package:flutter/material.dart';

class IconState extends ChangeNotifier {
  var favIcon = const Icon(Icons.favorite);

  void changeFavIcon(Icon icon) {
    favIcon = icon;
    notifyListeners();
  }
}
