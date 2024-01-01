import 'dart:convert';
import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:basic_book_crud_msib/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class AddBookController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController isbnController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publishedController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> addBookRequest(BuildContext context) async {
    try {
      isLoading.value = true;

      final token = await AuthService.getToken();
      Dio dio = Dio();
      Response response = await dio.post(
        'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/add',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'isbn': isbnController.text,
          'title': titleController.text,
          'subtitle': subtitleController.text,
          'author': authorController.text,
          'published': publishedController.text,
          'publisher': publisherController.text,
          'pages': pagesController.text,
          'description': descriptionController.text,
          'website': websiteController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Add Book Successfully'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
        // Get.snackbar('Success', 'Book added successfully');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to add book. Status: ${response.statusCode}'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred while adding the book'),
          duration:
              Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final AddBookController addBookController = Get.put(AddBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.delete<AddBookController>();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(32),
        child: Form(
            key: addBookController.formKey,
            child: ListView(
              children: [
                const SizedBox(height: 32),
                TextFormField(
                  autofocus: true,
                  controller: addBookController.isbnController,
                  decoration: InputDecoration(
                    labelText: 'ISBN',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter ISBN';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: addBookController.titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: addBookController.subtitleController,
                  decoration: InputDecoration(
                    labelText: 'Subtitle',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Subtitle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: addBookController.authorController,
                  decoration: InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Author';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: addBookController.publishedController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Published',
                      border: OutlineInputBorder(),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(
                            8.0), // Sesuaikan dengan padding yang diinginkan
                        child: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            showDialog<Widget>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SfDateRangePicker(
                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs
                                            args) {
                                      setState(() {
                                        addBookController.publishedController
                                            .text = args.value.toString();
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    showActionButtons: true,
                                    onSubmit: (value) {
                                      // setState(() {
                                      String formattedDateString = DateFormat(
                                              'yyyy-MM-dd HH:mm:ss')
                                          .format(
                                              DateTime.parse(value.toString()));
                                      addBookController.publishedController
                                          .text = formattedDateString;
                                      print(addBookController
                                          .publishedController);
                                      Navigator.pop(context);
                                      // });
                                    },
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                            print(addBookController.publishedController);
                          },
                        ),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Published';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: addBookController.publisherController,
                  decoration: InputDecoration(
                    labelText: 'Publisher',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Publisher';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: addBookController.pagesController,
                  decoration: InputDecoration(
                    labelText: 'Pages',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Pages';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: addBookController.descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: addBookController.websiteController,
                  decoration: InputDecoration(
                    labelText: 'Website',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Website';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                    onPressed: () async {
                      if (addBookController.formKey.currentState!.validate()) {
                        addBookController.formKey.currentState!.save();
                        var result = await addBookController.addBookRequest(context);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add')),
              ],
            )),
      )),
    );
  }
}
