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
    this.paddingHorizontalOverlay,
    this.timeWidgetBuilder,
    this.minuteInterval = 1,
    this.textStyle,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.iconSize = 18,
    this.padding = const EdgeInsets.fromLTRB(12, 10, 12, 10),
    this.cancelText = 'Cancel',
    this.confirmText = 'OK',
    this.isCancelTextLeft = false,
    this.enable = true,
    this.radius = 10,
    this.use24hFormat = true,
    this.locale,
  }) : super(key: key);

  /// Type of press to show pop up, default is [PressType.singlePress]
  final PressType pressType;

  /// Barrier color when pop up show
  final Color barrierColor;

  /// Controller for time picker spinner
  final TimePickerSpinnerController? controller;

  /// A callback will call after user select DateTime
  final void Function(DateTime)? onChange;

  /// The mode of the date picker as one of [CupertinoDatePickerMode].
  /// Defaults to [CupertinoDatePickerMode.time]. Cannot be null and
  /// value cannot change after initial build.
  final CupertinoDatePickerMode mode;

  /// Custom builder for time widget
  final Widget Function(DateTime)? timeWidgetBuilder;

  /// The initial date and/or time of the picker
  final DateTime? initTime;

  /// The minTime selectable date that the picker can settle on.
  final DateTime? minTime;

  /// The maximum selectable date that the picker can settle on.
  final DateTime? maxTime;

  /// Time widget 's text style
  final String? timeFormat;

  /// Popup 's padding container
  final double? paddingHorizontalOverlay;

  /// The granularity of the minutes spinner, if it is shown in the current mode.
  /// Must be an integer factor of 60.
  final int minuteInterval;

  /// Time widget 's text style
  final TextStyle? textStyle;

  /// Time widget cancelTextStyle's text style
  final TextStyle? cancelTextStyle;

  /// Time widget confirmTextStyle's text style
  final TextStyle? confirmTextStyle;

  /// Time widget 's icon clock size
  final double iconSize;

  /// Time widget 's padding container
  final EdgeInsetsGeometry? padding;

  /// Text for cancel button, default is 'Cancel'
  final String cancelText;

  /// Text for confirm button, default is 'OK'
  final String confirmText;

  /// The position of [cancelText], default is right
  /// If [isCancelTextLeft] is true, [cancelText] will be on left
  final bool isCancelTextLeft;

  /// enable press to open the pop up or not, default is 'true'
  final bool enable;

  /// circular radius of the pop up, default is 10
  final double radius;

  /// Whether to use 24 hour format. Defaults to true.
  final bool use24hFormat;

  /// Custom locale
  /// if you want to use this locale, you must declare support localizationsDelegates in MaterialApp:
  ///     MaterialApp(
  ///       localizationsDelegates: const [
  ///         GlobalMaterialLocalizations.delegate,
  ///         GlobalWidgetsLocalizations.delegate,
  ///         GlobalCupertinoLocalizations.delegate,
  ///       ],
  ///       ...
  ///     )
  final Locale? locale;

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
  void didUpdateWidget(covariant TimePickerSpinnerPopUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedDateTime = widget.initTime ?? DateTime.now();
    _selectedDateTimeSpinner = widget.initTime ?? DateTime.now();
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
          onTap: !widget.enable
              ? null
              : () {
                  if (widget.pressType == PressType.singlePress) {
                    _controller?.showMenu();
                  }
                },
          onLongPress: !widget.enable
              ? null
              : () {
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
      onTap: !widget.enable
          ? null
          : () {
              if (widget.pressType == PressType.singlePress) {
                _controller?.showMenu();
              }
            },
      onLongPress: !widget.enable
          ? null
          : () {
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
          padding: widget.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconAssets,
                height: widget.iconSize,
                width: widget.iconSize,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: widget.textStyle ??
                    TextStyle(
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

        if (widget.paddingHorizontalOverlay != null) {
          _paddingHorizontal = widget.paddingHorizontalOverlay!;
        } else {
          switch (widget.mode) {
            case CupertinoDatePickerMode.time:
              _paddingHorizontal = 20;
              break;
            case CupertinoDatePickerMode.date:
              _paddingHorizontal = 50;
              break;
            case CupertinoDatePickerMode.dateAndTime:
              _paddingHorizontal = 50;
              break;
          }
        }

        final confirmButton = Expanded(
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
            widget.confirmText,
            style: widget.confirmTextStyle ??
                TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
            textAlign: TextAlign.center,
          ),
        ));

        final cancelButton = Expanded(
          child: GestureDetector(
            onTap: () {
              _animationController.reverse();

              _selectedDateTimeSpinner = _selectedDateTime;
              Future.delayed(const Duration(milliseconds: 150), () {
                _hideMenu();
              });
            },
            child: Text(
              widget.cancelText,
              style: widget.cancelTextStyle ??
                  TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        );

        Widget menu = Container(
          margin: const EdgeInsets.all(10),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2), // changes position of shadow
              )
            ],
          ),
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
                        minuteInterval: widget.minuteInterval,
                        initialDateTime: _selectedDateTimeSpinner,
                        use24hFormat: widget.use24hFormat,
                        mode: widget.mode,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        onDateTimeChanged: (dateTime) {
                          if (widget.minTime != null &&
                              dateTime.isBefore(widget.minTime!)) {
                            _selectedDateTimeSpinner = widget.minTime!;
                          } else if (widget.maxTime != null &&
                              dateTime.isAfter(widget.maxTime!)) {
                            _selectedDateTimeSpinner = widget.maxTime!;
                          } else {
                            _selectedDateTimeSpinner = dateTime;
                          }
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
                  children: widget.isCancelTextLeft
                      ? [
                          cancelButton,
                          confirmButton,
                        ]
                      : [
                          confirmButton,
                          cancelButton,
                        ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );

        Widget menuWithLocale = Localizations.override(
          context: context,
          locale: widget.locale,
          child: menu,
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
              left: left - 10,
              right: right - 10,
              top: top == null ? null : (top - 10),
              bottom: bottom == null ? null : (bottom - 10),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 270 * value,
                  ),
                  child: SingleChildScrollView(
                      child: widget.locale != null ? menuWithLocale : menu)),
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
