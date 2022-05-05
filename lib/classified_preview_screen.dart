import 'dart:ffi';

import 'package:flutter/material.dart';

class ClassifiedDisplayScreen extends StatefulWidget {
  const ClassifiedDisplayScreen({Key? key}) : super(key: key);

  @override
  State<ClassifiedDisplayScreen> createState() =>
      _ClassifiedDisplayScreenState();
}

class _ClassifiedDisplayScreenState extends State<ClassifiedDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mariana Marketplace"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
