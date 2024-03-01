import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:furyu_hackathon_2024_hiyokogumi/pages/my_home_page.dart';

class CreateNewAccount extends StatelessWidget {
  CreateNewAccount({Key? key}) : super(key: key);

  String? userEmail = '';
  String? userPassword = '';
  String? userName = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('新しいアカウントを作る'),
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('パスワード'),
                  CupertinoTextField(
                    placeholder: "Enter passwarod",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSubmitted: (String txt){
                      userPassword = txt;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('ユーザ名'),
                  CupertinoTextField(
                    placeholder: "Enter username",
                    keyboardType: TextInputType.name,
                    onSubmitted: (String txt){
                      userName = txt;
                    },
                  ),
                  CupertinoButton(
                    child: Text('アカウント登録'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(title: 'Flutter Demo Home Page'),
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
