import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// ページ仕様
/// 1. 表示専用画面
/// 2. 商品名とレビュー内容（全文）が表示されているだけ

class ReviewDetail extends StatefulWidget {
  const ReviewDetail({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  // 日付フォーマット
  DateFormat dateFormat = DateFormat('yyyy/MM/dd');

  List<DocumentSnapshot> _review = [];
  _getReviewData() async {
    var snapshot = await FirebaseFirestore.instance.collection('reviewList').where('id', isEqualTo: widget.id).limit(1).get();
    setState(() {
      _review = snapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await _getReviewData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規レビュー"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "対象商品",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.only(
                top: 15,
                left: 20,
              ),
              height: 60,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0.5,
                    blurRadius: 10.0,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Text(_review.isEmpty ? '...' : _review[0]['itemName']),
            ),
            const SizedBox(height: 20),
            const Text(
              "レビューコメント",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              width: 350,
              height: 180,
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0.5,
                    blurRadius: 10.0,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Text(
                _review.isEmpty ? '...' : _review[0]['content'],
                maxLines: 5,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(dateFormat.format(_review[0]['createAt'].toDate()).toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
