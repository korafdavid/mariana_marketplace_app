import 'package:appwrite/appwrite.dart';
import 'secrets.dart';

class AppwriteClient {
  Client get _client {
    Client client = Client();

    client
        .setEndpoint(appwriteEndpoint)
        .setProject(appwriteProjectID)
        .setSelfSigned();

    return client;
  }

  static Client get client => _instance._client;
  static Account get account => Account(_instance._client);
  static Database get database => Database(_instance._client);
  static Storage get storage => Storage(_instance._client);

  static final AppwriteClient _instance = AppwriteClient._internal();
  AppwriteClient._internal();
  factory AppwriteClient() => _instance;
}
