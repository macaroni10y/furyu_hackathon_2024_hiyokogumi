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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/createNewAccount/bk.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("assets/images/createNewAccount/bk.png"),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // 影の色と透明度
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: const Color.fromRGBO(240, 255, 222, 1.0),
                width: 3.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(33)),
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 255, 222, 1.0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: 60,
                  child: const Center(
                    child: Image(
                        width: 120,
                        height: 100,
                        image: AssetImage(
                            "assets/images/createNewAccount/ロゴ.png")),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 140,
                              height: 50,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/createNewAccount/キャッチコピー.png"),
                              )),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              alignment: Alignment.topLeft,
                              width: 140,
                              height: 50,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/createNewAccount/mail.png"),
                              )),
                            ),
                            CupertinoTextField(
                              //placeholder: "Enter e-mail",
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (String txt) {
                                loginEmail = txt;
                              },
                            ),
                            const SizedBox(height: 20),
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
                                loginPassword = txt;
                              },
                            ),
                            const SizedBox(height: 40),
                            CupertinoButton(
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/createNewAccount/ログイン.png"),
                                )),
                              ),
                              onPressed: () async {
                                if (loginPassword.length < 6) {
                                  setState(() {
                                    infoText = 'パスワードは6文字以上です';
                                  });
                                } else if (!loginPassword.isEmpty &&
                                    !loginEmail.isEmpty) {
                                  try {
                                    final FirebaseAuth auth =
                                        FirebaseAuth.instance;
                                    final UserCredential result =
                                        await auth.signInWithEmailAndPassword(
                                            email: loginEmail,
                                            password: loginPassword);

                                    final User user = result.user!;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                            title: 'Flutter Demo Home Page'),
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
                            CupertinoButton(
                              child: Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/createNewAccount/btn.png"),
                                )),
                              ),
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
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          )),
    );
  }
}
