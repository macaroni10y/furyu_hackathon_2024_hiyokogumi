import 'package:flutter/cupertino.dart';

class Fuga extends StatelessWidget {
  const Fuga({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Fuga'),
      ),
      child: Center(
        child: Text('Fuga'),
      ),
    );
  }
}
