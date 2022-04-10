import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:mariana_marketplace/login_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Screen'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.list),
        //     onPressed: _pushSaved,
        //     tooltip: 'Saved Suggestions',
        //   ),
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        color: Colors.grey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Card(
                  color: Colors.blueGrey,
                  child: IconButton(
                    icon: const Icon(
                      Icons.list,
                    ),
                    onPressed: _resetCounter,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Card(
                    color: Colors.blueGrey,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                      ),
                      onPressed: _resetCounter,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.blueGrey,
                    child: IconButton(
                      icon: const Icon(
                        Icons.account_circle_sharp,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _buildSuggestions(),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: [
              //     Expanded(
              //       child: GestureDetector(
              //         onTap: () {
              //           // Navigator.push(context, route)
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(15),
              //             image: const DecorationImage(
              //                 image: NetworkImage(
              //                     "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
              //                 fit: BoxFit.cover),
              //           ),
              //           child: Card(
              //             color: Colors.transparent,
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(15)),
              //             shadowColor: Colors.grey,
              //             child: Align(
              //               alignment: FractionalOffset.bottomCenter,
              //               child: Text(
              //                 'Cars $_counter',
              //                 style: const TextStyle(
              //                     fontSize: 30, fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      // padding: const EdgeInsets.all(10),
      itemCount: 20, //I think I need this
      itemBuilder: (context, i) {
        // if (i.isOdd) {
        //   return const Divider();
        // }

        // final index = i ~/ 2;
        final index = i;
        if (index >= _suggestions.length) {
          _suggestions.addAll([
            'one',
            'two',
            'three',
            'four',
            'five',
            '6',
            '7',
            '8',
            '9',
            '10'
          ]);
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(String pair) {
    final alreadySaved = _saved.contains(pair);
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
                    'Charlie',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('\$8.99'),
                  Text('I\'m cute'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
              color: alreadySaved ? Colors.red : Colors.grey,
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
=======
>>>>>>> main
