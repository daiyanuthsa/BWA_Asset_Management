import 'dart:convert';

import 'package:bwa_asset_management/config/app_constant.dart';
import 'package:bwa_asset_management/pages/asset/pages_home.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final edtUsername = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      //Form tervalidasi

      Uri url = Uri.parse(
          '${AppConstant.baseUrl}/user/login.php');

      try {
         final response = await http.post(url, body: {
          'username': edtUsername.text,
          'password': edtPassword.text
        });

        DMethod.printResponse(response);

        Map resBody = jsonDecode(response.body);

        bool loginStatus = resBody['status'] ?? false;

        if (loginStatus) {
          DInfo.toastSuccess('Login Success');
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
        } else {
          DInfo.toastError('Login Failed');
        }
      } catch (e) {
        DInfo.toastError('Something wrong');
        DMethod.printBasic(e.toString());
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.purple[300],
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.purple[300],
            ),
          ),
          Positioned(
              bottom: 40,
              left: 40,
              child: Icon(
                Icons.scatter_plot,
                size: 90,
                color: Colors.purple[400],
              )),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppConstant.appName,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.purple[500]),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: edtUsername,
                      validator: (value) =>
                          value == '' ? "Username must be filled" : null,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        isDense: true,
                        hintText: 'Username',
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                      controller: edtPassword,
                      obscureText: true,
                      validator: (value) =>
                          value == '' ? "Password must be filled" : null,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        isDense: true,
                        hintText: 'Password',
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    child: const Text('Login'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
