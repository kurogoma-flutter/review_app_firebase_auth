import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/dialog.dart';

/**
 * ページ仕様
 * 1. メールアドレスとパスワードで登録できる
 * 2. パスワードの非表示はオンオフできる
 * 3. ログイン画面に遷移できる
 */
class RegistUserWithMail extends StatefulWidget {
  const RegistUserWithMail({Key? key}) : super(key: key);

  @override
  State<RegistUserWithMail> createState() => _RegistUserWithMailState();
}

class _RegistUserWithMailState extends State<RegistUserWithMail> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // エラーメッセージなどの格納先
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            /// TODO: バリデーション設定
            TextFormField(
              // テキスト入力のラベルを設定
              decoration: const InputDecoration(labelText: "メールアドレス"),
              onChanged: (String value) {
                setState(() {
                  newUserEmail = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "パスワード（６文字以上）"),
              // パスワードが見えないようにする
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  newUserPassword = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // メール/パスワードでユーザー登録
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final UserCredential result = await auth.createUserWithEmailAndPassword(
                    email: newUserEmail,
                    password: newUserPassword,
                  );
                  setState(() {
                    infoText = "登録されました";
                  });

                  /// TODO: ログインに遷移 or そのままログインしてHomeへ遷移
                } catch (e) {
                  // 登録に失敗した場合
                  setState(() {
                    infoText = e.toString().replaceAll(RegExp(r'\[.*\] '), '');
                  });

                  return errorDialog('ログインエラー', infoText, context);
                }
              },
              child: const Text("登録"),
            ),
          ],
        ),
      ),
    );
  }
}
