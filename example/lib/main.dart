import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ScrollController outerController = ScrollController();
  final ScrollController innerController = ScrollController();
  bool outerScrollEnabled = false;

  @override
  void dispose() {
    outerController.dispose();
    innerController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    // Si l'utilisateur swippe vers le bas et que le scroll interne est tout en haut
    if (details.delta.dy > 0 && innerController.offset <= 0) {
      if (!outerScrollEnabled) {
        setState(() {
          outerScrollEnabled = true;
        });
      }
    } else if (details.delta.dy < 0) {
      if (outerScrollEnabled) {
        setState(() {
          outerScrollEnabled = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      child: SingleChildScrollView(
        controller: outerController,
        physics:
            outerScrollEnabled
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Par exemple, un en-tête
            Container(
              height: 300,
              color: CupertinoColors.systemGrey,
              child: const Center(child: Text("En-tête global")),
            ),
            // Le scroll interne (pour le swipe up)
            Container(
              height: 600,
              color: CupertinoColors.systemBlue,
              child: SingleChildScrollView(
                controller: innerController,
                child: Column(
                  children: [
                    Container(
                      height: 500,
                      color: CupertinoColors.activeGreen,
                      child: const Center(child: Text("Contenu interne 1")),
                    ),
                    Container(
                      height: 500,
                      color: CupertinoColors.activeOrange,
                      child: const Center(child: Text("Contenu interne 2")),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
