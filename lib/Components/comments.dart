import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comments({super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(5)
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: TextStyle(color: Colors.lightBlueAccent[200]),),
          Row(
            children: [
              Text(user, style: const TextStyle(color: Colors.grey),),
              const Text(" . "),
              Text(time, style: TextStyle(color: Colors.blueGrey[400]),),
            ],
          ),
        ],
      ),
    );
  }
}
