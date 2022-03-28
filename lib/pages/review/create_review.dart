import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
/**
 * ページ仕様
 * 1. 商品名・レビュー内容・ユーザー名を入れて登録できる
 * 2. 登録は、上記3つに加えて「UID」と「タイムスタンプ」と「isBanned」の3つを加えて登録する
 * 3. 商品名はコレクションからセレクトボックスを作成する
 * 4. isBannedはtrueの場合非表示になる。とりあえずfirestore上で操作するだけ。
 * 5. 画面幅に収まる範疇で文字制限をする（200文字くらい）
 */

class CreateReview extends StatelessWidget {
  const CreateReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('プロフィール'),
      ),
      body: const Center(
        child: Text('プロフィール画面'),
      ),
    );
  }
}
