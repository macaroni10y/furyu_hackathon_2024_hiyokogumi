import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/my_home_page.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({super.key});

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  String userEmail = '';
  String userPassword = '';
  String userName = '';
  String infoText = '';

  /// firebase認証後に、ニックネームを登録する
  /// firebase authenticationにはメールアドレスとパスワード、UID以外の情報を持たせられないためfirestoreに入れる
  Future<void> _registerNickName(
      String userId, String userName, String userEmail) async {
    await FirebaseFirestore.instance
        .collection('user_info_list')
        .doc(userId)
        .set({
      'name': userName,
      'email': userEmail,
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('新しいアカウントを作る'),
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
                    onSubmitted: (String txt) {
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
                    onSubmitted: (String txt) {
                      userName = txt;
                    },
                  ),
                  CupertinoButton(
                    child: Text('アカウント登録'),
                    onPressed: () async {
                      if (userPassword.length < 6) {
                        setState(() {
                          infoText = 'パスワードは6文字以上で設定してください';
                        });
                      } else if (!userPassword.isEmpty && !userEmail.isEmpty) {
                        try {
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final UserCredential result =
                              await auth.createUserWithEmailAndPassword(
                                  email: userEmail, password: userPassword);

                          final User user = result.user!;
                          await _registerNickName(
                              user.uid, userName, userEmail);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(title: 'Flutter Demo Home Page'),
                            ),
                          );
                        } catch (e) {
                          setState(() {
                            infoText = 'ユーザー登録時にエラーが発生しました';
                          });
                        }
                      } else {
                        setState(() {
                          infoText = 'e-mailアドレスとパスワードの両方を入力してください';
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(infoText),
                ],
              ),
            )));
  }
}
