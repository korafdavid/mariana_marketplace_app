import 'package:flutter/material.dart';
import 'package:mariana_marketplace/views/car_screen.dart';

class HomeWidet extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onpressed;
  const HomeWidet({
    Key? key,
    required this.title,
    required this.icon, 
    required this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onpressed,
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  // shadowColor: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                       icon
                          ]),
                      const Spacer(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Text(
                                title,
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
