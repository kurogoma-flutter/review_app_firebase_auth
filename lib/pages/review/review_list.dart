import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewListPage extends StatefulWidget {
  const ReviewListPage({Key? key}) : super(key: key);

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  String uid = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      uid = FirebaseAuth.instance.currentUser?.uid ?? 'noData';
    });
  }

  /// リストのカードがログイン中ユーザーのものか判別する
  _deleteIcon(documentId, documentUserId) {
    // 引数と一致したら表示する
    if (uid == documentUserId) {
      return IconButton(
        onPressed: () async {
          var result = await _confirmDialog('確認ダイアログ', '削除してもよろしいですか？');
          if (result == 1) {
            // 削除
            await FirebaseFirestore.instance.collection('reviewList').doc(documentId).delete();
          }
        },
        icon: const Icon(Icons.delete_forever),
        iconSize: 28,
      );
    } else {
      return IconButton(
        // 一旦デバッグ
        onPressed: () {
          print(documentUserId);
          print(uid);
        },
        icon: const Icon(
          Icons.star,
          color: Colors.white,
        ),
        iconSize: 28,
      );
    }
  }

  _confirmDialog(String title, String text) async {
    var result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(0),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(1),
            ),
          ],
        );
      },
    );
    return result;
  }

  final Stream<QuerySnapshot> _reviewStream = FirebaseFirestore.instance.collection('reviewList').orderBy('id', descending: false).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('レビュー一覧'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _reviewStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text(
              'ERROR!! Something went wrong',
              style: TextStyle(fontSize: 30),
            ));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(
                "Loading...",
                style: TextStyle(fontSize: 30),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black45),
                  ),
                  child: ListTile(
                    leading: Text(data['id'].toString()),
                    title: Text(
                      data['itemName'] ?? 'データがありません',
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(data['content'] ?? 'データがありません'),
                    trailing: _deleteIcon(document.id, data['uid']),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(uid);
        },
      ),
    );
  }
}
