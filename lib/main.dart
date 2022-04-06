import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Mariana Marketplace'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

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
        title: Text(widget.title),
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
                      onPressed: _resetCounter,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            // Expanded(
            //   child: Card(
            //     color: Colors.blueGrey,
            //     child: IconButton(
            //       icon: const Icon(
            //         Icons.account_circle_sharp,
            //       ),
            //       onPressed: _resetCounter,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
                            fit: BoxFit.cover),
                      ),
                      child: Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        shadowColor: Colors.grey,
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Text(
                            'Cars $_counter',
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
                            fit: BoxFit.cover),
                      ),
                      child: Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        shadowColor: Colors.grey,
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Text(
                            'Classified $_counter',
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Card(
            //     color: Colors.blueGrey,
            //     child: IconButton(
            //       icon: const Icon(
            //         Icons.account_circle_sharp,
            //       ),
            //       onPressed: _resetCounter,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            // Row(
            //   children: [
            //     const Text(
            //       'column 2',
            //     ),
            //     Text(
            //       '$_counter',
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
