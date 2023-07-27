import 'package:flutter/material.dart';

import 'package:Kuiz/pages/profile.dart';

import 'first_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int _selectedIndex = 0;
  List<Widget> pageList = [const HomePage(), const Profile()];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      return false;
    },
      child: Scaffold(
        body:
        IndexedStack(
         index: _selectedIndex,
         children: pageList,),
    
        bottomNavigationBar: BottomNavigationBar(
          
          elevation: 4,
          backgroundColor: Colors.lime.shade700,
          fixedColor: Colors.white60,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.quiz_sharp), label: 'Kuizet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard_sharp), label: 'Profili')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //Navigator.pushReplacement(context,  MaterialPageRoute(builder: ((_) => pageList.elementAt(index))));
  }
}
