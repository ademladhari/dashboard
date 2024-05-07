import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dashboard/constants/constants.dart';
import 'package:dashboard/Controller/auth_api.dart';
import 'package:dashboard/models/book.dart';
import 'package:dashboard/models/category.dart';
import 'package:dashboard/screens/Manage_categories.dart';
import 'package:flutter/material.dart';

class DatabaseAPI {
  Client client = Client();
  late final Databases databases;
  late final AuthAPI auth; // Declare `auth` here without initializing

  DatabaseAPI() {
    init(); // Call `init` method from constructor
  }

  void init() {
    databases = Databases(client);
    auth = AuthAPI(client); // Initialize `auth` after `client` is configured
  }

  Future<DocumentList> getMessages() {
    return databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: COLLECTION_BOOK,
    );
  }

  Future<List<Book>> getAllBooks() async {
    try {
      DocumentList response = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_BOOK,
      );

      // Check if response.documents is not null and is a list of documents
      if (response.documents != null && response.documents.isNotEmpty) {
        List<Document> documents = response.documents;

        // Convert each document to a Book object using the Book.fromJson method
        List<Book> books =
            documents.map((doc) => Book.fromJson(doc.data)).toList();

        // Optionally, print each book's details for debugging
        books.forEach((book) {
          print('Book ID: ${book.id}, Book Name: ${book.name}');
        });

        return books;
      } else {
        print('Error: Document list is empty or null');
        return [];
      }
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      // Fetch all categories from the specified collection
      DocumentList response = await databases.listDocuments(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId:
            COLLECTION_CATEGORIES, // Replace with your actual category collection ID
      );

      // Map each document to a Category object
      List<Category> categories =
          response.documents.map((doc) => Category.fromJson(doc.data)).toList();
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future createCategorie(Map<String, dynamic> data) async {
    try {
      final newPost = await databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_CATEGORIES,
        documentId: ID.unique(),
        data: data,
      );
      print("create");
      return newPost;
    } catch (error) {
      print(error);

      // or handle error accordingly
    }
  }

  Future<int> countBooksInCategory(String categoryId) async {
    try {
      // Create a list of queries with the proper filtering condition

      // Use the queries list in the listDocuments call
      DocumentList response = await databases.listDocuments(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: COLLECTION_BOOK,
          queries: [Query.equal('categorie', categoryId)]);
      print(response.total);
      return response.total; // The total number of books in the category
    } catch (e) {
      print('Error fetching books count: $e');
      return 0;
    }
  }

  Future<Document> addMessage({required String message}) {
    return databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        documentId: ID.unique(),
        data: {
          'text': message,
          'date': DateTime.now().toString(),
          'user_id': auth.userid
        });
  }

  Future<dynamic> deleteMessage({required String id}) {
    return databases.deleteDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: COLLECTION_MESSAGES,
        documentId: id);
  }
}
