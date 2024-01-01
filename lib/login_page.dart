import 'dart:convert';
import 'package:basic_book_crud_msib/Constant/auth_service.dart';
import 'package:basic_book_crud_msib/home_page.dart';
import 'package:basic_book_crud_msib/register_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool obscureTextPassword = true.obs;

  RxBool isLoading = false.obs;

  Future<void> loginUser(BuildContext context) async {
    try {
      isLoading.value = true;

      Dio dio = Dio();
      Response response = await dio.post(
        'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/login',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Login Successfully'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
        // Anda dapat menavigasi ke halaman lain di sini jika diperlukan
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to log in.'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred while logging in'),
          duration:
              Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  // final _keyFormLogin = GlobalKey<FormState>();
  // TextEditingController _emailController = TextEditingController();
  // TextEditingController _passwordController = TextEditingController();
  // String _email = '';
  // String _password = '';
  bool _obscureText = true;

  // Future<Map<String, dynamic>> loginUser(String email, String password) async {
  //   Dio dio = Dio();

  //   try {
  //     Response response = await dio.post(
  //       'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/login', // Ganti dengan URL login Anda
  //       options: Options(
  //         headers: {'Content-Type': 'application/json'},
  //       ),
  //       data: {
  //         'email': email,
  //         'password': password,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return {'success': true, 'message': response.data};
  //     } else {
  //       return {'success': false, 'message': response.data};
  //     }
  //   } catch (error) {
  //     return {'success': false, 'message': '$error'};
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(32),
        child: Form(
            key: loginController.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: loginController.emailController,
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
                  controller: loginController.passwordController,
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
                      if (loginController.formKey.currentState!.validate()) {
                        loginController.formKey.currentState!.save();
                        var result = await loginController.loginUser(context);
                        // var result = await loginUser(
                        //     _emailController.text, _passwordController.text);
                        // if (result['success']) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: Colors.green,
                        //       content: Text('Login Successfully'),
                        //       duration: Duration(
                        //           seconds:
                        //               2), // Durasi snackbar ditampilkan (opsional)
                        //     ),
                        //   );
                        //   await AuthService.saveToken(
                        //       result['message']['token']);
                        Get.delete<LoginController>();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage()));
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: Colors.red,
                        //       content: Text(
                        //           'Failed : '),
                        //       duration: Duration(
                        //           seconds:
                        //               2), // Durasi snackbar ditampilkan (opsional)
                        //     ),
                        //   );
                        // }
                      }
                    },
                    child: Text('Login')),
                const SizedBox(height: 32),
                Text('Belum punya akun?'),
                TextButton(
                    onPressed: () {
                      Get.delete<LoginController>();
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
