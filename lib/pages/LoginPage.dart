import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:furyu_hackathon_2024_hiyokogumi/pages/CreateNewAccount.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/my_home_page.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/hoge.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? userEmail = '';
  String? userPassword = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('ログイン'),
      ),
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('e-mailアドレス'),
            CupertinoTextField(
              placeholder: "Enter e-mail",
              keyboardType: TextInputType.emailAddress,
              onSubmitted: (String txt){
                userEmail = txt;
              },
            ),
            const SizedBox(height: 20),
            const Text('パスワード'),
            CupertinoTextField(
              placeholder: "Enter passwarod",
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onSubmitted: (String txt){
                userPassword = txt;
              },
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              child: Text('ログイン'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'Flutter Demo Home Page'),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              child: Text('新しいアカウントを作る'),
              onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => CreateNewAccount(),
                    ),
                  );
                },
              ),
          ],
        ),
      )
      )
    );
  }
}
