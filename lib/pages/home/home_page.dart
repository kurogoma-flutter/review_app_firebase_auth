import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_basic/components/dialog.dart';
import 'package:go_router/go_router.dart';

import '../review/create_review.dart';
import '../review/review_list.dart';
import '../user/user_profile.dart';

/// ページ仕様
/// 1. コレクションからリストを表示する
/// 2. ユーザーアイコン、商品名、レビュー内容（２行まで）、タイムスタンプ、削除ボタンがある
/// 3. タブ切り替えできる（ユーザーページと投稿ページ）

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  //TextStyleをあらかじめ統一しておく。
  //後から変更しやすい、コード量が減るメリットがある
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  //ウィジェットのリストを作成
  static const List<Widget> _navigationList = <Widget>[
    ReviewListPage(),
    CreateReview(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('レビュー投稿アプリ'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              var result = confirmDialog('認証チェック', 'ログアウトしますか？', context);
              if (result == 1) {
                // ログアウト => ログインへ遷移
                await FirebaseAuth.instance.signOut();
                return context.go('/login');
              }
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Center(
        child: _navigationList.elementAt(_selectedIndex), //n番目のウィジェットが呼び出される。
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: '投稿する',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_outlined),
            label: 'ユーザー',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped, //ボタンが押されたときに、_onItemTappedが実行される。このとき、indexの値は受け渡される。
      ),
    );
  }

  /// タップした時のウィジェット
  void _onItemTapped(int index) {
    //関数の作成
    setState(() {
      _selectedIndex = index; //_selectedIndexをindexと対応させる
    });
  }
}
