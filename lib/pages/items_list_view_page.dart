import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/my_item_detail_page.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/register_item_page.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/taker-item-detail-page.dart';

/// 商品一覧画面
/// 自分の商品一覧、いいね一覧、全ての商品一覧に使う想定
class ItemsListViewPage extends StatefulWidget {
  /// page title
  /// 自分の商品一覧、いいね一覧、全ての商品一覧のどれか
  /// @see PageTitle
  const ItemsListViewPage({super.key, required this.itemsListPageKind});
  final ItemsListPageKind itemsListPageKind;

  @override
  State<ItemsListViewPage> createState() => _ItemsListViewPageState();
}

class _ItemsListViewPageState extends State<ItemsListViewPage> {
  List<Item> _items = [];
  String _userId = "";

  /// firestore商品一覧を取得する
  /// TODO: 引数を取って、全て or 自分の商品 or いいねした商品を取得するようにする
  Future<void> _fetchItemsFromStore() async {
    FirebaseFirestore.instance.collection("idea_items").get().then(
      (querySnapshot) {
        print("Successfully completed");
        _items = querySnapshot.docs.map((docSnapshot) {
          var data = docSnapshot.data();
          print(data);
          return Item(
              id: docSnapshot.id,
              title: data["title"],
              description: data["description"],
              imageUrl: data["imageUrl"],
              author: data["author"],
              createdAt: data["timestamp"]);
        }).toList();
        if (widget.itemsListPageKind == ItemsListPageKind.myItems) {
          _items = _items.where((item) => item.author == _userId).toList();
        }
        setState(() {});
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    _fetchItemsFromStore();
  }

  /// 商品画像のURLを受け取って、一覧の1つに表示するWidgetを返す。
  /// TODO 商品1つをどのように表示するかのデザインが出来上がったら、実装する
  /// 画像をタップしたら商品詳細画面に遷移する
  Widget _buildOneItem(Item item) {
    double screenWidth = MediaQuery.of(context).size.width;
    DateTime dateTime = item.createdAt.toDate();
    String formattedDate =
        '${dateTime.year}年${dateTime.month}月${dateTime.day}日';

    return GestureDetector(
      onTap: () {
        // 商品詳細画面に遷移
        Navigator.push(context, CupertinoPageRoute(
          builder: (context) {
            // 自分の商品なら編集可能な詳細画面に遷移
            return _userId == item.author
                ? const MyItemDetailPage()
                : const TakerItemDetailPage();
          },
        ));
      },
      child: Column(
        children: [
          Container(
            width: screenWidth / 3,
            height: screenWidth / 3 - 40,
            padding: const EdgeInsets.all(1.0),
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            child: Text(
              item.title,
              style: TextStyle(fontSize: 10),
            ),
          ),
          Container(
            child: Text(
              formattedDate,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  /// 商品一覧ページのbodyを生成する
  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _fetchItemsFromStore();
            });
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _buildOneItem(_items[index]);
            },
            itemCount: _items.length,
          )),
    );
  }

  /// 商品一覧ページのナビゲーションバーを生成する
  CupertinoNavigationBar _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
        middle: Text(widget.itemsListPageKind.title),
        trailing: CupertinoButton(
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            // 新規投稿画面に遷移
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) {
                return const RegisterItemPage();
              },
            ));
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildCupertinoNavigationBar(),
      child: _buildBody(),
    );
  }
}

/// 商品を表す
/// 属性は仮なので、必要があれば追加してください
class Item {
  // itemのID (FirestoreのドキュメントID)
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  // 投稿者のID
  final String author;
  final Timestamp createdAt;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.createdAt,
  });
}

/// なんの一覧を表示するか
enum ItemsListPageKind {
  allItems("全てのアイデア一覧"),
  myItems("投稿一覧"),
  likedItems("いいね一覧");

  final String title;
  const ItemsListPageKind(this.title);
}
