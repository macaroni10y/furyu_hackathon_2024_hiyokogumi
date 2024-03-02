import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:furyu_hackathon_2024_hiyokogumi/pages/items_list_view_page.dart';

import 'chat_page.dart';

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
    ChatPage(
        item: Item(
            author: 'A5OBEVprVAQbYeFqg8vxjAJku5V2',
            id: '0njGYByLeIDWLzQ0g2bJ',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/furyu-hackathon-hiyokogumi.appspot.com/o/images%2FA5OBEVprVAQbYeFqg8vxjAJku5V2%2F2024-03-02%2012%3A45%3A01.432043.png?alt=media&token=4b2b5315-f466-4a0a-9f6c-fecf876ea42b',
            title: '感染対策（青色）',
            description: 'コロナ禍での感染対策についてのポスターイメージです。コンペに間に合わなかったため、供養します。',
            likedUserIdList: [],
            createdAt: Timestamp.now()),
        candidateId: 'TJnjz24VNng3VkS8CGUGYUkX9QD3'),
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
          BottomNavigationBarItem(
            icon: Image.asset(
                _currentIndex == 3
                    ? 'assets/images/mypage/mypage/fukidasi_on.png'
                    : 'assets/images/mypage/mypage/fukidasi_off.png',
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
