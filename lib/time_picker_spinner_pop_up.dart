library time_picker_spinner_pop_up;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'time_picker_spinner_controller.dart';
part 'time_picker_spinner_enum.dart';

class TimePickerSpinnerPopUp extends StatefulWidget {
  const TimePickerSpinnerPopUp({
    Key? key,
    this.pressType = PressType.singlePress,
    this.controller,
    this.barrierColor = Colors.black12,
    this.onChange,
    this.initTime,
    this.minTime,
    this.maxTime,
    this.mode = CupertinoDatePickerMode.time,
    this.timeFormat,
    this.paddingHorizontal,
    this.timeWidgetBuilder,
  }) : super(key: key);

  final PressType pressType;
  final Color barrierColor;
  final TimePickerSpinnerController? controller;
  final void Function(DateTime)? onChange;

  final CupertinoDatePickerMode mode;

  final Widget Function(DateTime)? timeWidgetBuilder;
  final DateTime? initTime;
  final DateTime? minTime;
  final DateTime? maxTime;
  final String? timeFormat;
  final double? paddingHorizontal;

  @override
  _TimePickerSpinnerPopUpState createState() => _TimePickerSpinnerPopUpState();
}

class _TimePickerSpinnerPopUpState extends State<TimePickerSpinnerPopUp>
    with SingleTickerProviderStateMixin {
  RenderBox? _childBox;
  OverlayEntry? _overlayEntry;
  TimePickerSpinnerController? _controller;

  late AnimationController _animationController;
  late Tween<double> _colorTween;
  late Animation<double?> _animation;

  late DateTime _selectedDateTime;
  late DateTime _selectedDateTimeSpinner;

  double _paddingHorizontal = 20;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initTime ?? DateTime.now();
    _selectedDateTimeSpinner = widget.initTime ?? DateTime.now();
    _controller = widget.controller ?? TimePickerSpinnerController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
      }
    });

    _colorTween = Tween(begin: 0, end: 1);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _animation = _colorTween.animate(_animationController);
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.removeListener(_updateView);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = _timeWidget();
    if (Platform.isIOS) {
      return child;
    } else {
      return WillPopScope(
        onWillPop: () {
          _hideMenu();
          return Future.value(true);
        },
        child: child,
      );
    }
  }

  Widget _timeWidget() {
    if (widget.timeWidgetBuilder != null) {
      return InkWell(
          onTap: () {
            if (widget.pressType == PressType.singlePress) {
              _controller?.showMenu();
            }
          },
          onLongPress: () {
            if (widget.pressType == PressType.longPress) {
              _controller?.showMenu();
            }
          },
          child: widget.timeWidgetBuilder!.call(_selectedDateTime));
    }

    late String time;
    late String iconAssets;

    switch (widget.mode) {
      case CupertinoDatePickerMode.time:
        time =
            DateFormat(widget.timeFormat ?? 'HH:mm').format(_selectedDateTime);
        iconAssets = 'packages/time_picker_spinner_pop_up/assets/ic_clock.png';
        break;
      case CupertinoDatePickerMode.date:
        time = DateFormat(widget.timeFormat ?? 'dd/MM/yyyy')
            .format(_selectedDateTime);
        iconAssets =
            'packages/time_picker_spinner_pop_up/assets/ic_calendar.png';
        break;
      case CupertinoDatePickerMode.dateAndTime:
        time = DateFormat(widget.timeFormat ?? 'dd/MM/yyyy HH:mm')
            .format(_selectedDateTime);
        iconAssets =
            'packages/time_picker_spinner_pop_up/assets/ic_calendar.png';
        break;
    }

    return InkWell(
      onTap: () {
        if (widget.pressType == PressType.singlePress) {
          _controller?.showMenu();
        }
      },
      onLongPress: () {
        if (widget.pressType == PressType.longPress) {
          _controller?.showMenu();
        }
      },
      child: Theme(
        data: Theme.of(context),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.onSurface, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconAssets,
                height: 18,
                width: 18,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showMenu() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        final size = _childBox!.size;
        final offset = _childBox!.localToGlobal(const Offset(0, 0));

        if (widget.paddingHorizontal != null) {
          _paddingHorizontal = widget.paddingHorizontal!;
        } else {
          switch (widget.mode) {
            case CupertinoDatePickerMode.time:
              _paddingHorizontal = 20;
              break;
            case CupertinoDatePickerMode.date:
              _paddingHorizontal = 50;
              break;
            case CupertinoDatePickerMode.dateAndTime:
              _paddingHorizontal = 20;
              break;
          }
        }

        Widget menu = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 16,
                offset: const Offset(0, 2), // changes position of shadow
              )
            ],
          ),
          // constraints: const BoxConstraints(
          //   minWidth: 150,
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 225,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: size.width + 2 * _paddingHorizontal,
                      ),
                      child: CupertinoDatePicker(
                        minimumDate: widget.minTime,
                        maximumDate: widget.maxTime,
                        initialDateTime: _selectedDateTimeSpinner,
                        use24hFormat: true,
                        mode: widget.mode,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        onDateTimeChanged: (dateTime) {
                          _selectedDateTimeSpinner = dateTime;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              DefaultTextStyle(
                style: const TextStyle(decoration: TextDecoration.none),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        _animationController.reverse();

                        setState(() {
                          _selectedDateTime = _selectedDateTimeSpinner;
                        });

                        Future.delayed(const Duration(milliseconds: 150), () {
                          widget.onChange?.call(_selectedDateTime);
                          _hideMenu();
                        });
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _animationController.reverse();

                          _selectedDateTimeSpinner = _selectedDateTime;
                          Future.delayed(const Duration(milliseconds: 150), () {
                            _hideMenu();
                          });
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );

        Widget menuWithPositioned = AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            final value = _animation.value ?? 0;

            final centerHorizontal = offset.dx + (size.width) / 2;

            double left = centerHorizontal -
                (((size.width) / 2 + _paddingHorizontal) * value);
            double right = screenWidth -
                (centerHorizontal +
                    (((size.width) / 2 + _paddingHorizontal) * value));
            double? top = offset.dy - ((220 / 2) * value);
            double? bottom;

            if (left < 0) {
              left = 5;
              right = screenWidth - (5 + size.width + 2 * _paddingHorizontal);
            }

            if (right < 0) {
              right = 5;
              left = screenWidth - (5 + size.width + 2 * _paddingHorizontal);
            }

            if (top < 0) {
              top = 5;
              bottom = null;
            }

            if (top + 240 > screenHeight) {
              bottom = 5;
              top = null;
            }

            return Positioned(
              left: left,
              right: right,
              top: top,
              bottom: bottom,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 250 * value,
                  ),
                  child: SingleChildScrollView(child: menu)),
            );
          },
        );

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _controller?.hideMenu();
                },
                child: Container(
                  color: widget.barrierColor,
                ),
              ),
            ),
            menuWithPositioned,
          ],
        );
      },
    );
    if (_overlayEntry != null) {
      Overlay.of(context)!.insert(_overlayEntry!);
      _animationController.forward();
    }
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  _updateView() {
    bool menuIsShowing = _controller?.menuIsShowing ?? false;
    if (menuIsShowing) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }
}
