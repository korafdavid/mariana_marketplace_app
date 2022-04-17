import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mariana_marketplace/secrets.dart';
import 'package:flutter/material.dart';

Client client = Client();
Account account = Account(client);
Storage storage = Storage(client);
Database database = Database(client);

Future<bool> getLoggedIn() async {
  client
          .setEndpoint(appwriteEndpoint) // Your API Endpoint
          .setProject(appwriteProjectID) // Your project ID
      ;

  try {
    User result = await account.get();
    debugPrint("User logged in: " + result.name);
    return true;
  } catch (e) {
    debugPrint("Error attempting to see if user is logged in: " + e.toString());
    return false;
  }
}

Future<User?> getLoggedInUser() async {
  client
          .setEndpoint(appwriteEndpoint) // Your API Endpoint
          .setProject(appwriteProjectID) // Your project ID
      ;

  try {
    User result = await account.get();
    debugPrint("User logged in: " + result.name);
    return result;
  } catch (e) {
    debugPrint("Error attempting to see if user is logged in: " + e.toString());
  }
}

void deleteAllAccountSessions() {
  // Init SDK
  client
          .setEndpoint(appwriteEndpoint) // Your API Endpoint
          .setProject(appwriteProjectID) // Your project ID
      ;
  Future result = account.deleteSessions();

  result.then((response) {
    print(response);
  }).catchError((error) {
    print(error.response);
  });
}

Future<File> uploadSingleImage(XFile image) async {
  Future<File> result = storage.createFile(
    bucketId: classifiedsImagesBucketID,
    fileId: 'unique()',
    file: InputFile(
        path: image.path,
        filename: 'classified_image_' + image.name.toString()),
  );
  return result;
}

Future<List<File>> uploadImages(List<XFile> imageFiles) async {
  List<File> returnFileList = [];
  List<String> returnFileStringList = [];

  client
          .setEndpoint(appwriteEndpoint) // Your API Endpoint
          .setProject(appwriteProjectID) // Your project ID
      ;

  await Future.wait(imageFiles.map((item) async {
    File finalItem = await uploadSingleImage(item);
    returnFileList.add(finalItem);
  }).toList());

  returnFileList.forEach((element) {
    returnFileStringList.add(element.name);
  });

  //Old way below, completes empty due to it returning before futures complete:
  //imageFiles.forEach((element) async {
  //  try {
  //    File result = await storage.createFile(
  //      bucketId: classifiedsImagesBucketID,
  //      fileId: 'unique()',
  //      file: InputFile(
  //          path: element.path,
  //          filename: 'classified_image_' + element.name.toString()),
  //    );
  //    returnFileList.add(result);
  //  } catch (e) {
  //    debugPrint("Error uploading image " + e.toString());
  //  }
  //});

  print("Returning file list: " + returnFileList.toString());

  return returnFileList;
}

Future<Document> createClassified(String name, String price, String description,
    String condition, String category, List<XFile> imageFiles) async {
  List<File> uploadedImages = await uploadImages(imageFiles);
  List<String> classifiedImagesList = [];

  //Upload image files first to get a list files uploaded for classified entry

  //uploadedImages = await uploadImages(imageFiles);
  uploadedImages.forEach(((element) {
    classifiedImagesList.add(element.$id);
  }));

  debugPrint(
      "Full classifiedImagesList String: " + classifiedImagesList.toString());

  Client client = Client();

  client
          .setEndpoint(appwriteEndpoint) // Your API Endpoint
          .setProject(appwriteProjectID) // Your project ID
      ;

  User? currentUser = await getLoggedInUser();

  debugPrint("account_id: " +
      currentUser!.$id +
      "\n" +
      "name: " +
      name +
      "\n"
          "price: " +
      price +
      "\n" +
      "date_posted: " +
      DateTime.now().toUtc().toString() +
      "\n"
          "description: " +
      description +
      "\n"
          "condition: " +
      condition +
      "\n"
          "category: " +
      category +
      "\n"
          "images: " +
      classifiedImagesList.toString());

  Future<Document> result = database.createDocument(
    collectionId: classifiedsCollectionId,
    documentId: 'unique()',
    data: {
      "account_id": currentUser.$id,
      "name": name,
      "price": price,
      "date_posted": DateTime.now().toUtc().toString(),
      "description": description,
      "category": category,
      "images": classifiedImagesList
    },
  );

  return result;
}
