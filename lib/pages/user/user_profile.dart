import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
/**
 * ページ仕様
 * 1. ユーザーID、アドレス、更新日時を表示
 * 2. パスワード再設定ができる
 * 3. 退会処理（ユーザー削除）ができる => 新規登録画面へ遷移
 */

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

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
