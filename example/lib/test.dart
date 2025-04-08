final controller = ScrollPageTransitionController();

    void handleDragUpdate(DragUpdateDetails details) {
      setState(() {
        print(details.primaryDelta!);
      });
    }

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
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: GestureDetector(
                    onVerticalDragUpdate: handleDragUpdate,
                    behavior: HitTestBehavior.deferToChild,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 500,
                          color: CupertinoColors.systemRed,
                        ),
                        Container(
                          width: double.infinity,
                          height: 500,
                          color: CupertinoColors.activeBlue,
                        ),
                        CupertinoTextField(
                          placeholder: "Search",
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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