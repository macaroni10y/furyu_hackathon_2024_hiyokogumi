import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/CreateNewAccount.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/my_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginEmail = '';
  String loginPassword = '';
  String infoText = '';

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('ログイン'),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('e-mailアドレス'),
                  CupertinoTextField(
                    placeholder: "Enter e-mail",
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (String txt) {
                      loginEmail = txt;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('パスワード'),
                  CupertinoTextField(
                    placeholder: "Enter passwarod",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSubmitted: (String txt) {
                      loginPassword = txt;
                    },
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    child: Text('ログイン'),
                    onPressed: () async {
                      if (loginPassword.length < 6) {
                        setState(() {
                          infoText = 'パスワードは6文字以上です';
                        });
                      } else if (!loginPassword.isEmpty &&
                          !loginEmail.isEmpty) {
                        try {
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final UserCredential result =
                              await auth.signInWithEmailAndPassword(
                                  email: loginEmail, password: loginPassword);

                          final User user = result.user!;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(title: 'Flutter Demo Home Page'),
                            ),
                          );
                        } catch (e) {
                          setState(() {
                            infoText = 'ログインエラーが発生しました';
                          });
                        }
                      } else {
                        setState(() {
                          infoText = 'ログインエラーが発生しました';
                        });
                      }
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(infoText),
                  CupertinoButton(
                    child: Text("debug"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(title: 'Flutter Demo Home Page'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )));
  }
}
