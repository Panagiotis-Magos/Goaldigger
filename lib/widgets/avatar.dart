import 'package:flutter/material.dart';
import '../../utils/appstate.dart';

class AvatarDisplay extends StatelessWidget {
  final double size; // The size of the avatar (optional, defaults to 100)

  const AvatarDisplay({Key? key, this.size = 100.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = AppState(); // Access the AppState instance

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Theme Image
          Positioned.fill(
            child: Image.asset(
              appState.theme,
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Accessory Image
          Positioned.fill(
            child: Image.asset(
              appState.accessory,
              fit: BoxFit.contain, // Make accessory fit over the theme
            ),
          ),
        ],
      ),
    );
  }
}