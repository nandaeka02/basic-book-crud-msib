import 'dart:convert';

import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:basic_book_crud_msib/addbook_page.dart';
import 'package:basic_book_crud_msib/detailbook_page.dart';
import 'package:basic_book_crud_msib/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;

class BookController extends GetxController {
  RxList<dynamic> datas = <dynamic>[].obs;
  RxBool isLoading = true.obs;

  Future<void> fetchData() async {
    final token = await AuthService.getToken();
    Dio dio = Dio();
    try {
      Response response = await dio.get(
        'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataresponse = response.data;
        final List<dynamic> data = dataresponse['data'];
        datas.assignAll(data);
        isLoading.value = false;
      } else {
        print(
            'Gagal mendapatkan data dari API. Status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<Map<String, dynamic>> logoutUser(String? token) async {
    try {
      Dio dio = Dio();
      Response response = await dio.delete(
        'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/user/logout',
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  @override
  Widget build(BuildContext context) {
    final BookController bookController = Get.put(BookController());
    // bookController.fetchData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                String? token = await AuthService.getToken();
                if (token!.isNotEmpty) {
                  bookController.logoutUser(token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Logout Successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  await AuthService.clearToken();
                  Get.delete<BookController>();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(32),
          child: Obx(() {
            bookController.fetchData();
            if (bookController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (bookController.datas.isEmpty) {
                return RefreshIndicator(
                    onRefresh: bookController.fetchData,
                    child: ListView(
                      children: [Text('Tidak ada data')],
                    ));
              } else {
                return RefreshIndicator(
                  onRefresh: bookController.fetchData,
                  child: ListView.builder(
                    itemCount: bookController.datas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            bookController.datas[index]['title'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(bookController.datas[index]['subtitle']
                              .toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailBookPage(
                                        nID: bookController.datas[index]['id']
                                            .toString())));
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            }
          })),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Tambah Buku',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBookPage()));
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
