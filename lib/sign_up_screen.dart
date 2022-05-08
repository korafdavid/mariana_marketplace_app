import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:mariana_marketplace/landing_screen.dart';
import 'package:intl/intl.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  //Form Vars
  final _formKey = GlobalKey<FormState>();

  //DateTime Stuff
  DateTime selectDate = DateTime.now();
  DateFormat dayMonthYear = DateFormat('dd/MM/yyyy');
  final _dateTextFieldController = TextEditingController();

  String firstname = "";
  String lastname = "";
  String email = "";
  String password = "";
  String phone = "";
  String birthday = "";
  String address = "";
  String islandSelectedValue = "Saipan";
  List<String> categorySelectionList = ['Saipan', 'Tinian', 'Rota'];

  Future? signingUpUser;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectDate) {
      setState(() {
        selectDate = picked;
      });
      _dateTextFieldController.text =
          dayMonthYear.format(selectDate).toString();
      _dateTextFieldController.value = TextEditingValue(
        text: (dayMonthYear.format(selectDate).toString()),
      );
    }
  }

  //Widget for submit button + loading indicator
  Widget? signUpButton(Future? signingUp) {
    if (signingUp != null) {
      return FutureBuilder(
        future: signingUp,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            int seconds = 2;
            Future.delayed(
              Duration(seconds: seconds),
              (() async {
                debugPrint(
                    "Signed up, moving to landing after $seconds seconds.");
                //Navigator.of(context).pushReplacement(
                //  MaterialPageRoute(
                //    builder: (context) => const LandingScreen(),
                //  ),
                //);
              }),
            );
            return Text("Finished");
          } else {
            return Text("Signing up, please wait.");
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
        title: Text("Sign Up"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration:
                          const InputDecoration(labelText: "First Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          debugPrint("Setting First Name = " + value!);
                          firstname = value;
                        });
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(labelText: "Last Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          debugPrint("Setting Last Name = " + value!);
                          lastname = value;
                        });
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          debugPrint("Setting Last Name = " + value!);
                          email = value;
                        });
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(labelText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          //debugPrint("Setting password = " + value!);
                          password = value!;
                        });
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(
                          labelText: "Primary Phone Number"),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          //debugPrint("Setting password = " + value!);
                          phone = value!;
                        });
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(labelText: "Birthday"),
                      controller: _dateTextFieldController,
                      onTap: () {
                        //Stops keyboard from appearing
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _selectDate(context);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your birthday';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        //
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: islandSelectedValue,
                      decoration: const InputDecoration(
                          labelText: "Island of Residence"),
                      hint: const Text(
                        'choose one',
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          islandSelectedValue = value!;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          islandSelectedValue = value!;
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
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    _formKey.currentState?.save();

                    setState(() {
                      signingUpUser = signupUser(
                          firstname,
                          lastname,
                          email,
                          password,
                          phone,
                          birthday,
                          address,
                          islandSelectedValue);
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
                child: signUpButton(signingUpUser),
              )
            ],
          ),
        ),
      ),
    );
  }
}
