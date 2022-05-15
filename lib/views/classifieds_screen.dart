import 'dart:io';
import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mariana_marketplace/controller/api_calls.dart';
import 'package:mariana_marketplace/views/classified_filter_screen.dart';
import 'package:mariana_marketplace/components/each_post.dart';
import 'package:mariana_marketplace/secrets.dart';
import 'package:mariana_marketplace/components/fav_button.dart';
import 'package:mariana_marketplace/views/classified_full_display.dart';

import 'package:appwrite/appwrite.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ClassifiedsScreen extends StatefulWidget {
  ClassifiedsScreen({Key? key, required this.queries}) : super(key: key);
  final List queries;

  @override
  _ClassifiedsScreenState createState() => _ClassifiedsScreenState();
}

class _ClassifiedsScreenState extends State<ClassifiedsScreen> {
  static const _pageSize = 5;

  final PagingController<int, Document> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.queries);
    });
    super.initState();
  }


  Future<void> _fetchPage(int pageKey, queries) async {
    try {
      final newItems = await getClassifiedsList(pageKey, _pageSize, queries);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Classifieds'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.filter_alt_sharp),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClassifiedFilterScreen()),
                );
              },
              tooltip: 'Filter',
            ),
          ],
        ),
        body: Container(
          child: PagedListView<int, Document>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Document>(
              itemBuilder: (context, item, index) {
                return EachPost(
                 title: item.data["name"],
                 price: item.data["price"].toString(),
                 description: item.data["description"].toString(),
                 thumbnailID: item.data["images"][0].toString(),
                 classifiedID: item.data["\$id"].toString(),
                );
              },
            ),
          ),
        ),
      );
  // Don't worry about displaying progress or error indicators on screen; the
  // package takes care of that. If you want to customize them, use the
  // [PagedChildBuilderDelegate] properties.

 

  //Widget heartButton(Future<DocumentList?> favoritesFuture, String classifiedID,
  //    String classified_type) {
  //  return FutureBuilder(
  //    future: favoritesFuture,
  //    builder: (BuildContext context, AsyncSnapshot snapshot) {
  //      if (snapshot.connectionState == ConnectionState.waiting) {
  //        return IconButton(
  //            onPressed: () {
  //              createUserFavorite(
  //                classifiedID,
  //                classified_type,
  //              );
  //            },
  //            icon: const Icon(Icons.refresh));
  //      } else if (snapshot.connectionState == ConnectionState.done) {
  //        DocumentList? listOfFavs = snapshot.data;
  //        if (isFavorite(snapshot.data, classifiedID)) {
  //          return IconButton(
  //              onPressed: () {
  //                deleteUserFavorite(
  //                  classifiedID,
  //                );
  //              },
  //              icon: const Icon(Icons.favorite));
  //        } else {
  //          return IconButton(
  //              onPressed: () {
  //                createUserFavorite(
  //                  classifiedID,
  //                  classified_type,
  //                );
  //              },
  //              icon: const Icon(Icons.favorite_border));
  //        }
  //      } else {
  //        return const Text("Error");
  //      }
  //    },
  //  );
  //}
//
  //bool isFavorite(DocumentList? favoritesList, String classifiedID) {
  //  if (favoritesList != null) {
  //    for (var v in favoritesList.documents) {
  //      debugPrint(
  //          "Checking " + v.data["classified_id"] + " == " + classifiedID);
  //      if (v.data["classified_id"] == classifiedID) {
  //        return true;
  //      }
  //    }
  //  } else {
  //    debugPrint("favoritesList was null");
  //  }
//
  //  return false;
  //}

  Future<List<Document>> getClassifiedsList(
      int aOffset, int aLimit, List anQueries) async {
    // Init SDK
    Client client = Client();
    Database database = Database(client);

    debugPrint(
        "Calling getClassifiedsList with queries: " + anQueries.toString());

    client
            .setEndpoint(appwriteEndpoint) // Your API Endpoint
            .setProject(appwriteProjectID) // Your project ID
        ;
    Future<DocumentList> result = database.listDocuments(
        collectionId: classifiedsCollectionId,
        limit: aLimit,
        offset: aOffset,
        queries: anQueries);

    DocumentList finishedResult = await result;
    //debugPrint(finishedResult.toString());
    //debugPrint(finishedResult.documents.length.toString());
    //debugPrint(finishedResult.documents[0].data["name"].toString());

    return finishedResult.documents;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}





 Widget classifiedThumbnail(
      String bucketID, String fileID, int width, int height) {
    return FutureBuilder(
      future: getFilePreview(bucketID, fileID, width,
          height), //works for both public file and private file, for private files you need to be logged in
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data as Uint8List,
          );
        } else {
          return Center(
            child: Container(
                width: 16, height: 16, child: CircularProgressIndicator()),
          );
        }
      },
    );
  }