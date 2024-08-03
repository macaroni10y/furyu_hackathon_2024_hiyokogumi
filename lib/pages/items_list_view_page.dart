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
  /// 自分の商品一覧、いいね一覧、全ての商品一覧のどれかによって取得する商品一覧が異なる
  Future<void> _fetchItemsFromStore() async {
    FirebaseFirestore.instance.collection("idea_items").get().then(
      (querySnapshot) async {
        print("Successfully completed");
        _items = await Future.wait(querySnapshot.docs.map((docSnapshot) async {
          var data = docSnapshot.data();
          // いいね数を取得
          var hoge = await docSnapshot.reference.collection("likes").get();
          print(data);
          return Item(
              id: docSnapshot.id,
              title: data["title"],
              description: data["description"],
              imageUrl: data["imageUrl"],
              likedUserIdList: hoge.docs.map((e) => e.id).toList(),
              author: data["author"],
              createdAt: data["timestamp"]);
        }));
        if (widget.itemsListPageKind == ItemsListPageKind.allItems) {
          setState(() {});
          return;
        }
        if (widget.itemsListPageKind == ItemsListPageKind.myItems) {
          _items = _items.where((item) => item.author == _userId).toList();
          setState(() {});
          return;
        }
        if (widget.itemsListPageKind == ItemsListPageKind.likedItems) {
          _items = _items
              .where((item) => item.likedUserIdList.contains(_userId))
              .toList();
          setState(() {});
          return;
        }
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
    var textGreen = Color.fromARGB(255, 21, 147, 0);
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        // 商品詳細画面に遷移
        await Navigator.push(context, CupertinoPageRoute(
          builder: (context) {
            // 自分の商品なら編集可能な詳細画面に遷移
            return _userId == item.author
                ? MyItemDetailPage(item: item)
                : TakerItemDetailPage(item: item);
          },
        ));
        // 修正後にリフレッシュ
        setState(() {
          _fetchItemsFromStore();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.white, width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              margin: const EdgeInsets.all(1.0),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                width: screenWidth / 2.5,
                height: screenWidth / 3.6,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12, color: textGreen),
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.heart_fill,
                      color: Color.fromARGB(255, 21, 147, 0),
                      size: 12,
                    ),
                    Text(
                      textAlign: TextAlign.left,
                      '${item.likedUserIdList.length}',
                      style: TextStyle(fontSize: 14, color: textGreen),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 商品一覧ページのbodyを生成する
  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/createNewAccount/bk.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
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
            border: const Border(
              top: BorderSide(
                  color: Color.fromRGBO(240, 255, 222, 1.0), width: 3.0),
              left: BorderSide(
                  color: Color.fromRGBO(240, 255, 222, 1.0), width: 3.0),
              right: BorderSide(
                  color: Color.fromRGBO(240, 255, 222, 1.0), width: 3.0),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(33),
              topRight: Radius.circular(33),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      image:
                          AssetImage("assets/images/createNewAccount/ロゴ.png")),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _fetchItemsFromStore();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.all(4),
                              child: const Image(
                                  width: 150,
                                  height: 50,
                                  image: AssetImage(
                                      "assets/images/mypage/mypage/mypage_btn_on.png")),
                              onPressed: () async {
                                // 新規投稿画面に遷移
                                await Navigator.push(context,
                                    CupertinoPageRoute(
                                  builder: (context) {
                                    return const RegisterItemPage();
                                  },
                                ));
                                // 新規投稿後にリフレッシュ
                                setState(() {
                                  _fetchItemsFromStore();
                                });
                              },
                            ),
                            Flexible(
                              child: GridView.builder(
                                padding: const EdgeInsets.all(4),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildOneItem(_items[index]);
                                },
                                itemCount: _items.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 商品一覧ページのナビゲーションバーを生成する
  CupertinoNavigationBar _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
        middle: Text(widget.itemsListPageKind.title),
        backgroundColor: CupertinoColors.activeGreen,
        trailing: CupertinoButton(
          child: const Icon(CupertinoIcons.add),
          onPressed: () async {
            // 新規投稿画面に遷移
            await Navigator.push(context, CupertinoPageRoute(
              builder: (context) {
                return const RegisterItemPage();
              },
            ));
            // 新規投稿後にリフレッシュ
            setState(() {
              _fetchItemsFromStore();
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // navigationBar: _buildCupertinoNavigationBar(),
      body: _buildBody(),
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
  final List<String> likedUserIdList;
  // 投稿者のID
  final String author;
  final Timestamp createdAt;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.likedUserIdList,
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
