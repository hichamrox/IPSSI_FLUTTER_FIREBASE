import 'package:flutter/material.dart';

import 'Custom.dart';

class Background extends StatefulWidget {
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    return ClipPath(
      clipper: Custom(),
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.red),
    );
  }
}
