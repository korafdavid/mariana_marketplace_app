import 'package:flutter/material.dart';
import 'package:mariana_marketplace/controller/AuthState.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Form Vars
  final _formKey = GlobalKey<FormState>();
  bool hideText = true;
  final emailController = TextEditingController();
  final passworrdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Sign Up"),
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
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passworrdController,
                      textInputAction: TextInputAction.done,
                      decoration:InputDecoration(
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
                          labelText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: hideText,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    state.login(context, emailController.text,
                        passworrdController.text);
                  }
                },
                child: Text(context.watch<AuthState>().loginDetail),
              )
            ],
          ),
        ),
      ),
    );
  }
}
