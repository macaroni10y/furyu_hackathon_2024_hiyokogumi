import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/chat_page.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/items_list_view_page.dart';

/// 下タブを定義したベースとなるページ
/// 下タブの切り替えによって表示するページを切り替える
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  // 下タブで遷移するページのリスト
  final List<Widget> _pages = <Widget>[
    const ItemsListViewPage(itemsListPageKind: ItemsListPageKind.allItems),
    const ItemsListViewPage(itemsListPageKind: ItemsListPageKind.myItems),
    const ItemsListViewPage(itemsListPageKind: ItemsListPageKind.likedItems),
    // 固定でチャットページを追加 TODO 動的にIDを指定してチャットページを追加する
    ChatPage(
        item: Item(
            id: "YqtxNyFDofieaj7HnyiI",
            title: "kitajimaTest",
            description: "kitajimaTest",
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/furyu-hackathon-hiyokogumi.appspot.com/o/images%2FUMY2qtaLsHXMoiFu2HUk7ispz3E3%2F2024-03-02%2004:06:26.689629.png?alt=media&token=9a440458-b87f-414f-a510-dd814e008623",
            author: "UMY2qtaLsHXMoiFu2HUk7ispz3E3",
            createdAt: Timestamp.now()),
        candidateId: "hogehoge"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: '全てのアイデア',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: '自分のアイデア',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'いいね一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble),
            label: 'チャット',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _pages[index];
          },
        );
      },
    );
  }
}
