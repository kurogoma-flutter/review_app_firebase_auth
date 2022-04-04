import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../components/dialog.dart';

class ReviewListPage extends StatefulWidget {
  const ReviewListPage({Key? key}) : super(key: key);

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  DateFormat dateFormat = DateFormat('yyyy/MM/dd');

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
          var result = await confirmDialog(
            '確認ダイアログ',
            '削除してもよろしいですか？',
            context,
          );
          if (result == 1) {
            // 削除
            await FirebaseFirestore.instance.collection('reviewList').doc(documentId).delete();
          }
        },
        icon: const Icon(Icons.delete_forever),
        iconSize: 28,
      );
    } else {
      // 空要素
      return const SizedBox();
    }
  }

  final Stream<QuerySnapshot> _reviewStream = FirebaseFirestore.instance.collection('reviewList').orderBy('createAt', descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(dateFormat.format(data['createAt'].toDate()).toString()),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      ),
                    ],
                  ),
                  onTap: () {
                    context.go('/reviewDetail/${data['id']}');
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
