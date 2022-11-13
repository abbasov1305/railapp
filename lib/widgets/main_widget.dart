import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rail_app/providers/base_provider.dart';
import 'package:rail_app/widgets/created_time_widget.dart';
import 'dart:math';

class MainWidget extends StatefulWidget {
  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  List? data;
  int likes = 0;
  int dislikes = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    QuerySnapshot _docs = await FirebaseFirestore.instance
        .collection('texts')
        .orderBy('createdAt', descending: true)
        .get();
    setState(() {
      data = _docs.docs;
    });
  }

  void getUser(String imageUrl, String username) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 60,
        ),
        content: Text(
          '@$username',
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.flip_to_back_rounded),
              color: Theme.of(context).primaryColor),
        ],
        //backgroundColor: Colors.transparent,
      ),
    );
  }

  void reactToPost(bool bLiked, String postId, int likes, int dislikes,
      List reactedUsers) async {
    String userId = await FirebaseAuth.instance.currentUser!.uid;

    if (reactedUsers.contains(userId)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'you have been already reacted to this post',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ));
      return;
    }

    if (bLiked)
      likes += 1;
    else
      dislikes += 1;

    reactedUsers.add(userId);

    try {
      await FirebaseFirestore.instance.collection('texts').doc(postId).update({
        'likes': likes,
        'dislikes': dislikes,
        'reactedUsers': reactedUsers.toList(),
      });

      //print(reactedUsers.toString());
      getData();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return getData();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: data == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) => Container(
                  alignment: Alignment.topCenter,
                  child: Dismissible(
                    key: ValueKey(index),
                    confirmDismiss: (direction) async {
                      reactToPost(
                        direction == DismissDirection.startToEnd,
                        data![index].id,
                        data![index]['likes'],
                        data![index]['dislikes'],
                        data![index]['reactedUsers'],
                      );
                      return false;
                    },
                    background: Container(
                      //alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.mood_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          Text(
                            data![index]['likes'].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      padding: EdgeInsets.fromLTRB(0, 0, 32, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            data![index]['dislikes'].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.mood_bad_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(data![index]['uid'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            final _userData = snapshot.data;

                            return GestureDetector(
                              onTap: () => getUser(
                                  _userData['imageUrl'], _userData['username']),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage: NetworkImage(
                                      _userData!['imageUrl'],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(_userData['username']),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(data![index]['text']),
                        CreatedTime(data![index]['createdAt']),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          height: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
