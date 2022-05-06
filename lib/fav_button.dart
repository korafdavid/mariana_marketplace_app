import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mariana_marketplace/api_calls.dart';

class favButton extends StatefulWidget {
  favButton(
      {Key? key,
      required this.favoritesFuture,
      required this.classifiedID,
      required this.classified_type})
      : super(key: key);
  final Future<DocumentList?> favoritesFuture;
  final String classifiedID;
  final String classified_type;
  bool hearted = false;

  @override
  State<favButton> createState() => _favButtonState();
}

class _favButtonState extends State<favButton> {
  void getIsFavorite() async {
    DocumentList? awaitedList = await widget.favoritesFuture;

    setState(() {
      widget.hearted = isFavorite(awaitedList, widget.classifiedID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.favoritesFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return IconButton(
                onPressed: () {
                  createUserFavorite(
                    widget.classifiedID,
                    widget.classified_type,
                  );
                },
                icon: const Icon(Icons.refresh));
          } else {
            return IconButton(
                onPressed: () {
                  getIsFavorite();
                  if (widget.hearted) {
                    deleteUserFavorite(
                      widget.classifiedID,
                    );
                  } else {
                    createUserFavorite(
                      widget.classifiedID,
                      widget.classified_type,
                    );
                  }
                  setState(() {
                    widget.hearted = !widget.hearted;
                  });
                },
                icon: widget.hearted
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border));
          }
        });
  }

  bool isFavorite(DocumentList? favoritesList, String classifiedID) {
    if (favoritesList != null) {
      for (var v in favoritesList.documents) {
        if (v.data["classified_id"] == classifiedID) {
          debugPrint(
              "Checking " + v.data["classified_id"] + " == " + classifiedID);
          return true;
        }
      }
    } else {
      debugPrint("favoritesList was null");
    }

    return false;
  }
}
