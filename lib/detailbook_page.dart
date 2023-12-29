import 'dart:convert';

import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:basic_book_crud_msib/editbook_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class DetailBookPage extends StatefulWidget {
  // const DetailBookPage({super.key});
  final String nID;
  const DetailBookPage({
    Key? key,
    required this.nID,
  }) : super(key: key);

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  Map<String, dynamic> _databook = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(widget.nID);
  }

  Future<void> fetchData(String id) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse(
          'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/$id'), // Ganti dengan URL login Anda
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/$id');
    if (response.statusCode == 200) {
      final Map<String, dynamic> dataresponse = json.decode(response.body);
      setState(() {
        _databook = dataresponse;
        isLoading = false;
      });
    } else {
      print('Gagal mendapatkan data dari API. Status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> DeleteBook(String id) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse(
          'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/books/$id'), // Ganti dengan URL login Anda
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
          title: Text('Detail Book'),
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
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _databook.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await fetchData(widget.nID);
                            },
                            child: ListView(
                              children: [Text('Tidak ada data')],
                            ))
                        : RefreshIndicator(
                            onRefresh: () async {
                              await fetchData(widget.nID);
                            },
                            child: ListView(
                              children: [
                                ListTile(
                                  title: Text('ISBN'),
                                  subtitle: Text(_databook['isbn']),
                                ),
                                ListTile(
                                  title: Text('Title'),
                                  subtitle: Text(_databook['title']),
                                ),
                                ListTile(
                                  title: Text('Subtitle'),
                                  subtitle: Text(_databook['subtitle']),
                                ),
                                ListTile(
                                  title: Text('Author'),
                                  subtitle: Text(_databook['author']),
                                ),
                                ListTile(
                                  title: Text('Published'),
                                  subtitle: Text(_databook['published']),
                                ),
                                ListTile(
                                  title: Text('Publisher'),
                                  subtitle: Text(_databook['publisher']),
                                ),
                                ListTile(
                                  title: Text('Pages'),
                                  subtitle: Text(_databook['pages'].toString()),
                                ),
                                ListTile(
                                  title: Text('Description'),
                                  subtitle: Text(_databook['description']),
                                ),
                                ListTile(
                                  title: Text('Website'),
                                  subtitle: Text(_databook['website']),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => EditBookPage(nID: widget.nID)));
                                    }, child: Text('Edit')),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                    onPressed: () async {
                                      await DeleteBook(widget.nID);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Delete')),
                              ],
                            )))));
  }
}
