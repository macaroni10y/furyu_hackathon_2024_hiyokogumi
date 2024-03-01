import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'items_list_view_page.dart';

class MyItemDetailPage extends StatefulWidget {
  const MyItemDetailPage({super.key, required this.item});
  final Item item;

  @override
  State<MyItemDetailPage> createState() => _MyItemDetailPageState();
}

class _MyItemDetailPageState extends State<MyItemDetailPage> {
  /// 自分が出品した商品の詳細ページのbodyを生成する
  Widget _buildBody(Item item) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
          width: 300,
          height: 300,
          margin: const EdgeInsets.fromLTRB(16, 120, 16, 24),
          child: Image.network(item.imageUrl),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              item.title,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Icon(Icons.favorite, color: Colors.pink),
            // いいねの数
            Text('100'),
          ]),
        ),
        Text(
          item.description,
          style: TextStyle(
            fontSize: 20,
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
      navigationBar: CupertinoNavigationBar(middle: Text("詳細画面")),
      child: _buildBody(widget.item),
    );
  }
}
