//create a custom back button to force a refresh
import 'package:flutter/material.dart';
import '../utils/navigation.dart';

class CustomBackButton extends StatelessWidget {
  final Color color; // Dynamic color parameter
  final VoidCallback? onPressed;

  const CustomBackButton({
    super.key,
    this.color = Colors.black, // Default color if none provided
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color), // Use the provided color
      onPressed: onPressed ?? () => goBack<bool>(context,true),
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  final BuildContext context;  
  final int currentIndex;
  final Color selectedcolor; //default set to amber, set to grey in a page outside the main 3, to have it appear as if none of them are selected
  final Color unselectedcolor; 


  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.context,
    this.selectedcolor= Colors.amber,
    this.unselectedcolor = Colors.grey
  }) : super(key: key);

  void _onTap(int index) {

    switch (index) {
      case 0:
        gotoNamedReplace(context, '/searchscreen');
        break;
      case 1:
        gotoNamedReplace(context, '/home');
        break;
      case 2:
        gotoNamedReplace(context, '/shop');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: selectedcolor,
      unselectedItemColor: unselectedcolor,
      onTap: _onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shop'),
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget{
  final title;
  final Color backgroundcolor;
  
  CustomAppBar({
    super.key,
    this.backgroundcolor = Colors.amber, // Default color if none provided
    this.title = 'SELECT TITLE DUMB DUMB'
  });

  @override
  Widget build(BuildContext context) {

    return  AppBar(
        title: Text(title),
        backgroundColor: backgroundcolor,
        centerTitle: true,
        automaticallyImplyLeading: false, // Disable default back button
        leading: CustomBackButton( color: Colors.black )
      );
  }


}
