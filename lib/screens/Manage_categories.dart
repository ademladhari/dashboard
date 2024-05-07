import 'package:dashboard/Controller/auth_api.dart';
import 'package:dashboard/Controller/datasetBase.dart';
import 'package:dashboard/models/book.dart';
import 'package:dashboard/models/category.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ManageCategories extends StatefulWidget {
  static const String id = "manage-category";

  @override
  _ManageCategoriesState createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _catName = TextEditingController();
  dynamic image;
  late String fileName;
  String? selectedCategoryId;
  bool _isNavbarOpen = false;
  List<Category> categories = [];
  List<Book> books = [];
  bool isLoading = false; // Correct initial state as false
  Map<String, String> bookscount = {};

  @override
  void initState() {
    super.initState();
    categories = [];
    books = [];
    login(); // Perform login when the page is initialized
    loadBooks();
    loadCategories();
    createNewCategory();
  }

  void loadCategories() async {
    setState(() {
      isLoading = true; // Display a loading indicator
    });
    try {
      List<Category> loadedCategories = await DatabaseAPI().getAllCategories();
      for (Category category in loadedCategories) {
        int count = await DatabaseAPI().countBooksInCategory(
            category.id); // This will print the id of each Category in the list
        bookscount[category.id] = count.toString();
      }
      print(bookscount);
      setState(() {
        categories = loadedCategories;
        isLoading = false; // Stop the loading indicator
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Also stop loading on error
      });
      print("Failed to load categories: $e");
    }
  }

  void login() async {
    bool isLoggedIn = await DatabaseAPI()
        .auth
        .login('ladhari.adem5@gmail.com', 'adima 123'); // Corrected method name
    if (isLoggedIn) {
      print("Login successful");
    } else {
      print("Login failed");
    }
  }

  void loadBooks() async {
    setState(() {
      isLoading = true;
    });
    try {
      var fetchedBooks = await DatabaseAPI().getAllBooks();
      setState(() {
        books = fetchedBooks;
        isLoading = false;
        books.forEach((book) {
          print('Book ID: ${book.id}, Category ID: ${book.category["\$id"]}');
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Failed to load books: $e");
    }
  }

  void uploadFileToAppwriteStorage(
      String projectId, String collectionId, File file) async {
    // Implement your upload logic here
  }

  PickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.first.path!);
      uploadFileToAppwriteStorage('<projectId>', '<collectionId>', file);
    } else {
      print("No image is selected!");
    }
  }

  void createNewCategory() async {
    try {
      var result = await DatabaseAPI()
          .createCategorie({'name': 'Science Fiction', 'language': 'eng'});
      print('Category created successfully: $result');
    } catch (e) {
      print('Failed to create category: $e');
    }
  }

  Widget buildCategoriesList() {
    return FutureBuilder(
      future: DatabaseAPI().getAllCategories(),
      builder: (context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var category = snapshot.data![index];
              return ListTile(
                title: Text(category.name),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navbar Column
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isNavbarOpen ? 250 : 60,
            child: Navbar(
              selectedIndex: 0, // Assuming default index is 0
              onDestinationSelected: (int index) {
                // Handle navigation here
              },
            ),
          ),
          // Content Column
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isNavbarOpen ? Icons.menu_open : Icons.menu,
                          ),
                          onPressed: () {
                            setState(() {
                              _isNavbarOpen = !_isNavbarOpen;
                            });
                          },
                        ),
                        Text(
                          "Add Category",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          color: Colors.blueGrey,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                PickImage();
                              },
                              child: image == null
                                  ? Center(child: Icon(Icons.file_upload))
                                  : Image.memory(image, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 250,
                                child: TextFormField(
                                  controller: _catName,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter Category Name";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Category Name",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      print("ig?");
                                    },
                                    child: Text("Save"),
                                  ),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      print('here');
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Categories",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Number of Books')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: categories
                            .map(
                              (category) => DataRow(
                                cells: [
                                  DataCell(
                                    InkWell(
                                      onTap: () {
                                        _showBooksDialog(context, category);
                                      },
                                      child: Text(category.id),
                                    ),
                                  ),
                                  DataCell(Text(category.name)),
                                  DataCell(
                                      Text(bookscount[category.id] ?? '0')),
                                  DataCell(Text(category.language)),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.green),
                                          onPressed: () {
                                            // Add edit functionality
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            // Add delete functionality
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBooksDialog(BuildContext context, Category category) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Books in Category ${category.name}'),
          content: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Actions')),
              ],
              rows: books
                  .where((book) =>
                      book.category["\$id"] ==
                      category.id) // Ensuring correct matching with category ID
                  .map(
                    (book) => DataRow(
                      cells: [
                        DataCell(Text(book.id)),
                        DataCell(Text(book.name)),
                        DataCell(Text('${book.price}')),
                        DataCell(Text(book.type)),
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Implement book editing functionality here
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Implement book deletion functionality here
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Implement book addition functionality here
              },
              child: Text('Add Book'),
            ),
          ],
        );
      },
    );
  }
}

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const Navbar({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: Colors.blue,
      unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
      unselectedLabelTextStyle: TextStyle(color: Colors.white),
      selectedIconTheme: IconThemeData(color: Colors.blue),
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bar_chart),
          label: Text('Reports'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text('Profile'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
