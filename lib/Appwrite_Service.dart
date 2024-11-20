import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  late Client client;
  late Databases databases;

  static const endpoint = "https://cloud.appwrite.io/v1";
  static const projectId = "673d7d68001b6d1507e1";
  static const databaseId = "673d7da6002934253f02";
  static const collectionId = "673d7db00013f994bc13";

  AppwriteService() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }

  Future<List<Document>> getTasks() async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );
      return result.documents;
    } catch (e) {
      print("error loading tasks:$e");
      rethrow;
    }
  }

  Future<Document> addEmployee(String name, String age, String location) async {
    try {
      final documentId = ID.unique();
      final result = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        data: {
          'name': name,
          'age': age,
          'location': location,
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating task:$e');
      rethrow;
    }
  }

  Future<void> deleteemployee(String documentId) async {
    try {
      await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId);
    } catch (e) {
      print("error deleting task:$e");
      rethrow;
    }
  }
}
