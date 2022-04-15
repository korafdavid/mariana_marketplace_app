import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mariana_marketplace/secrets.dart';
import 'package:flutter/material.dart';

Client client = Client();
Account account = Account(client);
Storage storage = Storage(client);

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

Future<List<File>> uploadImages(List<XFile> imageFiles) async {
  List<File> returnFileList = [];

  client
          .setEndpoint(appwriteEndpoint) // Your API Endpoint
          .setProject(appwriteProjectID) // Your project ID
      ;

  imageFiles.forEach((element) async {
    try {
      File result = await storage.createFile(
        bucketId: classifiedsImagesBucketID,
        fileId: 'unique()',
        file: InputFile(
            path: element.path,
            filename: 'classified_image_' + element.name.toString()),
      );
      returnFileList.add(result);
    } catch (e) {
      debugPrint("Error uploading image " + e.toString());
    }
  });

  return returnFileList;
}
