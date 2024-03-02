import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/edit_item_page.dart';

import 'items_list_view_page.dart';

class MyItemDetailPage extends StatefulWidget {
  const MyItemDetailPage({super.key, required this.item});
  final Item item;

  @override
  State<MyItemDetailPage> createState() => _MyItemDetailPageState();
}

class _MyItemDetailPageState extends State<MyItemDetailPage> {
  int _favoriteCount = 0;
  List<Candidate> _candidateList = [];
  void _fetchLikeCount() async {
    var likes = await FirebaseFirestore.instance
        .collection("idea_items")
        .doc(widget.item.id)
        .collection('likes')
        .get();
    _favoriteCount = likes.size;
    setState(() {});
  }

  // 出品を取り消す
  void _deleteItem() {
    FirebaseFirestore.instance
        .collection('idea_items')
        .doc(widget.item.id)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    _fetchLikeCount();
  }

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
            Text(_favoriteCount.toString()),
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
                onPressed: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                        builder: (context) =>
                            EditItemPage(editTarget: widget.item)),
                  );
                  setState(() {});
                },
                child: Text("編集する"),
              ),
              const Spacer(
                flex: 2,
              ),
              CupertinoButton(
                onPressed: () => {
                  _deleteItem(),
                  Navigator.popUntil(context, (route) => route.isFirst),
                },
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

class Candidate {
  final String id;
  final String name;
  Candidate({required this.id, required this.name});
}
