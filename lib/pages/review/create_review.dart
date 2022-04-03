import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_basic/components/dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// ページ仕様
/// 1. 商品名・レビュー内容・ユーザー名を入れて登録できる
/// 2. 登録は、上記3つに加えて「UID」と「タイムスタンプ」と「isBanned」の3つを加えて登録する
/// 3. 商品名はコレクションからセレクトボックスを作成する
/// 4. isBannedはtrueの場合非表示になる。とりあえずfirestore上で操作するだけ。
/// 5. 画面幅に収まる範疇で文字制限をする（200文字くらい）

class CreateReview extends StatefulWidget {
  const CreateReview({Key? key}) : super(key: key);

  @override
  State<CreateReview> createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview> {
  // レビュー本文
  String _content = '';
  // セレクトボックス用のリスト（Firebaseのにマスターあり）
  List<DocumentSnapshot> _documentList = [];
  List<String> itemList = [];
  String _selectedItem = '';
  _getDataList() async {
    var snapshot = await FirebaseFirestore.instance.collection('itemList').get();
    setState(() {
      _documentList = snapshot.docs;
    });
    _documentList.map((doc) => itemList.add(doc['name'])).toList();
  }

  // Firestoreへの保存処理
  DateFormat dateFormat = DateFormat('yyyy/MM/dd');
  DateTime today = DateTime.now();
  List<DocumentSnapshot> _idList = [];
  int _lastId = 0;
  _getLastId() async {
    var snapshotId = await FirebaseFirestore.instance.collection('reviewList').orderBy('id', descending: true).limit(1).get();
    setState(() {
      _idList = snapshotId.docs;
    });
    _lastId = _idList[0]['id'] + 1;
  }

  _storeReviewList() async {
    await FirebaseFirestore.instance.collection('reviewList').add({
      'id': _lastId,
      'isBanned': false,
      'itemName': _selectedItem,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'content': _content,
      'createAt': today,
    });
  }

  List<DropdownMenuItem<String>> items = [];
  @override
  void initState() {
    super.initState();
    Future(() async {
      await _getDataList();
      for (int i = 0; i < itemList.length; i++) {
        items.add(DropdownMenuItem(value: itemList[i], child: Center(child: Text(itemList[i]))));
      }
      _selectedItem = itemList.isNotEmpty ? itemList[0] : '';
      // LastId取得
      await _getLastId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "商品を選択",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(10),
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey,
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
                child: DropdownButton(
                  isExpanded: true,
                  underline: Container(color: Colors.transparent),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  value: _selectedItem,
                  items: items,
                  onChanged: (value) {
                    setState(() {
                      _selectedItem = value.toString();
                      print(_selectedItem);
                    });
                  },
                ),
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
                child: TextField(
                  enabled: true,
                  // 入力数
                  maxLength: 200,
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  obscureText: false,
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {
                      _content = value;
                    });
                  },
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 30),
                  height: 60,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 10.0,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      var result = await confirmDialog('確認ダイアログ', '登録してもよろしいですか？', context);
                      if (result == 1) {
                        await _storeReviewList();
                      }
                      // 一覧へ画面遷移
                      context.go('/home');
                    },
                    child: const Text(
                      '投稿する',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF0033FF),
                      onPrimary: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
