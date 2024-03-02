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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/detail/外枠.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                width: 300,
                height: 200,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Icon(Icons.favorite, color: Colors.pink),
                // いいねの数
                Text(_favoriteCount.toString()),
                SizedBox(width: 36),
              ]),
            ),
            Container(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              width: 300,
              height: 100,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 120),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) =>
                                EditItemPage(editTarget: widget.item)),
                      );
                      setState(() {});
                    },
                    child:
                        Image.asset("assets/images/detail/★編集.png", width: 160),
                  ),
                  CupertinoButton(
                    onPressed: () => {
                      _deleteItem(),
                      Navigator.popUntil(context, (route) => route.isFirst),
                    },
                    child: Image.asset("assets/images/detail/★出品停止.png",
                        width: 160),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text("出品情報"), backgroundColor: CupertinoColors.activeGreen),
      child: _buildBody(widget.item),
    );
  }
}

class Candidate {
  final String id;
  final String name;
  Candidate({required this.id, required this.name});
}
