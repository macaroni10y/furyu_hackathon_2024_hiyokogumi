import 'package:flutter/cupertino.dart';

class Hoge extends StatelessWidget {
  const Hoge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Hoge'),
      ),
      child: Center(
        child: Text('Hoge'),
      ),
    );
  }
}
