import 'dart:io';
import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:mariana_marketplace/classified_filter_screen.dart';

import 'package:mariana_marketplace/secrets.dart';
import 'package:appwrite/appwrite.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ClassifiedsScreen extends StatefulWidget {
  ClassifiedsScreen({Key? key, required this.queries}) : super(key: key);
  final List<String> queries;

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
                return classifiedCard(
                  item.data["name"],
                  item.data["price"].toString(),
                  item.data["description"].toString(),
                  item.data["images"][0].toString(),
                );
              },
            ),
          ),
        ),
      );
  // Don't worry about displaying progress or error indicators on screen; the
  // package takes care of that. If you want to customize them, use the
  // [PagedChildBuilderDelegate] properties.

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

  Widget classifiedCard(
      String Title, String Price, String Description, String ThumbnailID) {
    return Container(
      // color: Colors.black,
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
      height: 200,
      width: double.maxFinite,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: classifiedThumbnail(
                        "6259fa52f2266bd32b41",
                        ThumbnailID,
                        150,
                        150,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Text(
                      Title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text("\$$Price"),
                    Spacer(),
                    Spacer(),
                    Text(
                        ("Brief: BLEBIBJEIJARIERJALADKFJASKLDFJASLKDFJASKLDFJASDKLFJASDFKLJASDFKLASJDFKLASJDFA" +
                                    Description)
                                .substring(0, 50) +
                            "..."),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Document>> getClassifiedsList(
      int aOffset, int aLimit, List<String> anQueries) async {
    // Init SDK
    Client client = Client();
    Database database = Database(client);

    debugPrint(
        "Calling getClassifiedsList with queries" + anQueries.toString());

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
    debugPrint(finishedResult.toString());
    debugPrint(finishedResult.documents.length.toString());
    //debugPrint(finishedResult.documents[0].data["name"].toString());

    return finishedResult.documents;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
