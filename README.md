
A beautiful and animated bottom navigation bar.

Here are some supported style:

###### Time picker
![DEMO](https://github.com/tuannvm2109/time_picker_spinner_pop_up/blob/master/assets/time.gif)

###### Date picker
![DEMO](https://github.com/tuannvm2109/time_picker_spinner_pop_up/blob/master/assets/date.gif)

## Usage

###### Simple implementation:

```dart
        TimePickerSpinnerPopUp(
          mode: CupertinoDatePickerMode.time,
          initTime: DateTime.now(),
          minTime: DateTime.now().subtract(const Duration(days: 10)),
          maxTime: DateTime.now().add(const Duration(days: 10)),
          barrierColor: Colors.black12, //Barrier Color when pop up show
          onChange: (dateTime) {
            // Implement your logic with select dateTime
          },
          // Customize your time widget
          // timeWidgetBuilder: (dateTime) {},

          // Customize your time format
          // timeFormat: 'dd/MM/yyyy',

          // Customize your time format
          // timeFormat: 'dd/MM/yyyy',
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
