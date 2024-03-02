import 'package:flutter/cupertino.dart';
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
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 80,
        backgroundColor: Color.fromARGB(255, 232, 255, 214),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
                _currentIndex == 0
                    ? 'assets/images/mypage/mypage/search_on.png'
                    : 'assets/images/mypage/mypage/search_off.png',
                width: 30,
                height: 30,
                fit: BoxFit.fill),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? 'assets/images/mypage/mypage/home_on.png'
                  : 'assets/images/mypage/mypage/home_off.png',
              width: 30,
              height: 30,
              fit: BoxFit.fill,
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
                _currentIndex == 2
                    ? 'assets/images/mypage/mypage/heart_on.png'
                    : 'assets/images/mypage/mypage/heart_off.png',
                width: 30,
                height: 30,
                fit: BoxFit.fill),
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
