import 'package:flutter/cupertino.dart';

class MyItemDetailPage extends StatefulWidget {
  const MyItemDetailPage({super.key});

  @override
  State<MyItemDetailPage> createState() => _MyItemDetailPageState();
}

class _MyItemDetailPageState extends State<MyItemDetailPage> {
  /// 自分が出品した商品の詳細ページのbodyを生成する
  Widget _buildBody() {
    return Center(
        child: Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 120, 16, 24),
          child: Image.network('https://placehold.jp/300x300.png'),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Text(
            "imageTitle",
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
        Text(
          "description",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 32, 16, 32),
          child: Row(
            children: [
              const Spacer(
                flex: 1,
              ),
              CupertinoButton(
                onPressed: () => {},
                child: Text("編集する"),
              ),
              const Spacer(
                flex: 2,
              ),
              CupertinoButton(
                onPressed: () => {},
                child: Text("出品をやめる"),
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text("widget.itemsListPageKind.title")),
      child: _buildBody(),
    );
  }
}
