import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/**
 * ページ仕様
 * 1. コレクションからリストを表示する
 * 2. ユーザーアイコン、商品名、レビュー内容（２行まで）、タイムスタンプ、削除ボタンがある
 * 3. タブ切り替えできる（ユーザーページと投稿ページ）
 */

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('レビュー投稿アプリ'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                /// TODO: ログインへ画面遷移 + 元データ破棄
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Text('ホーム画面'),
      ),
    );
  }
}
