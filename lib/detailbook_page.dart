import 'dart:convert';
import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:basic_book_crud_msib/editbook_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;

class BookDetailController extends GetxController {
  RxMap<dynamic, dynamic> databook = {}.obs;
  RxBool isLoading = true.obs;

  Future<void> fetchData(String id) async {
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
        databook.assignAll(response.data);
        isLoading.value = false;
      } else {
        print(
            'Gagal mendapatkan data dari API. Status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<Map<String, dynamic>> deleteBook(String id) async {
    try {
      Dio dio = Dio();
      final token = await AuthService.getToken();
      Response response = await dio.delete(
        'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false};
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false};
    }
  }
}

class DetailBookPage extends StatefulWidget {
  final String nID;
  const DetailBookPage({
    Key? key,
    required this.nID,
  }) : super(key: key);

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  final BookDetailController bookDetailController =
      Get.put(BookDetailController());

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Book'),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.delete<BookDetailController>();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(32),
                child: Obx(() {
                  if (bookDetailController.isLoading.value) {
                    bookDetailController.fetchData(widget.nID);
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (bookDetailController.databook.isEmpty) {
                      return RefreshIndicator(
                          onRefresh: () async {
                            bookDetailController.fetchData(widget.nID);
                          },
                          child: ListView(
                            children: [Text('Tidak ada data')],
                          ));
                    } else {
                      return RefreshIndicator(
                          onRefresh: () async {
                            bookDetailController.fetchData(widget.nID);
                          },
                          child: ListView(
                            children: [
                              ListTile(
                                title: Text('ISBN'),
                                subtitle:
                                    Text(bookDetailController.databook['isbn']),
                              ),
                              ListTile(
                                title: Text('Title'),
                                subtitle: Text(
                                    bookDetailController.databook['title']),
                              ),
                              ListTile(
                                title: Text('Subtitle'),
                                subtitle: Text(
                                    bookDetailController.databook['subtitle']),
                              ),
                              ListTile(
                                title: Text('Author'),
                                subtitle: Text(
                                    bookDetailController.databook['author']),
                              ),
                              ListTile(
                                title: Text('Published'),
                                subtitle: Text(
                                    bookDetailController.databook['published']),
                              ),
                              ListTile(
                                title: Text('Publisher'),
                                subtitle: Text(
                                    bookDetailController.databook['publisher']),
                              ),
                              ListTile(
                                title: Text('Pages'),
                                subtitle: Text(bookDetailController
                                    .databook['pages']
                                    .toString()),
                              ),
                              ListTile(
                                title: Text('Description'),
                                subtitle: Text(bookDetailController
                                    .databook['description']),
                              ),
                              ListTile(
                                title: Text('Website'),
                                subtitle: Text(
                                    bookDetailController.databook['website']),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditBookPage(nID: widget.nID)));
                                  },
                                  child: Text('Edit')),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                  ),
                                  onPressed: () async {
                                    bookDetailController.deleteBook(widget.nID);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete')),
                            ],
                          ));
                    }
                  }
                }))));
  }
}
