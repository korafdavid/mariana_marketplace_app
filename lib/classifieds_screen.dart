import 'dart:io';

import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mariana_marketplace/secrets.dart';
import 'package:appwrite/appwrite.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ClassifiedsScreen extends StatefulWidget {
  const ClassifiedsScreen({Key? key}) : super(key: key);

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
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getClassifiedsList(pageKey, _pageSize);
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
          title: const Text('Classified Screen'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.list),
          //     onPressed: _pushSaved,
          //     tooltip: 'Saved Suggestions',
          //   ),
          // ],
        ),
        body: Container(
          child: PagedListView<int, Document>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Document>(
              itemBuilder: (context, item, index) {
                return classifiedCard(
                    item.data["name"].toString(),
                    item.data["price"].toString(),
                    item.data["description"].toString());
              },
            ),
          ),
        ),
      );
  // Don't worry about displaying progress or error indicators on screen; the
  // package takes care of that. If you want to customize them, use the
  // [PagedChildBuilderDelegate] properties.

  Widget classifiedCard(
    String Title,
    String Price,
    String Description,
  ) {
    return Container(
      // color: Colors.black,
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
      height: 200,
      width: double.maxFinite,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    Title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(Price),
                  Text(Description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Document>> getClassifiedsList(int aOffset, int aLimit) async {
    // Init SDK
    Client client = Client();
    Database database = Database(client);

    client
            .setEndpoint(appwriteEndpoint) // Your API Endpoint
            .setProject(appwriteProjectID) // Your project ID
        ;
    Future<DocumentList> result = database.listDocuments(
      collectionId: classifiedsCollectionId,
      limit: aLimit,
      offset: aOffset,
    );

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
