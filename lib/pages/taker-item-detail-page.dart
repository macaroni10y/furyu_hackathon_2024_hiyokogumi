import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';
import 'items_list_view_page.dart';

class TakerItemDetailPage extends StatefulWidget {
  TakerItemDetailPage({super.key, required this.item});
  final Item item;

  @override
  State<TakerItemDetailPage> createState() => _TakerItemDetailPageState();
}

class _TakerItemDetailPageState extends State<TakerItemDetailPage> {
  bool favorite = false;

  /// 他人が出品した商品の詳細ページのbodyを生成する
  Widget _buildBody(Item item) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
          width: 300,
          height: 300,
          margin: const EdgeInsets.fromLTRB(16, 80, 16, 24),
          child: Image.network(item.imageUrl, fit: BoxFit.contain),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Row(
            children: [
              Spacer(
                flex: 1,
              ),
              // ここのSizedBoxはボタンの幅とボタンとの間隔分のサイズで間隔を入れている
              SizedBox(
                width: 24,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 256,
                ),
                child: Text(
                  // TODO: font sizeを文字数に合わせて可変にしないと、改行が入ってレイアウト崩れる
                  item.title,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    // いいね取り消し無効
                    //favorite ? favorite = false : favorite = true;
                    favorite = true;
                  });
                },
                icon: Icon(Icons.favorite),
                color: favorite ? Colors.pink : Colors.black12,
                highlightColor: Colors.white,
              ),
              // いいねの数
              Text('100'),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ),
        Text(
          item.description,
          style: TextStyle(
            fontSize: 20,
          ),
        ),

        // TODO: タグを表示する部分を入れる

        Container(
          margin: const EdgeInsets.fromLTRB(16, 32, 16, 32),
          child: CupertinoButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ChatPage(
                            item: widget.item,
                            candidateId: FirebaseAuth.instance.currentUser!.uid,
                          )))
            },
            child: Text("やりとりする"),
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
