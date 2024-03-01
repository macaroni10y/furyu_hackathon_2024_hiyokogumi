import 'package:flutter/cupertino.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/hoge.dart';

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

  /// firestore商品一覧を取得する
  /// 今は仮で固定のデータを返している
  /// TODO: 引数を取って、全て or 自分の商品 or いいねした商品を取得するようにする
  void fetchItemsFromStore() {
    _items = switch (widget.itemsListPageKind) {
      ItemsListPageKind.myItems => [
          Item(
            id: '1',
            name: 'item1',
            description: 'description1',
            imageUrl: 'https://placehold.jp/150x150.png',
            authorId: 'author1',
            createdAt: DateTime.now(),
          ),
        ],
      ItemsListPageKind.allItems => [
          Item(
            id: '1',
            name: 'item1',
            description: 'description1',
            imageUrl: 'https://placehold.jp/150x150.png',
            authorId: 'author1',
            createdAt: DateTime.now(),
          ),
          Item(
            id: '1',
            name: 'item1',
            description: 'description1',
            imageUrl: 'https://placehold.jp/150x150.png',
            authorId: 'author1',
            createdAt: DateTime.now(),
          ),
        ],
      ItemsListPageKind.likedItems => [
          Item(
            id: '1',
            name: 'item1',
            description: 'description1',
            imageUrl: 'https://placehold.jp/150x150.png',
            authorId: 'author1',
            createdAt: DateTime.now(),
          ),
          Item(
            id: '1',
            name: 'item1',
            description: 'description1',
            imageUrl: 'https://placehold.jp/150x150.png',
            authorId: 'author1',
            createdAt: DateTime.now(),
          ),
          Item(
            id: '1',
            name: 'item1',
            description: 'description1',
            imageUrl: 'https://placehold.jp/150x150.png',
            authorId: 'author1',
            createdAt: DateTime.now(),
          ),
        ],
    };
  }

  @override
  void initState() {
    super.initState();
    fetchItemsFromStore();
  }

  /// 商品画像のURLを受け取って、一覧の1つに表示するWidgetを返す。
  /// TODO 商品1つをどのように表示するかのデザインが出来上がったら、実装する
  /// 画像をタップしたら商品詳細画面に遷移する
  Widget _buildOneItem(String imageUrl) {
    return GestureDetector(
      onTap: () {
        // 商品詳細画面に遷移
        Navigator.push(context, CupertinoPageRoute(
          builder: (context) {
            return Hoge(); // TODO: 商品詳細画面に遷移するようにする
          },
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(1.0),
        child: Image.network(imageUrl),
      ),
    );
  }

  /// 商品一覧ページのbodyを生成する
  Widget _buildBody() {
    return Center(
        child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _buildOneItem(_items[index].imageUrl);
      },
      itemCount: _items.length,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          CupertinoNavigationBar(middle: Text(widget.itemsListPageKind.title)),
      child: _buildBody(),
    );
  }
}

/// 商品を表す
/// 属性は仮なので、必要があれば追加してください
class Item {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String authorId;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.authorId,
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
