import 'package:digital_agenda/pages/components/colors.dart';
import 'package:flutter/material.dart';
import '../gorevler/gorevler_sayfasi.dart';
import '../notlar/notes_page.dart';
import '../takvim/takvim.dart';

class MenuSayfasi extends StatefulWidget {
  const MenuSayfasi({Key? key}) : super(key: key);

  @override
  MenuSayfasiState createState() => MenuSayfasiState();
}

class MenuSayfasiState extends State<MenuSayfasi> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const NotlarSayfasi(),
    const Takvim(),
    const TasksPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 70,
        decoration: BoxDecoration(
          color: ColorUtility.menuBarColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavigationBarItem(
              index: 0,
              icon: Icons.edit_note_sharp,
              label: 'Notlar',
            ),
            _buildBottomNavigationBarItem(
              index: 1,
              icon: Icons.access_alarm,
              label: 'Takvim',
            ),
            _buildBottomNavigationBarItem(
              index: 2,
              icon: Icons.check_circle,
              label: 'Yapılacaklar',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        _onTap(index);
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? ColorUtility.defaultWhiteColor : ColorUtility.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? ColorUtility.menuBarColor : ColorUtility.defaultWhiteColor,
          size: 35,
        ),
      ),
    );
  }
}
