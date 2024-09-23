import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const MyListTile({super.key, required this.icon, required this.text, required this.onTap});

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon, color: Colors.white,),
      onTap: widget.onTap,
      title: Text(widget.text, style: const TextStyle(color: Colors.white),),
    );
  }
}
