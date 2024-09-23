import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/Components/drawer.dart';
import 'package:the_wall_app/Components/text_field.dart';
import 'package:the_wall_app/Components/wall_post.dart';
import 'package:the_wall_app/Pages/profile_page.dart';

import '../helper/helper_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "The Wall CodeDB",
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onLogout: signOut,
      ),
      body: Column(
        children: [
          // the wall
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post['TimeStamp']),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          // for posting the message
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                    child: MyTextField(
                  controller: textController,
                  hintText: "Write something on the wall",
                  obsecureText: false,
                )),
                IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up,)),
              ],
            ),
          ),
          Text(
            "Logged in as:${currentUser.email!}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    setState(() {
      textController.clear();
    });
  }
  void goToProfilePage(){
    Navigator.pop(context);
    
    // for the profile page
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=> const ProfilePage()));
  }
}
