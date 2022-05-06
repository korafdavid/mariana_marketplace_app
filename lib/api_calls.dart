import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mariana_marketplace/secrets.dart';
import 'package:flutter/material.dart';

Client client = Client();
Account account = Account(client);
Storage storage = Storage(client);
Database database = Database(client);

// Get future bool with login status
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

// Get currently logged in user
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

// Stuff from sign in screen
Future<String?> signupUser(
    String firstname,
    String lastname,
    String email,
    String password,
    String phone,
    String birthday,
    String address,
    String island) async {
  //Concat fullname
  final String fullName = ((firstname ?? "") + " " + (lastname ?? ""));

  try {
    //Sign up user
    User signedUpUser = await registerUserAccount(fullName, email, password);
    //Create session
    Session createdSession = await startUserSession(email, password);
    //Update user account name
    User updatedAccountNameAccount = await updateAccountName(fullName);
    //Create database entry for user
    Document userInfoDocument = await createUserInfoEntry(
        signedUpUser.$id,
        firstname ?? "Missing",
        lastname ?? "Missing",
        email,
        phone ?? "Missing",
        birthday ?? "Missing",
        address ?? "Missing",
        island ?? "Missing");
    //Update user prefs
    User updatedUser = await updateUserPrefs(
        firstname ?? "Missing",
        lastname ?? "Missing",
        email,
        phone ?? "Missing",
        birthday ?? "Missing",
        address ?? "Missing",
        island ?? "Missing");

    //Everything successfully completed above, return null so caller knows we succeeded
    return null;
  } catch (e) {
    final String errorString =
        "Did not complete user signup fully, error: " + e.toString();
    debugPrint(errorString);
    return "Could not complete user signup";
  }
}

Future<User> registerUserAccount(
    String fullname, String email, String password) {
  Future<User> result = account.create(
    userId: 'unique()',
    name: fullname,
    email: email,
    password: password,
  );

  return result;

  //result.then((response) {
  //  print("Response for registerUserAccount was: " + response.toString());
  //  return response;
  //}).catchError((error) {
  //  print(error.response);
  //  return error.response;
  //});
}

Future<Session> startUserSession(String anEmail, String anPassword) async {
  Future<Session> result = account.createSession(
    email: anEmail,
    password: anPassword,
  );

  return result;
  //result
  //  .then((response) {
  //    print(response);
  //  }).catchError((error) {
  //    print(error.response);
  //});
}

Future<Document> createUserInfoEntry(
    String anAccountID,
    String anFirstName,
    String anLastName,
    String anEmail,
    String anPhone,
    String anBirthday,
    String anAddress,
    String anIsland) {
  //
  Future<Document> result = database.createDocument(
      collectionId: accountDetailsCollectionID,
      documentId: 'unique()',
      data: {
        "account_id": anAccountID,
        "name": anFirstName + " " + anLastName,
        "firstname": anFirstName,
        "lastname": anLastName,
        "email": anEmail,
        "phone": anPhone,
        "birthday": anBirthday,
        "address": anAddress,
        "island": anIsland
      });

  return result;

  //result.then((response) {
  //  print(response);
  //  return response;
  //}).catchError((error) {
  //  print(error.response);
  //  return error.response;
  //});
}

Future<User> updateAccountName(String anName) {
  Future<User> result = account.updateName(
    name: anName,
  );

  return result;
}

Future<User> updateUserPrefs(
    String anFirstName,
    String anLastName,
    String email,
    String anPhone,
    String anBirthday,
    String anAddress,
    String anIsland) {
  //
  Future<User> result = account.updatePrefs(
    prefs: {
      "firstname": anFirstName,
      "lastname": anLastName,
      "email": email,
      "phone": anPhone,
      "birthday": anBirthday,
      "address": anAddress,
      "island": anIsland
    },
  );

  return result;

  //result
  //  .then((response) {
  //    print(response);
  //  }).catchError((error) {
  //    print(error.response);
  //});
}
//

// delete all account sessions
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

// upload a single image
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

