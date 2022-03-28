import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
/**
 * ページ仕様
 * 1. 表示専用画面
 * 2. 商品名とレビュー内容（全文）が表示されているだけ
 */

class ReviewDetail extends StatelessWidget {
  const ReviewDetail({Key? key}) : super(key: key);

  // TODO: パラメーターのIDを取得してデータを取得

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

