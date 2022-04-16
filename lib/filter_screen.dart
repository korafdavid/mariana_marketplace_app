import 'dart:io';

import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mariana_marketplace/secrets.dart';
import 'package:mariana_marketplace/login_screen.dart';
import 'package:appwrite/appwrite.dart';

import 'landing_screen.dart';

class FilterScreen extends StatefulWidget {
  // final Data data;
  // FilterScreen({required this.data});
  // const TestScreen({Key? key, }) : super(key: key);
  // const CarScreen(Key? key) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int _counter = 0;
  final _suggestions = <String>[];
  final _classifiedList = <Card>[];
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  TextEditingController searchTextBoxController = TextEditingController();

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
    String _name = '11111';
    var query = [Query.equal('name', 'watch')];
    // var query = [Query.equal('name', widget.data.text)];

    

    client
            .setEndpoint(appwriteEndpoint) // Your API Endpoint
            .setProject(appwriteProjectID) // Your project ID
        ;
    Future<DocumentList> result = database.listDocuments(
      collectionId: classifiedsCollectionId,
      orderAttributes: ["name"],
      orderTypes: ['ASC'],
      queries: query,
      // [Query.equal('name', ['11111', 'watch'])],
    );

    DocumentList finishedResult = await result;
    debugPrint(finishedResult.toString());

    debugPrint(finishedResult.documents[0].data["name"].toString());

    return finishedResult.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: const Text('Filter Screen'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.filter_alt_sharp),
        //     onPressed: (){
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => TestScreen()),
        //       );
        //     },
        //     tooltip: 'Saved Suggestions',
        //   ),
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Center(
            child: Text(
              "Price",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: const [
              Expanded(
                  child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'From',
                ),
              )),
              SizedBox(width: 16), // Use this to add some space
              Expanded(
                  child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'To',
                ),
              )),
            ],
          ),
          const Center(
            child: Text(
              "Key Word",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: searchTextBoxController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your username',
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: submit,
                // onPressed: () => showDialog<String>(
                //   context: context,
                //   builder: (BuildContext context) => AlertDialog(
                //     title: const Text('AlertDialog Title'),
                //     content: const Text('AlertDialog description'),
                //     actions: <Widget>[
                //       TextButton(
                //         onPressed: () => Navigator.pop(context, 'Cancel'),
                //         child: const Text('Cancel'),
                //       ),
                //       TextButton(
                //         onPressed: () => Navigator.pop(context, 'OK'),
                //         child: const Text('OK'),
                //       ),
                //     ],
                //   ),
                // ),
              child: const Text('Submit'),
            )
          ),
        ],
      ),
      // body: Column(
      //   // height: 200,
      //   // color: Colors.blue,
      //   children: [
      //     Expanded(
      //       flex: 2,
      //       child: Row(
      //         // color: Colors.blueGrey[600],
      //         children: const [
      //           Expanded(
      //             flex: 1,
      //             child: Card(
      //               color: Colors.blueGrey,
      //               child: Text("something biggersad"),
      //             ),
      //           ),
      //           Text("data"),
      //         ],
      //       ),
      //     ),
      //     // Row(
      //     //   children: const [
      //     //     TextField(
      //     //       decoration: InputDecoration(
      //     //         border: OutlineInputBorder(),
      //     //         hintText: 'Enter a search term',
      //     //       ),
      //     //     ),
      //     //   ],
      //     // )
      //   ],
      // ),
    );
  }
  void submit(){
    Navigator.of(context).pop(searchTextBoxController.text);
  }

  // Widget cardBuilder() {
  //   getClassifiedsList();
  //   return FutureBuilder(
  //     future: getClassifiedsList(),
  //     builder: (context, AsyncSnapshot snapshot) {
  //       if (!snapshot.hasData) {
  //         if (!Platform.isIOS) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         } else {
  //           return const Center(child: CupertinoActivityIndicator());
  //         }
  //       } else {
  //         return ListView.builder(
  //             itemCount: snapshot.data.length,
  //             itemBuilder: (context, i) {
  //               return classifiedCard(
  //                   snapshot.data[i].data["name"].toString(),
  //                   snapshot.data[i].data["name"].toString(),
  //                   snapshot.data[i].data["price"].toString(),
  //                   snapshot.data[i].data["description"].toString());
  //             });
  //       }
  //     },
  //   );
  // }

  // Widget classifiedCard(
  //   String saved,
  //   String Title,
  //   String Price,
  //   String Description,
  // ) {
  //   final alreadySaved = _saved.contains(saved);
  //   return Container(
  //     // color: Colors.black,
  //     padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
  //     height: 200,
  //     width: double.maxFinite,
  //     child: Card(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //       elevation: 10,
  //       child: Row(
  //         children: [
  //           Expanded(
  //             flex: 2,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(15),
  //                 image: const DecorationImage(
  //                     image: NetworkImage(
  //                         "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
  //                     fit: BoxFit.cover),
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             flex: 2,
  //             child: Column(
  //               children: [
  //                 Text(
  //                   Title,
  //                   style: const TextStyle(
  //                     fontSize: 30,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 Text(Price),
  //                 Text(Description),
  //               ],
  //             ),
  //           ),
  //           IconButton(
  //             icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
  //             color: alreadySaved ? Colors.red : Colors.grey,
  //             onPressed: () {
  //               getClassifiedsList();
  //               setState(() {
  //                 if (alreadySaved) {
  //                   _saved.remove(saved);
  //                 } else {
  //                   _saved.add(saved);
  //                 }
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}