// upload a list of Images getting a Future List of File objects back
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
      "images": classifiedImagesList,
      "condition": condition
    },
  );

  return result;
}

Future<DocumentList?> getAccountFavorites() async {
  try {
    User? myUser = await getLoggedInUser();
    Future<DocumentList> returnList = getAllCollectionDocuments(
        userFavoritesCollectionID, [Query.equal("user_id", myUser?.$id)]);
    return returnList;
  } catch (e) {
    debugPrint("Error during getAccountFavorites: $e");
    return null;
  }
}

//Get all the documents as Documentlist in a collection
Future<DocumentList> getAllCollectionDocuments(String collectionID,
    [List<dynamic> queryList = const []]) async {
  debugPrint("Got here getAllCollectionDocuments trying collection id: " +
      collectionID);
  Future<DocumentList> result = database.listDocuments(
    collectionId: collectionID,
    queries: queryList,
  );

  return result;
}

//Delete all the documents in a collection
void deleteAllDocumentsInCollection(String CollectionID) async {
  DocumentList allCollectionDocList =
      await getAllCollectionDocuments(CollectionID);

  allCollectionDocList.documents.forEach(
    (element) {
      debugPrint("Deleting element: " +
          element.$id +
          " from collection: " +
          CollectionID);
      Future result = database.deleteDocument(
        collectionId: CollectionID,
        documentId: element.$id,
      );
    },
  );
}

//Get FileList of all files in a bucket
Future<FileList> getBucketFileList(String bucketID) {
  Future<FileList> result = storage.listFiles(
    bucketId: bucketID,
  );

  return result;
}

//Delete all files in a bucket
void deleteAllFilesInBucket(String bucketID) async {
  FileList allFilesInBucketList = await getBucketFileList(bucketID);

  allFilesInBucketList.files.forEach(
    (element) {
      debugPrint(
          "Deleting element: " + element.$id + " from bucket: " + bucketID);
      Future result = storage.deleteFile(
        bucketId: bucketID,
        fileId: element.$id,
      );
    },
  );
}

Future<Uint8List?> getFilePreview(
    String bucketID, String fileID, int width, int height) async {
  Future<Uint8List?> returnValue = storage.getFilePreview(
    bucketId: "6259fa52f2266bd32b41",
    fileId: fileID,
    width: width,
    height: height,
  );

  //debugPrint("Attempting to get bucket: $bucketID fileID $fileID");
  //debugPrint(returnValue.toString());

  return returnValue;
}

Future<Document?> createUserFavorite(
    String classifiedID, String classifiedType) async {
  client
          .setEndpoint(appwriteEndpoint) // Your API Endpoint
          .setProject(appwriteProjectID) // Your project ID
      ;

  try {
    //Wait for logged in user
    User? awaitedUser = await getLoggedInUser();
    String? userID = awaitedUser?.$id;

    Future<Document> result = database.createDocument(
      collectionId: userFavoritesCollectionID,
      documentId: 'unique()',
      data: {
        "user_id": userID,
        "classified_id": classifiedID,
        "classified_type": classifiedType,
      },
    );

    return result;
  } catch (e) {
    debugPrint("Couldn't create user favorite, error: $e");
    return null;
  }
}

void deleteUserFavorite(String classifiedID) async {
  User? myUser;

  try {
    myUser = await getLoggedInUser();
  } catch (e) {
    debugPrint("Error during deleteUserFavorite: $e");
  }

  //Find the classified we want to delete
  DocumentList queryDocuments =
      await getAllCollectionDocuments(userFavoritesCollectionID, [
    Query.equal("classified_id", classifiedID),
  ]);

  debugPrint("Matching documents length when running deleteUserFavorite: " +
      queryDocuments.documents.length.toString());

  for (var value in queryDocuments.documents) {
    debugPrint("Attempting to delete favorite ID: " + value.data["\$id"]);
    Future result = database.deleteDocument(
      collectionId: userFavoritesCollectionID,
      documentId: value.data["\$id"],
    );
  }
}
