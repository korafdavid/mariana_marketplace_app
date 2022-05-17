import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mariana_marketplace/controller/AuthState.dart';
import 'package:mariana_marketplace/controller/api_calls.dart';
import 'package:mariana_marketplace/controller/fav_provider.dart';
import 'package:provider/provider.dart';

class favButton extends StatefulWidget {
  favButton({
    Key? key,
    required this.isfavorite,
    required this.classifiedID,
    required this.classified_type,
  }) : super(key: key);
  final String classifiedID;
  final Future<bool> isfavorite;
  final String classified_type;

  @override 
  State<favButton> createState() => _favButtonState();
}


class _favButtonState extends State<favButton> {
  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: true);
    ValueNotifier<bool> likeStatus = ValueNotifier<bool>(true);
    return FutureBuilder(
        future: widget.isfavorite,
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
            likeStatus.value = snapshot.data ?? false;
            debugPrint(snapshot.data.toString());
            return ValueListenableBuilder<bool>(
                valueListenable: likeStatus,
                builder: (context, value, child) {
                  return IconButton(
                      onPressed: () {
                        likeStatus.value = !(likeStatus.value);

                        if (snapshot.data == true) { 
                          state.deleteUserFavorite(
                            widget.classifiedID,
                          );
                          print('delete');
                        } else {
                          state.createUserFavorite(
                            widget.classifiedID,
                            widget.classified_type,
                          );
                        }
                      },
                      icon: value //context.watch<AuthState>().hearted
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border));
                });
          }
        });
  }
}
