import 'dart:convert';

import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:basic_book_crud_msib/addbook_page.dart';
import 'package:basic_book_crud_msib/detailbook_page.dart';
import 'package:basic_book_crud_msib/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<dynamic> datas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse(
          'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/'), // Ganti dengan URL login Anda
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataresponse = json.decode(response.body);
      final List<dynamic> data = dataresponse['data'];
      setState(() {
        datas = data.map((item) => item).toList();
        isLoading = false;
      });
    } else {
      print('Gagal mendapatkan data dari API. Status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> LogoutUser(String? token) async {
    final response = await http.delete(
      Uri.parse(
          'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/user/logout'), // Ganti dengan URL login Anda
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                String? token = await AuthService.getToken();
                if (token!.isNotEmpty) {
                  await LogoutUser(token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Logout Successfully'),
                      duration: Duration(
                          seconds: 2),
                    ),
                  );
                  await AuthService.clearToken();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(32),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : datas.isEmpty
                  ? RefreshIndicator(
                      onRefresh: fetchData,
                      child: ListView(
                        children: [Text('Tidak ada data')],
                      ))
                  : RefreshIndicator(
                      onRefresh: fetchData,
                      child: ListView.builder(
                        itemCount: datas.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(
                                datas[index]['title'].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle:
                                  Text(datas[index]['subtitle'].toString()),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailBookPage(nID: datas[index]['id'].toString())));
                                // print('Item ${datas[index]} diklik');
                              },
                            ),
                          );
                        },
                      ),
                    )),
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
