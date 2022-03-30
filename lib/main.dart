import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_basic/pages/review/create_review.dart';
import 'package:go_router/go_router.dart';

import 'pages/auth/mail_login_page.dart';
import 'pages/auth/regist_user_with_mail.dart';
import 'pages/home/home_page.dart';
import 'pages/review/create_review.dart';
import 'pages/review/review_detail.dart';
import 'pages/user/user_profile.dart';

Future<void> main() async {
  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: 'レビューアプリ',
      );

  /// ルーティング設定
  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const AuthHomePage(),
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const MailLoginPage(),
      ),
      GoRoute(
        path: '/createUser',
        builder: (BuildContext context, GoRouterState state) => const RegistUserWithMail(),
      ),
      GoRoute(
        path: '/user',
        builder: (BuildContext context, GoRouterState state) => const UserProfile(),
      ),
      GoRoute(
        path: '/createReview',
        builder: (BuildContext context, GoRouterState state) => const CreateReview(),
      ),
      GoRoute(
        path: '/reviewDetail/:id',
        builder: (context, state) {
          // パスパラメータの値を取得するには state.params を使用
          final int id = int.parse(state.params['id']!);
          return ReviewDetail(id: id);
        },
      ),
    ],
    initialLocation: '/',
  );
}

class AuthHomePage extends StatelessWidget {
  const AuthHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '認証チェック',
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // ログイン情報の取得中（ローディング）
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('取得中...'),
              );
            }
            // データがある => サインイン済み => Homeへ
            if (snapshot.hasData) {
              return const HomePage();
            }
            // サインインされていない場合、ログインページを表示
            return const MailLoginPage();
          },
        ),
      );
}
