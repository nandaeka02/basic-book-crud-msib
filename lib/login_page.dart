import 'dart:convert';
import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:basic_book_crud_msib/home_page.dart';
import 'package:basic_book_crud_msib/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyFormLogin = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _email = '';
  String _password = '';
  bool _obscureText = true;

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(
          'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/login'), // Ganti dengan URL login Anda
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login berhasil
      print((json.decode(response.body))['token']);
      return {'success': true, 'message': json.decode(response.body)};
    } else {
      // Login gagal
      print(json.decode(response.body));
      return {'success': false, 'message': json.decode(response.body)};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(32),
        child: Form(
            key: _keyFormLogin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                    onPressed: () async {
                      if (_keyFormLogin.currentState!.validate()) {
                        _keyFormLogin.currentState!.save();
                        var result = await loginUser(
                            _emailController.text, _passwordController.text);
                        if (result['success']) {
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Login Successfully'),
                              duration: Duration(
                                  seconds:
                                      2), // Durasi snackbar ditampilkan (opsional)
                            ),
                          );
                          await AuthService.saveToken(result['message']['token']);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Failed : ${result['message']['message']}'),
                              duration: Duration(
                                  seconds:
                                      2), // Durasi snackbar ditampilkan (opsional)
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Login')),
                const SizedBox(height: 32),
                Text('Belum punya akun?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text('Klik disini untuk registrasi'))
              ],
            )),
      )),
    );
  }
}
