import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/screens/home/add_post.dart';
import 'package:insta_clone/screens/home/profile.dart';
import 'package:insta_clone/screens/home/search.dart';
import 'package:provider/provider.dart';

import 'feed.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late PageController pageController;
  int _selectedIndex = 0;
  void _changeIndex(int index) {
    setState(() => _selectedIndex = index );
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
    addData();
    pageController = PageController();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() => _selectedIndex = page);
  }

  static const pageItems = [
    Feed(),
    Search(),
    AddPost(),
    Center(child: Text('notification')),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: pageItems,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _changeIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
