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

                    return context.go('/');
                  } on FirebaseAuthException catch (e) {
                    // ログインに失敗した場合
                    String message = '';
                    // エラーコード別処理
                    switch (e.code) {
                      case 'invalid-email':
                        message = 'メールアドレスが不正です。';
                        break;
                      case 'wrong-password':
                        message = 'パスワードが違います。';
                        break;
                      case 'user-disabled':
                        message = '指定されたユーザーは無効です。';
                        break;
                      case 'user-not-found':
                        message = '指定されたユーザーは存在しません。';
                        break;
                      case 'operation-not-allowed':
                        message = '指定されたユーザーはこの操作を許可していません。';
                        break;
                      case 'too-many-requests':
                        message = '複数回リクエストが発生しました。';
                        break;
                      case 'email-already-exists':
                        message = '指定されたメールアドレスは既に使用されています。';
                        break;
                      case 'internal-error':
                        message = '内部処理エラーが発生しました。';
                        break;
                      default:
                        message = '予期せぬエラーが発生しました。';
                    }

                    return alertDialog('ログインエラー', message, context);
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
