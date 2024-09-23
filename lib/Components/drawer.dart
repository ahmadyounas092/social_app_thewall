import 'package:flutter/material.dart';
import 'package:the_wall_app/Components/my_list_tile.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onProfileTap;
  final void Function()? onLogout;
  const MyDrawer({super.key, required this.onProfileTap, required this.onLogout});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade800,
      child: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width * 1,
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const DrawerHeader(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 64,
                    )),
                MyListTile(
                  icon: Icons.home,
                  text: "H O M E",
                  onTap: ()=> Navigator.pop(context),
                ),
                MyListTile(
                    icon: Icons.person,
                    text: "P R O F I L E",
                    onTap: widget.onProfileTap),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: MyListTile(
                  icon: Icons.logout,
                  text: "L O G O U T",
                  onTap: widget.onLogout),
            ),
          ],
        ),
      ),
    );
  }
}
