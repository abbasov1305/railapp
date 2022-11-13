import 'package:flutter/material.dart';
import '../widgets/add_widget.dart';
import '../widgets/user_widget.dart';
import '../widgets/main_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Widget _selectedWidget = MainWidget();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        _selectedWidget = MainWidget();
        break;
      case 1:
        _selectedWidget = AddWidget();
        break;
      case 2:
        _selectedWidget = UserWidget();
        break;
      default:
        _selectedWidget = MainWidget();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _selectedWidget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        elevation: 0,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white10,
        type: BottomNavigationBarType.shifting,
        selectedIconTheme: IconThemeData(size: 32),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.control_point),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '',
          ),
        ],
      ),
    );
  }
}
