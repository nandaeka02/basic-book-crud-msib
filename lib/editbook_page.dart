import 'dart:convert';

import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class EditBookController extends GetxController {
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

  RxBool isLoading = true.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchData(widget);
  // }

  Future<void> fetchData(String id, BuildContext context) async {
    try {
      final token = await AuthService.getToken();
      Dio dio = Dio();
      Response response = await dio.get(
        'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataresponse = response.data;
        isbnController.text = dataresponse['isbn'];
        titleController.text = dataresponse['title'];
        subtitleController.text = dataresponse['subtitle'];
        authorController.text = dataresponse['author'];
        publishedController.text = dataresponse['published'];
        publisherController.text = dataresponse['publisher'];
        pagesController.text = dataresponse['pages'].toString();
        descriptionController.text = dataresponse['description'];
        websiteController.text = dataresponse['website'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to fetch book data. Status: ${response.statusCode}'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('An error occurred while fetching book data'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editBookRequest(String id,BuildContext context) async {
    try {
      isLoading.value = true;

      final token = await AuthService.getToken();
      Dio dio = Dio();
      Response response = await dio.put(
        'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/$id/edit',
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
            content: Text('Edit Book Successfully'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to Edit book. Status: ${response.statusCode}'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred while editing the book'),
          duration:
              Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class EditBookPage extends StatefulWidget {
  final String nID;
  const EditBookPage({
    Key? key,
    required this.nID,
  }) : super(key: key);

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final EditBookController editBookController = Get.put(EditBookController());
  // final _keyFormAddBook = GlobalKey<FormState>();
  // bool isLoading = true;

  // TextEditingController _isbnController = TextEditingController();
  // TextEditingController _titleController = TextEditingController();
  // TextEditingController _subtitleController = TextEditingController();
  // TextEditingController _authorController = TextEditingController();
  // TextEditingController _publishedController = TextEditingController();
  // TextEditingController _publisherController = TextEditingController();
  // TextEditingController _pagesController = TextEditingController();
  // TextEditingController _descriptionController = TextEditingController();
  // TextEditingController _websiteController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData(widget.nID);
  // }
  
  // Future<void> fetchData(String id) async {
  //   final token = await AuthService.getToken();
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/$id'), // Ganti dengan URL login Anda
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> dataresponse = json.decode(response.body);
  //     setState(() {
  //       _isbnController.text = dataresponse['isbn'];
  //       _titleController.text = dataresponse['title'];
  //       _subtitleController.text = dataresponse['subtitle'];
  //       _authorController.text = dataresponse['author'];
  //       _publishedController.text = dataresponse['published'];
  //       _publisherController.text = dataresponse['publisher'];
  //       _pagesController.text = dataresponse['pages'].toString();
  //       _descriptionController.text = dataresponse['description'];
  //       _websiteController.text = dataresponse['website'];
  //       isLoading = false;
  //     });
  //   } else {
  //     print('Gagal mendapatkan data dari API. Status: ${response.statusCode}');
  //   }
  // }

  // Future<Map<String, dynamic>> EditBookRequest(
  //     String id,
  //     String isbn,
  //     String title,
  //     String? subtitle,
  //     String? author,
  //     String? published,
  //     String? publisher,
  //     String? pages,
  //     String? description,
  //     String? website) async {
  //   final token = await AuthService.getToken();
  //   final response = await http.put(
  //     Uri.parse(
  //         'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/$id/edit'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'isbn': isbn,
  //       'title': title,
  //       'subtitle': subtitle ?? '',
  //       'author': author ?? '',
  //       'published': published ?? '',
  //       'publisher': publisher ?? '',
  //       'pages': pages ?? '',
  //       'description': description ?? '',
  //       'website': website ?? '',
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     return {'success': true};
  //   } else {
  //     return {'success': false};
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    editBookController.fetchData(widget.nID, context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.delete<EditBookController>();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(32),
        child: Form(
            key: editBookController.formKey,
            child: ListView(
              children: [
                const SizedBox(height: 32),
                TextFormField(
                  autofocus: true,
                  controller: editBookController.isbnController,
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
                  controller: editBookController.titleController,
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
                  controller: editBookController.subtitleController,
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
                  controller: editBookController.authorController,
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
                  controller: editBookController.publishedController,
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
                                        editBookController.publishedController.text =
                                            args.value.toString();
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
                                      editBookController.publishedController.text =
                                          formattedDateString;
                                      print(editBookController.publishedController);
                                      Navigator.pop(context);
                                      // });
                                    },
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                            print(editBookController.publishedController);
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
                  controller: editBookController.publisherController,
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
                  controller: editBookController.pagesController,
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
                  controller: editBookController.descriptionController,
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
                  controller: editBookController.websiteController,
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
                      if (editBookController.formKey.currentState!.validate()) {
                        editBookController.formKey.currentState!.save();
                        var result = await editBookController.editBookRequest(widget.nID, context);
                        // if (result['success']) {

                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: Colors.green,
                        //       content: Text('Edit Book Successfully'),
                        //       duration: Duration(
                        //           seconds:
                        //               2), // Durasi snackbar ditampilkan (opsional)
                        //     ),
                        //   );
                        Get.delete<EditBookController>();
                          Navigator.pop(context);
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: Colors.red,
                        //       content: Text('Failed : '),
                        //       duration: Duration(
                        //           seconds:
                        //               2), // Durasi snackbar ditampilkan (opsional)
                        //     ),
                        //   );
                        // }
                      }
                    },
                    child: Text('Save')),
              ],
            )),
      )),
    );
  }
}