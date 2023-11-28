
A beautiful and animated time picker spinner pop up.

Here are some supported style:

###### Time picker
![DEMO](https://github.com/tuannvm2109/time_picker_spinner_pop_up/raw/master/assets/time.gif)

###### Date picker
![DEMO](https://github.com/tuannvm2109/time_picker_spinner_pop_up/raw/master/assets/date.gif)

## Usage

###### Short implementation:

```dart
        TimePickerSpinnerPopUp(
          mode: CupertinoDatePickerMode.time,
          initTime: DateTime.now(),
          onChange: (dateTime) {
            // Implement your logic with select dateTime
          },
        )
```


###### Full implementation:

```dart
        TimePickerSpinnerPopUp(
          mode: CupertinoDatePickerMode.date,
          initTime: DateTime.now(),
          minTime: DateTime.now().subtract(const Duration(days: 10)),
          maxTime: DateTime.now().add(const Duration(days: 10)),
          barrierColor: Colors.black12, //Barrier Color when pop up show
          minuteInterval: 1,
          padding : const EdgeInsets.fromLTRB(12, 10, 12, 10),
          cancelText : 'Cancel',
          confirmText : 'OK',
          pressType: PressType.singlePress,
          timeFormat: 'dd/MM/yyyy',
          // Customize your time widget
          // timeWidgetBuilder: (dateTime) {},
          onChange: (dateTime) {
          // Implement your logic with select dateTime
          },
        )
```

## License

```
Copyright (c) 2021 Tuannvm

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
