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
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/createNewAccount/bk.png"),
          ),
        ),
        child: CupertinoPageScaffold(
            backgroundColor: Colors.transparent,
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.lightGreen,
              middle: Text('新しいアカウントを作る'),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 250,
                          height: 30,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                                "assets/images/createNewAccount/ロゴ.png"),
                          )),
                        ),
                        Container(
                          width: 140,
                          height: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                                "assets/images/createNewAccount/キャッチコピー.png"),
                          )),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          width: 140,
                          height: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                                "assets/images/createNewAccount/mail.png"),
                          )),
                        ),
                        CupertinoTextField(
                          //placeholder: "Enter e-mail",
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (String txt) {
                            userEmail = txt;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          width: 110,
                          height: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                                "assets/images/createNewAccount/password.png"),
                          )),
                        ),
                        CupertinoTextField(
                          //placeholder: "Enter passwarod",
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          onChanged: (String txt) {
                            userPassword = txt;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          width: 140,
                          height: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                                "assets/images/createNewAccount/username.png"),
                          )),
                        ),
                        CupertinoTextField(
                          //placeholder: "Enter username",
                          keyboardType: TextInputType.name,
                          onChanged: (String txt) {
                            userName = txt;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CupertinoButton(
                          child: Container(
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/createNewAccount/btn.png"),
                            )),
                          ),
                          onPressed: () async {
                            if (userPassword.length < 6) {
                              setState(() {
                                infoText = 'パスワードは6文字以上で設定してください';
                              });
                            } else if (!userPassword.isEmpty &&
                                !userEmail.isEmpty) {
                              try {
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final UserCredential result =
                                    await auth.createUserWithEmailAndPassword(
                                        email: userEmail,
                                        password: userPassword);

                                final User user = result.user!;
                                await _registerNickName(
                                    user.uid, userName, userEmail);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(
                                        title: 'Flutter Demo Home Page'),
                                  ),
                                );
                              } catch (e) {
                                setState(() {
                                  print(e);
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
                          height: 10,
                        ),
                        Text(infoText),
                      ],
                    ),
                  ),
                ))));
  }
}
