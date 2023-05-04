part of 'time_picker_spinner_pop_up.dart';

/// Controller of TimePickerSpinner to show and hide the menu
class TimePickerSpinnerController extends ChangeNotifier {
  bool menuIsShowing = false;
  bool isUpdate = false;

  /// Show menu
  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  /// Hide menu
  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  /// Show menu if menu is hiding
  /// Hide menu if menu is showing
  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }

  /// Update refresh menu
  void updateMenu() {
    isUpdate = true;
    hideMenu();
    showMenu();
    isUpdate = false;
  }
}
