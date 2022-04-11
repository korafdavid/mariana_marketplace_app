import 'dart:io';

import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mariana_marketplace/secrets.dart';
import 'package:mariana_marketplace/login_screen.dart';
import 'package:appwrite/appwrite.dart';

class CarScreen extends StatefulWidget {
  // const CarScreen(Key? key) : super(key: key);

  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  int _counter = 0;
  final _suggestions = <String>[];
  final _classifiedList = <Card>[];
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  Future<List<Document>> getClassifiedsList() async {
    // Init SDK
    Client client = Client();
    Database database = Database(client);

    client
            .setEndpoint(appwriteEndpoint) // Your API Endpoint
            .setProject(appwriteProjectID) // Your project ID
        ;
    Future<DocumentList> result = database.listDocuments(
      collectionId: classifiedsCollectionId,
    );

    DocumentList finishedResult = await result;
    debugPrint(finishedResult.toString());

    debugPrint(finishedResult.documents[0].data["name"].toString());

    return finishedResult.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.list),
        //     onPressed: _pushSaved,
        //     tooltip: 'Saved Suggestions',
        //   ),
        // ],
      ),
      body: Container(child: cardBuilder()),
    );
  }

  Widget cardBuilder() {
    getClassifiedsList();
    return FutureBuilder(
      future: getClassifiedsList(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          if (!Platform.isIOS) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return classifiedCard(
                    snapshot.data[i].data["name"].toString(),
                    snapshot.data[i].data["name"].toString(),
                    snapshot.data[i].data["price"].toString(),
                    snapshot.data[i].data["description"].toString());
              });
        }
      },
    );
  }

  Widget classifiedCard(
    String saved,
    String Title,
    String Price,
    String Description,
  ) {
    final alreadySaved = _saved.contains(saved);
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
            IconButton(
              icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
              color: alreadySaved ? Colors.red : Colors.grey,
              onPressed: () {
                getClassifiedsList();
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(saved);
                  } else {
                    _saved.add(saved);
                  }
                });
              },
            ),
          ],
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.amber,
        //     borderRadius: BorderRadius.circular(30),
        //     border: Border(
        //       top: BorderSide(width: 2.0, color: Colors.black),
        //     ),
        //     // color: Colors.white,
        //   ),
        //   child: Card(child: Text("aworde"),
        //   color: Colors.pink,
        //   ),
        //   // Padding(
        //   //   padding: const EdgeInsets.all(7),
        //   //   child: Stack(children: <Widget>[
        //   //     Align(
        //   //       alignment: Alignment.centerRight,
        //   //       child: Stack(
        //   //         children: <Widget>[
        //   //           Padding(
        //   //               padding: const EdgeInsets.only(left: 10, top: 5),
        //   //               child: Column(
        //   //                 children: <Widget>[
        //   //                   Row(
        //   //                     children: <Widget>[
        //   //                       Text("spot 1"),
        //   //                       SizedBox(
        //   //                         height: 10,
        //   //                       ),
        //   //                       Text("spot 2"),
        //   //                       Spacer(),
        //   //                       Text("spot 3"),
        //   //                       SizedBox(
        //   //                         width: 10,
        //   //                       ),
        //   //                       Text("spot 4"),
        //   //                       SizedBox(
        //   //                         width: 20,
        //   //                       )
        //   //                     ],
        //   //                   ),
        //   //                   Row(
        //   //                     children: <Widget>[
        //   //                       Text("spot 5"),
        //   //                     ],
        //   //                   )
        //   //                 ],
        //   //               ))
        //   //         ],
        //   //       ),
        //   //     )
        //   //   ]),
        //   // ),
        // ),
      ),
      // leading: ConstrainedBox(
      //   constraints: const BoxConstraints(
      //     minWidth: 75,
      //     minHeight: 100,
      //     // maxWidth: 100,
      //     // maxHeight: 100,
      //   ),
      //   child: Image.network("https://images.unsplash.com/photo-1579202673506-ca3ce28943ef", fit: BoxFit.cover),
      // ),
      // title: Text(
      //   pair.toString(),
      //   style: _biggerFont,
      // ),
      // trailing: IconButton(
      //   icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
      //   color: alreadySaved ? Colors.red : null,
      //   onPressed: () {
      //     setState(() {
      //       if (alreadySaved) {
      //         _saved.remove(pair);
      //       } else {
      //         _saved.add(pair);
      //       }
      //     });
      //   },
      // ),
    );
  }

  Widget _buildRowTest(String pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      leading: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 75,
          minHeight: 100,
          // maxWidth: 100,
          // maxHeight: 100,
        ),
        child: Image.network(
            "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef",
            fit: BoxFit.cover),
      ),
      title: Text(
        pair.toString(),
        style: _biggerFont,
      ),
      trailing: IconButton(
        icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
        color: alreadySaved ? Colors.red : null,
        onPressed: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      ),
      onTap: () {
        debugPrint('Nemo touched the butt');
      },
    );
  }

  // void _pushSaved() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute<void>(
  //       builder: (context) {
  //         final tiles = _saved.map(
  //           (pair) {
  //             return ListTile(
  //               title: Text(
  //                 pair.toString(),
  //                 style: _biggerFont,
  //               ),
  //             );
  //           },
  //         );
  //         final divided = tiles.isNotEmpty
  //             ? ListTile.divideTiles(
  //                 context: context,
  //                 tiles: tiles,
  //               ).toList()
  //             : <Widget>[];

  //         return Scaffold(
  //           appBar: AppBar(
  //             title: const Text('Saved Suggestions'),
  //           ),
  //           body: ListView(children: divided),
  //         );
  //       },
  //     ),
  //   );
  // }

}
