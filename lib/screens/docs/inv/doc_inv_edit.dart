import 'package:flutter/material.dart';

class DocInvAdd extends StatefulWidget {
  final String invType;

  const DocInvAdd({super.key, required this.invType});

  @override
  State<DocInvAdd> createState() => _DocInvAddState();
}

class _DocInvAddState extends State<DocInvAdd> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.invType),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.info_outline_rounded, color: tabIndex == 0 ? Colors.white : Colors.white30), label: "Данные"),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add, color: tabIndex == 1 ? Colors.white : Colors.white30), label: "Товары"),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check, color: tabIndex == 2 ? Colors.white : Colors.white30), label: "Список"),
        ],
        onTap: (value) {
          tabIndex = value;
          setState(() {});
        },
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: tabIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
