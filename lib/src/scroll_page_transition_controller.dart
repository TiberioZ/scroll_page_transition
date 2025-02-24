class ScrollPageTransitionController {
  void Function()? openSecondaryPage;
  void Function()? closeSecondaryPage;

  void attach({
    required void Function() openSecondaryPage,
    required void Function() closeSecondaryPage,
  }) {
    this.openSecondaryPage = openSecondaryPage;
    this.closeSecondaryPage = closeSecondaryPage;
  }
}
