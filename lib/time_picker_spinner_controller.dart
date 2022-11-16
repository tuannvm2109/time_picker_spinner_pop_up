part of 'time_picker_spinner_pop_up.dart';

class TimePickerSpinnerController extends ChangeNotifier {
  bool menuIsShowing = false;
  bool isUpdate = false;

  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }

  void updateMenu() {
    isUpdate = true;
    hideMenu();
    showMenu();
    isUpdate = false;
  }
}

