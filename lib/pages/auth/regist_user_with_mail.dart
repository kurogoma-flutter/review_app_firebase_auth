import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/dialog.dart';

/// ページ仕様
/// 1. メールアドレスとパスワードで登録できる ✔
/// 2. パスワードの非表示はオンオフできる
/// 3. ログイン画面に遷移できる ✔

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
                    newUserEmail = value;
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
                    newUserPassword = value;
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
                    // メール/パスワードでユーザー登録
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result = await auth.createUserWithEmailAndPassword(
                      email: newUserEmail,
                      password: newUserPassword,
                    );
                    setState(() {
                      infoText = "登録されました";
                    });

                    /// そのままログインしてHomeへ遷移
                    final UserCredential login = await auth.signInWithEmailAndPassword(
                      email: newUserEmail,
                      password: newUserPassword,
                    );
                    // ログインに成功した場合
                    final User user = login.user!;
                    setState(() {
                      infoText = "ログイン!";
                    });
                    // ホームに画面遷移
                    return context.go('/');
                  } catch (e) {
                    // 登録・ログインに失敗した場合
                    setState(() {
                      infoText = e.toString().replaceAll(RegExp(r'\[.*\] '), '');
                    });

                    return alertDialog('登録エラー', infoText, context);
                  }
                },
                child: const Text(
                  '新規登録',
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
                context.go('/login');
              },
              child: const Text('ログインはこちら'),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
