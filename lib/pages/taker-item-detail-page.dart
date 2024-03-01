import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'chat_page.dart';
import 'items_list_view_page.dart';

class TakerItemDetailPage extends StatefulWidget {
  const TakerItemDetailPage({super.key, required this.item});
  final Item item;

  @override
  State<TakerItemDetailPage> createState() => _TakerItemDetailPageState();
}

class _TakerItemDetailPageState extends State<TakerItemDetailPage> {
  /// 他人が出品した商品の詳細ページのbodyを生成する
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
                  "imageTitle",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 16,
                child: CupertinoButton(child: Text("♡"), onPressed: () => {}),
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ),
        Text(
          "description",
          style: TextStyle(
            fontSize: 24,
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
      navigationBar: CupertinoNavigationBar(
          middle: Text("widget.itemsListPageKind.title")),
      child: _buildBody(),
    );
  }
}
