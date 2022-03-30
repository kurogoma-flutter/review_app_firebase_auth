import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/dialog.dart';

/// ページ仕様
/// 1. メールアドレスとパスワードでログインできる ✔
/// 2. パスワードの非表示はオンオフできる
/// 3. 新規登録画面に遷移できる ✔ ️️

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
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'メールアドレス',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction, // 入力時バリデーション
                cursorColor: Colors.blueAccent,
                decoration: const InputDecoration(
                  focusColor: Colors.red,
                  labelText: 'メールアドレス',
                  hintText: 'sample@gmail.com',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "入力してください";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'パスワード',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction, // 入力時バリデーション
                cursorColor: Colors.blueAccent,
                obscureText: true,
                decoration: const InputDecoration(
                  focusColor: Colors.red,
                  labelText: 'パスワード',
                  hintText: 'Enter Your Password',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "入力してください";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
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
                child: const Text(
                  'ログイン',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: const Text('新規登録はこちら'),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
