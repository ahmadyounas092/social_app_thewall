import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/Components/comment_button.dart';
import 'package:the_wall_app/Components/comments.dart';
import 'package:the_wall_app/Components/delete_button.dart';
import 'package:the_wall_app/Components/like_button.dart';

import '../helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final String time;

  const WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentController = TextEditingController();
  int commentsCount = 0;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    fetchCommentsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // group of texts (messages + user Email)
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // messagae
                  Row(
                    children: [
                      Text(
                        widget.message,
                        style: TextStyle(color: Colors.purpleAccent[200]),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.blueGrey.shade400),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.blueGrey[400]),
                  ),
                ],
              ),
              // delete button
              if (widget.user == currentUser.email)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: DeleteButton(onTap: deletePost),
                ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Text(widget.likes.length.toString()),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  CommentButton(onTap: showCommentDailog),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Text(commentsCount.toString()),
                ],
              ),
            ],
          ),
          // displaying the comments
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // show the loading circle if it has no data
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comments(
                        text: commentData["CommentText"],
                        user: commentData["CommentedBy"],
                        time: formatDate(commentData["CommentTime"]));
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  void showCommentDailog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                "Add Comment",
                style: TextStyle(color: Colors.white),
              ),
              content: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _commentController,
                decoration: InputDecoration(
                    hintText: "Write a comment..",
                    hintStyle: TextStyle(color: Colors.grey[600])),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _commentController.clear();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () => {
                          addComment(_commentController.text),
                          _commentController.clear(),
                          Navigator.pop(context)
                        },
                    child: const Text(
                      "Post",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));
  }

  void fetchCommentsCount() {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        commentsCount = snapshot.size; // Update comments count
      });
    });
  }

  // to delete a post
  void deletePost() {
    // show a dailog box for the confrimation of deleting the post
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Are you sure to delete this post?"),
            actions: [
              // cancel button
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              // delete button
              TextButton(
                  onPressed: () async {
                    // delete the comments form the firebase firestore,
                    Navigator.pop(context);
                    final commentDocs = await FirebaseFirestore.instance
                        .collection("User Post")
                        .doc(widget.postId)
                        .collection("Comments")
                        .get();
                    for (var doc in commentDocs.docs) {
                      FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .doc(doc.id)
                          .delete();
                    }
                    FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .delete()
                        .then((value) => print("Post Deleted"))
                        .catchError(
                            (error) => print("Failed to delete post: $error"));
                    Navigator.pop(context);
                  },
                  child: Text("Delete"))
            ],
          );
        });
  }
}
