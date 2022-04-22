import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:mariana_marketplace/landing_screen.dart';

class CreateClassifiedScreen extends StatefulWidget {
  CreateClassifiedScreen({Key? key}) : super(key: key);

  @override
  State<CreateClassifiedScreen> createState() => _CreateClassifiedScreenState();
}

class _CreateClassifiedScreenState extends State<CreateClassifiedScreen> {
  //Form Vars
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String price = "";
  String description = "";
  String categorySelectedValue = "Announcements";
  List<String> categorySelectionList = [
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
  String conditionSelectedValue = "New";
  List<String> conditionsSelectionList = [
    'New',
    'Used - Excellent',
    'Used - Good',
    'Used - Fair',
    'Used - Poor',
    'Used - Damaged'
  ];

  Future? uploadingClassified;

  //Image Picker Vars
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];

  //Method for selecting images
  void selectImages() async {
    List<XFile>? selectedImages = await _picker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      _imageFileList!.addAll(selectedImages);
    }
    debugPrint("Image list length: " + _imageFileList!.length.toString());
    setState(() {});
  }

  //Widget for submit button + loading indicator
  Widget? submitButton(Future? uploadingClassified) {
    if (uploadingClassified != null) {
      return FutureBuilder(
        future: uploadingClassified,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            int seconds = 2;
            Future.delayed(
              Duration(seconds: seconds),
              (() async {
                debugPrint(
                    "Finished uploading classified, moving to landing after $seconds seconds.");
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LandingScreen(),
                  ),
                );
              }),
            );
            return Text("Finished");
          } else {
            return Text("Uploading Classified, Please Wait.");
          }
        },
      );
    }
    return Text("Submit");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create Classified"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(labelText: "Title"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          debugPrint("Setting title = " + value!);
                          title = value;
                        });
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(
                          hintText: "1",
                          labelText: "Price",
                          icon: Icon(Icons.attach_money)),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          price = value!;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: categorySelectedValue,
                      decoration: const InputDecoration(labelText: "Category"),
                      hint: const Text(
                        'choose one',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          categorySelectedValue = value!;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          categorySelectedValue = value!;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: categorySelectionList.map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                    DropdownButtonFormField<String>(
                      value: conditionSelectedValue,
                      decoration: const InputDecoration(labelText: "Condition"),
                      hint: const Text(
                        'choose one',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          conditionSelectedValue = value!;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          conditionSelectedValue = value!;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: conditionsSelectionList.map((String val) {
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
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          description = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 20, 8, 20),
                  child: GridView.builder(
                      itemCount: _imageFileList!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(
                          File(_imageFileList![index].path),
                          fit: BoxFit.cover,
                        );
                      }),
                ),
              ),
              ElevatedButton(
                onPressed: selectImages,
                child: const Text('Pick Images'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate() &&
                      _imageFileList!.isNotEmpty) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    _formKey.currentState?.save();

                    setState(() {
                      uploadingClassified = createClassified(
                          title,
                          price,
                          description,
                          conditionSelectedValue,
                          categorySelectedValue,
                          _imageFileList!);
                    });

                    //If you want immidiate screen switch after clicking submit:
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //  builder: (context) => const LandingScreen(),
                    //));

                    // More at https://docs.flutter.dev/cookbook/forms/validation
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Form data invalid or missing image.')),
                    );
                  }
                },
                child: submitButton(uploadingClassified),
              )
            ],
          ),
        ),
      ),
    );
  }
}
