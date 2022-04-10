import 'package:flutter/material.dart';
import 'package:mariana_marketplace/login_screen.dart';
<<<<<<< HEAD
import 'package:mariana_marketplace/car_screen.dart';
import 'package:mariana_marketplace/classifieds_screen.dart';
=======
import 'package:mariana_marketplace/login_screen.dart';
>>>>>>> main

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
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
        color: Color.fromARGB(255, 255, 255, 255),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CarScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.black,
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
                          // shadowColor: Colors.grey,
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Text(
                              'Cars $_counter',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ClassifiedScreen()),
                        );
                      },
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
                          // shadowColor: null,
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Text(
                              'Classified $_counter',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
