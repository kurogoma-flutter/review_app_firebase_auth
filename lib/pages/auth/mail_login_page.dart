import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/dialog.dart';

/**
 * ページ仕様
 * 1. メールアドレスとパスワードでログインできる
 * 2. パスワードの非表示はオンオフできる
 * 3. 新規登録画面に遷移できる
 */

class MailLoginPage extends StatefulWidget {
  const MailLoginPage({Key? key}) : super(key: key);

  @override
  State<MailLoginPage> createState() => _MailLoginPageState();
}

class _MailLoginPageState extends State<MailLoginPage> {
  // エラーメッセージなどの格納先
  String infoText = "";
  // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            /// TODO: バリデーション設定
            TextFormField(
              decoration: const InputDecoration(labelText: "メールアドレス"),
              onChanged: (String value) {
                setState(() {
                  loginUserEmail = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "パスワード"),
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  loginUserPassword = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // メール/パスワードでログイン
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final UserCredential result = await auth.signInWithEmailAndPassword(
                    email: loginUserEmail,
                    password: loginUserPassword,
                  );
                  // ログインに成功した場合
                  final User user = result.user!;
                  setState(() {
                    infoText = "ログイン!";
                  });

                  /// TODO: 画面遷移処理 + 元画面破棄
                } catch (e) {
                  // ログインに失敗した場合
                  setState(() {
                    infoText = e.toString().replaceAll(RegExp(r'\[.*\] '), '');
                  });

                  return errorDialog('ログインエラー', infoText, context);
                }
              },
              child: const Text("ログイン"),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: const Text('新規登録はこちら'),
            )
          ],
        ),
      ),
    );
  }
}
