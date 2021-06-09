class MainJumpEvent {
  MainJumpPage page;
  Map<String, dynamic>? params;

  MainJumpEvent(this.page, {this.params});
}

enum MainJumpPage {
  home,
  info,
  money,
  mine
}

extension MainJumpPageExtension on MainJumpPage {
  int get value => [0, 1, 2, 3][index];
}