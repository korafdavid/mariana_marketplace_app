import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/controller/api_calls.dart';
import 'package:mariana_marketplace/secrets.dart';
import 'package:mariana_marketplace/views/landing_screen.dart';

enum AuthStatus { authenicated, authenicating, unauthenicated }

class AuthState extends ChangeNotifier {
  Client client = Client();
  late Account account;
  late Database database;
  late User? user;
  var loginDetail = 'Login';
  var signUpDetail = 'Sign Up';
  var logOutDetail = 'LogOut';
  var authStatus = AuthStatus.unauthenicated;

  AuthState() {
    _init();
  }

  void toggleLogOutDetails(String logoutDetails) {
    logOutDetail = logoutDetails;
  }

  void toggleAuthStatus(AuthStatus status) {
    authStatus = status;
    notifyListeners();
  }

  void toggleLoginStatus(String loginDetails) {
    loginDetail = loginDetails;
    notifyListeners();
  }

  void toggleSignUpStatus(String signUpDetails) {
    signUpDetail = signUpDetails;
    notifyListeners();
  }

  _init() {
    account = Account(client);
    database = Database(client);
    client.setEndpoint(appwriteEndpoint).setProject(appwriteProjectID);
    //_checkIsLoggedIn();
  }

  Future<Session?> getCurrentSession() async {
    try {
      Session result = await account.getSession(
        sessionId: 'current',
      );
      return result;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future deleteCurrentSession(BuildContext context) async {
    toggleLogOutDetails('Logging Out');
    var result = await account.deleteSession(sessionId: 'current');
    toggleAuthStatus(AuthStatus.unauthenicated);
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out.')),
      );
      Navigator.pop(context);
      toggleLogOutDetails('Log Out');
    });
    return result;
  }

  Future<User?>? getLoggedIn() async {
    try {
      User result = await account.get();
      return result;
    } catch (e) {
      debugPrint(
          "Error attempting to see if user is logged in: " + e.toString());
    }
  }

  Future<User?>? getLoggedInStatus() async {
    toggleAuthStatus(AuthStatus.authenicating);
    try {
      User result = await account.get();
      debugPrint("User logged in: " + result.name);
      toggleAuthStatus(AuthStatus.authenicated);
      user = result;
      return result;
    } catch (e) {
      debugPrint(
          "Error attempting to see if user is logged in: " + e.toString());
      toggleAuthStatus(AuthStatus.unauthenicated);
    }
  }

  Future<bool> isFavorite(String classifiedID) async {
    DocumentList favoritesList = await getAllCollectionDocuments(
        userFavoritesCollectionID, [Query.equal("user_id", user?.$id)]);

    if (favoritesList != null) {
      for (var v in favoritesList.documents) {
        if (v.data["classified_id"] == classifiedID) {
          debugPrint(
              "Checking " + v.data["classified_id"] + " == " + classifiedID);
          return true;
        }
      }
    } else {
      debugPrint("favoritesList was null");
    }

    return false;
  }

  Future<Document?> createUserFavorite(
      String classifiedID, String classifiedType) async {
    try {
      getCurrentSession();
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

  Future<Document?> getDocument(String collectionID, String documentID) {
    Future<Document?> result = database.getDocument(
      collectionId: collectionID,
      documentId: documentID,
    );

    return result;
  }

  createAccount(String email, String password) async {
    try {
      var result = await account.create(
          email: email, password: password, userId: 'unique()');
      print(result);
    } on AppwriteException catch (error) {
      print(error.message);
    }
  }

  login(BuildContext context, String email, String password) async {
    try {
      toggleLoginStatus('Logging In, Please Wait');
      var result =
          await account.createSession(email: email, password: password);
      debugPrint(result.toString());
      toggleLoginStatus('successful login');
      await Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LandingScreen()));
      });
      toggleLoginStatus('Login');
      toggleAuthStatus(AuthStatus.authenicated);
    } on AppwriteException catch (error) {
      toggleLoginStatus('Login');
      toggleAuthStatus(AuthStatus.unauthenicated);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message!),
      ));
    }
  }

// Stuff from sign in screen
  signupUser(
      BuildContext context,
      String firstname,
      String lastname,
      String email,
      String password,
      String phone,
      String birthday,
      String address,
      String island) async {
    //Concat fullname
    final String fullName = ((firstname) + " " + (lastname));
    toggleSignUpStatus('Signing Up, Please Wait');
    debugPrint(
        "Attempting signupUser with values: firstname: $firstname, birthday: $birthday");

    try {
      debugPrint("0 startingSignup");
      //Sign up user
      User signedUpUser = await registerUserAccount(fullName, email, password);
      debugPrint("1 signedUpUser");
      //Create session
      Session createdSession = await loginUserAccount(email, password);
      debugPrint("2 createdSession");
      //Update user account name
      User updatedAccountNameAccount = await updateAccountName(fullName);
      debugPrint("3 updatedAccountNameAccount");
      //Create database entry for user
      Document userInfoDocument = await createUserInfoEntry(signedUpUser.$id,
          firstname, lastname, email, phone, birthday, address, island);
      debugPrint("4 userInfoDocument");
      //Update user prefs
      User updatedUser = await updateUserPrefs(
          firstname, lastname, email, phone, birthday, address, island);
      debugPrint("5 updatedUserPrefs");

      //Everything successfully completed above, return null so caller knows we succeeded
      toggleSignUpStatus('Successfully Signed Up please wait');
      await Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LandingScreen()));
      });
      toggleSignUpStatus('SignUp');
      toggleAuthStatus(AuthStatus.authenicated);
    } on AppwriteException catch (e) {
      toggleSignUpStatus('SignUp');
      toggleAuthStatus(AuthStatus.unauthenicated);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Could not complete user signup: ${e.message}")));
    }
  }
}
