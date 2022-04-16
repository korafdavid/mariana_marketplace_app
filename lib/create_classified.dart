import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/api_calls.dart';

class CreateClassifiedScreen extends StatefulWidget {
  CreateClassifiedScreen({Key? key}) : super(key: key);

  @override
  State<CreateClassifiedScreen> createState() => _CreateClassifiedScreenState();
}

class _CreateClassifiedScreenState extends State<CreateClassifiedScreen> {
  final _formKey = GlobalKey<FormState>();
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
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];

  void selectImages() async {
    List<XFile>? selectedImages = await _picker.pickMultiImage();

    debugPrint('Got here');

    if (selectedImages!.isNotEmpty) {
      _imageFileList!.addAll(selectedImages);
    }
    debugPrint("Image list length: " + _imageFileList!.length.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
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
                ],
              ),
            ),
            Flexible(
              child: GridView.builder(
                  itemCount: _imageFileList!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      File(_imageFileList![index].path),
                      fit: BoxFit.cover,
                    );
                  }),
            ),
            ElevatedButton(
              onPressed: selectImages,
              child: const Text('Pick Images'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate() &&
                    _imageFileList!.length > 1) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.

                  uploadImages(_imageFileList!);

                  // More at https://docs.flutter.dev/cookbook/forms/validation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Form data invalid or missing image.')),
                  );
                }
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
