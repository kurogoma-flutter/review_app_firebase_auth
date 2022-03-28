import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyRegister(),
    );
  }
}

class MyRegister extends StatefulWidget {
  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
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
                } catch (e) {
                  // 登録に失敗した場合
                  setState(() {
                    infoText = e.toString();
                  });

                  ///  TODO: エラーダイアログ
                }
              },
              child: Text("登録"),
            ),
          ],
        ),
      ),
    );
  }
}
