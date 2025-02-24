import 'package:flutter/cupertino.dart';
import 'package:scroll_page_transition/scroll_page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollPageTransitionController();

    return CupertinoApp(
      home: ScrollPageTransition(
        controller: controller,
        primaryPage: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text("Scroll Page Transition"),
            trailing: CupertinoButton(
              padding: const EdgeInsets.all(8.0),
              onPressed: controller.openSecondaryPage,
              child: const Icon(
                CupertinoIcons.search,
                size: 25,
                color: CupertinoColors.black,
              ),
            ),
          ),
          child: const Center(child: Text("Primary Page")),
        ),
        secondaryPage: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("Secondary Page"),
            trailing: CupertinoButton(
              padding: EdgeInsets.all(8.0),
              onPressed: controller.closeSecondaryPage,
              child: Icon(
                CupertinoIcons.clear,
                size: 25,
                color: CupertinoColors.black,
              ),
            ),
          ),
          child: Center(child: Text("Add your custom widgets here")),
        ),
      ),
    );
  }
}
