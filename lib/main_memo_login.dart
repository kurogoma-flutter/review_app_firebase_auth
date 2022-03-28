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
            TextFormField(
              decoration: InputDecoration(labelText: "メールアドレス"),
              onChanged: (String value) {
                setState(() {
                  loginUserEmail = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "パスワード"),
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
                } catch (e) {
                  // ログインに失敗した場合
                  setState(() {
                    infoText = e.toString();
                  });
                }
              },
              child: Text("ログイン"),
            ),
            const SizedBox(height: 8),
            Text(infoText),
          ],
        ),
      ),
    );
  }
}
