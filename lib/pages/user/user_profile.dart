import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/dialog.dart';

/// ページ仕様
/// 1. ユーザーID、アドレス、更新日時を表示
/// 2. パスワード再設定ができる
/// 3. 退会処理（ユーザー削除）ができる => 新規登録画面へ遷移

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var user;
  @override
  void initState() {
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (error) {
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            height: size.height * 0.5,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleAndText(title: 'ユーザーID', subtitle: user.uid),
                TitleAndText(title: 'メールアドレス', subtitle: user.email),
                TitleAndText(title: '登録日時', subtitle: user.metadata.creationTime.toString()),
                TitleAndText(title: '最終ログイン', subtitle: user.metadata.lastSignInTime.toString()),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            height: size.height * 0.08,
            width: size.width * 0.5,
            child: ElevatedButton(
              onPressed: () async {
                // 再発行処理
                var result = await sendPasswordResetEmail(user.email);
                if (result == 'success') {
                  // 成功したダイアログ
                  alertDialog('確認ダイアログ', '登録したメールアドレスに再設定用のメールを送信しました。', context);
                } else {
                  // 失敗したダイアログ
                  alertDialog('エラーダイアログ', '送信に失敗しました。', context);
                }
              },
              child: const Text(
                'パスワード再設定',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shape: const StadiumBorder(),
                elevation: 10,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.08,
            width: size.width * 0.5,
            child: TextButton(
              onPressed: () async {
                // 退会処理
                var result = confirmDialog('確認ダイアログ', '削除してもよろしいですか？', context);
                if (result == 1) {
                  await FirebaseAuth.instance.currentUser?.delete();
                  context.go('/login');
                }
              },
              child: const Text(
                '退会処理',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 共通化ウィジェット
class TitleAndText extends StatelessWidget {
  const TitleAndText({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
