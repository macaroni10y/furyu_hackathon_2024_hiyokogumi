import 'package:flutter/cupertino.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/fuga.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/hoge.dart';
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
    const Hoge(),
    const Fuga(),
    const ItemsListViewPage(itemsListPageKind: ItemsListPageKind.allItems),
    const ItemsListViewPage(itemsListPageKind: ItemsListPageKind.myItems),
    const ItemsListViewPage(itemsListPageKind: ItemsListPageKind.likedItems),
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
            label: 'Hoge',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Fuga',
          ),
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
