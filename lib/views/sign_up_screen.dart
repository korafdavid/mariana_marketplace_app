import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/controller/api_calls.dart';
import 'package:mariana_marketplace/controller/AuthState.dart';
import 'package:mariana_marketplace/views/landing_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  String birthday = '';
  final address = TextEditingController();
  String islandSelectedValue = "Saipan";
  List<String> categorySelectionList = ['Saipan', 'Tinian', 'Rota'];
   bool hideText = true;
  Future? signingUpUser;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectDate) {
      setState(() {
        selectDate = picked;
        birthday = dayMonthYear.format(selectDate).toString();
      });
      _dateTextFieldController.text =
          dayMonthYear.format(selectDate).toString();
      _dateTextFieldController.value = TextEditingValue(
        text: (dayMonthYear.format(selectDate).toString()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
      AuthState state = Provider.of<AuthState>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: firstname,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Row(
                        children: const [
                          Text("First Name"),
                          Text(" *", style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                
                  ),
                  TextFormField(
                    controller: lastname,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Row(
                        children: const [
                          Text("Last Name"),
                          Text(" *", style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: email,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: Row(
                        children: const [
                          Text("Email"),
                          Text(" *", style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                   
                  ),
                  TextFormField(
                    controller: password,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                       suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hideText = !hideText;
                                    });
                                  },
                                  icon: Icon(
                                      hideText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      )),
                      label: Row(
                        children: const [
                          Text("Password"),
                          Text(" *", style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: hideText,
                  ),
                  TextFormField(
                    controller: phone,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      label: Row(
                        children: const [
                          Text("Phone Number"),
                          Text(" *", style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                   
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(
                      label: Row(
                        children: const [
                          Text("Birthday"),
                          Text(" *", style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
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
                    decoration: InputDecoration(
                      label: Row(
                        children: const [
                          Text("Island"),
                          Text(" *", style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ),
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save(); 
                    state.signupUser(
                       context,
                        firstname.text,
                        lastname.text,
                        email.text,
                        password.text,
                        phone.text,
                        birthday,
                        address.text,
                        islandSelectedValue);
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
              child: Text(context.watch<AuthState>().signUpDetail)
            )
          ],
        ),
      ),
    );
  }
}
