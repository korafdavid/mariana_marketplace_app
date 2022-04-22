import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:mariana_marketplace/classifieds_screen.dart';
import 'package:mariana_marketplace/landing_screen.dart';

class ClassifiedFilterScreen extends StatefulWidget {
  ClassifiedFilterScreen({Key? key}) : super(key: key);

  @override
  State<ClassifiedFilterScreen> createState() => _ClassifiedFilterScreenState();
}

class _ClassifiedFilterScreenState extends State<ClassifiedFilterScreen> {
  //Form Vars
  final _formKey = GlobalKey<FormState>();
  String titleContainsQuery = '';
  String priceMinQuery = '';
  String priceMaxQuery = '';
  String descriptionContainsQuery = '';
  String categoryQuery = '';
  List<String> categoryQueryList = [
    '',
    'Announcements',
    'Appliances',
    'Auto Parts',
    'Baby',
    'Books and Media',
    'Clothing and Apperal',
    'Computers',
    'Cycling',
    'Electronics',
    'Fitness Equipment',
    'For Trade or Barter',
    'Free',
    'Furniture',
    'General',
    'Home',
    'Garden',
    'Hunting',
    'Fishing',
    'Industrial',
    'Livestock',
    'Musical Instruments',
    'Other Real Estate',
    'Outdoors',
    'Pets',
    'Services',
    'Tickets',
    'Toys',
    'Water Sports',
    'Weddings',
    'Uncategorized'
  ];
  String conditionQuery = '';
  List<String> conditionQueryList = [
    '',
    'New',
    'Used - Excellent',
    'Used - Good',
    'Used - Fair',
    'Used - Poor',
    'Used - Damaged'
  ];

  List<String> queries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create Classified"),
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration:
                        const InputDecoration(labelText: "Title Contains:"),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        debugPrint("Setting title = " + value!);
                        if (value.isNotEmpty) {
                          queries.add(Query.search('title', value));
                        } else {
                          titleContainsQuery = "";
                        }
                      });
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          decoration: const InputDecoration(
                              hintText: "1",
                              labelText: "Min",
                              icon: Icon(Icons.attach_money)),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              priceMinQuery = value!;
                              if (value.isNotEmpty) {
                                queries.add(Query.greater('price', value));
                              } else {
                                priceMinQuery = '';
                              }
                              debugPrint(priceMinQuery);
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          // The validator receives the text that the user has entered.
                          decoration: const InputDecoration(
                              hintText: "1",
                              labelText: "Max",
                              icon: Icon(Icons.minimize_outlined)),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              priceMaxQuery = value!;
                              if (value.isNotEmpty) {
                                queries.add(Query.lesser('price', value));
                              } else {
                                priceMaxQuery = '';
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    value: categoryQuery,
                    decoration: const InputDecoration(labelText: "Category"),
                    hint: const Text(
                      'choose one',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        categoryQuery = value!;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        categoryQuery = value!;
                        if (value.isNotEmpty) {
                          queries.add(Query.equal('category', value));
                        } else {
                          categoryQuery = '';
                        }
                      });
                    },
                    validator: (value) {
                      return null;
                    },
                    items: categoryQueryList.map((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<String>(
                    value: conditionQuery,
                    decoration: const InputDecoration(labelText: "Condition"),
                    hint: const Text(
                      'choose one',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        conditionQuery = value!;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        conditionQuery = value!;
                        if (value.isNotEmpty) {
                          queries.add(Query.equal('condition', value));
                        } else {
                          categoryQuery = '';
                        }
                      });
                    },
                    validator: (value) {
                      return null;
                    },
                    items: conditionQueryList.map((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: const InputDecoration(
                        labelText: "Description Contains:"),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        descriptionContainsQuery = value!;
                        if (value.isNotEmpty) {
                          queries.add(Query.search('description', value));
                        } else {
                          descriptionContainsQuery = '';
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.

                  _formKey.currentState?.save();

                  debugPrint("Queries = " + queries.toString());

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassifiedsScreen(
                              queries: queries,
                            )),
                  );

                  //If you want immidiate screen switch after clicking submit:
                  //Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //  builder: (context) => const LandingScreen(),
                  //));

                  // More at https://docs.flutter.dev/cookbook/forms/validation
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form data invalid.')),
                  );
                }
              },
              child: const Text("Search"),
            )
          ],
        ),
      ),
    );
  }
}
