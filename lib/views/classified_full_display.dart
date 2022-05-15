import 'package:carousel_slider/carousel_slider.dart';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/secrets.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:mariana_marketplace/controller/api_calls.dart';

class ClassifiedDisplayScreen extends StatefulWidget {
  const ClassifiedDisplayScreen({Key? key, required this.classifiedID})
      : super(key: key);
  final String classifiedID;

  @override
  State<ClassifiedDisplayScreen> createState() =>
      _ClassifiedDisplayScreenState();
}

class _ClassifiedDisplayScreenState extends State<ClassifiedDisplayScreen> {
  Future<Document?> classifiedDocument = Future.value(null);

  @override
  void initState() {
    classifiedDocument =
        getDocument(classifiedsCollectionId, widget.classifiedID);
    super.initState();
  }

  Widget Title() {
    return FutureBuilder(
      future: classifiedDocument,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Text(snapshot.data.data["name"]);
        } else {
          return Text("...");
        }
      },
    );
  }

  Widget classifiedSliderImage(
      String bucketID, String fileID, int width, int height) {
    return FutureBuilder(
      future: getFilePreview(bucketID, fileID, width,
          height), //works for both public file and private file, for private files you need to be logged in
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data as Uint8List,
          );
        } else {
          return Center(
            child: Container(
                width: 16, height: 16, child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget ImageCarouselSlider() {
    return FutureBuilder(
      future: classifiedDocument,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<dynamic> imageIDs = snapshot.data.data["images"];
          List<Widget> classifiedSliderImages = [];
          imageIDs.forEach(
            (element) {
              classifiedSliderImages.add(classifiedSliderImage(
                  classifiedsImagesBucketID, element, 300, 250));
            },
          );
          return CarouselSlider(
            options: CarouselOptions(height: 250.0),
            items: classifiedSliderImages.map((sliderImage) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      //decoration: BoxDecoration(color: Colors.amber),
                      child: sliderImage);
                },
              );
            }).toList(),
          );
        } else {
          return CarouselSlider(
            options: CarouselOptions(height: 250.0),
            items: ["", "", ""].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(color: Colors.grey),
                      child: Text(
                        i,
                        style: TextStyle(fontSize: 16.0),
                      ));
                },
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget Body() {
    return FutureBuilder(
      future: classifiedDocument,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          DateTime dtFromDatabase =
              DateTime.parse(snapshot.data.data["date_posted"]);
          String numDaysAgoPosted =
              DateTime.now().difference(dtFromDatabase).inDays.toString();

          return Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "" + snapshot.data.data["name"],
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Price: \$" + snapshot.data.data["price"].toString(),
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    Text((numDaysAgoPosted != "0")
                        ? "Posted: " + numDaysAgoPosted + " days ago"
                        : "Posted: today."),
                    Divider(),
                    Text("Contact: "),
                    Divider(),
                    ContactInfo(),
                    Spacer(),
                    Text("Condition: " +
                        snapshot.data.data['condition'].toString()),
                    Text(
                      snapshot.data.data["description"],
                    ),
                    Spacer(),
                    Divider()
                  ]),
            ),
          );
        } else {
          return Text("...");
        }
      },
    );
  }

  Widget ContactInfo() {
    return FutureBuilder(
        future: getUserInfo(classifiedDocument),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint("Snapshot to string: " + snapshot.toString());
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(snapshot.data.data["firstname"]),
                Text(snapshot.data.data["phone"]),
                Text(snapshot.data.data["email"]),
                Text(snapshot.data.data["island"]),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("..."), Text("..."), Text("..."), Text("...")],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [ImageCarouselSlider(), Body()],
        ),
      ),
    );
  }
}
