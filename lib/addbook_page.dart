import 'dart:convert';

import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:basic_book_crud_msib/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _keyFormAddBook = GlobalKey<FormState>();
  TextEditingController _isbnController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _publishedController = TextEditingController();
  TextEditingController _publisherController = TextEditingController();
  TextEditingController _pagesController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();

  Future<Map<String, dynamic>> AddBookRequest(
      String isbn,
      String title,
      String? subtitle,
      String? author,
      String? published,
      String? publisher,
      String? pages,
      String? description,
      String? website) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse(
          'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'isbn': isbn,
        'title': title,
        'subtitle': subtitle ?? '',
        'author': author ?? '',
        'published': published ?? '',
        'publisher': publisher ?? '',
        'pages': pages ?? '',
        'description': description ?? '',
        'website': website ?? '',
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      return {'success': false};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(32),
        child: Form(
            key: _keyFormAddBook,
            child: ListView(
              children: [
                const SizedBox(height: 32),
                TextFormField(
                  autofocus: true,
                  controller: _isbnController,
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
                  controller: _titleController,
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
                  controller: _subtitleController,
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
                  controller: _authorController,
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
                  controller: _publishedController,
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
                                        _publishedController.text =
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
                                      _publishedController.text =
                                          formattedDateString;
                                      print(_publishedController);
                                      Navigator.pop(context);
                                      // });
                                    },
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                            print(_publishedController);
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
                  controller: _publisherController,
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
                  controller: _pagesController,
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
                  controller: _descriptionController,
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
                  controller: _websiteController,
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
                      if (_keyFormAddBook.currentState!.validate()) {
                        _keyFormAddBook.currentState!.save();

                        var result = await AddBookRequest(
                            _isbnController.text,
                            _titleController.text,
                            _subtitleController.text,
                            _authorController.text,
                            _publishedController.text,
                            _publisherController.text,
                            _pagesController.text,
                            _descriptionController.text,
                            _websiteController.text);
                        if (result['success']) {

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Add Book Successfully'),
                              duration: Duration(
                                  seconds:
                                      2), // Durasi snackbar ditampilkan (opsional)
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Failed : '),
                              duration: Duration(
                                  seconds:
                                      2), // Durasi snackbar ditampilkan (opsional)
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Add')),
              ],
            )),
      )),
    );
  }
}
