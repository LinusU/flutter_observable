# flutter_observable

A simple observable with corresponding controller and builder.

Use this package when you want to build widgets that builds whenever an external value is changed.

## Usage

The following code demonstrates a simple click-counter app with the state stored outside of the widget.

```dart
import 'package:flutter_observable/flutter_observable.dart';
import 'package:flutter/material.dart';

///
/// This is a global variable here, but should probably come from a provider.
///
final clicksController = ObservableController(0);
final clicksObservable = clicksController.observable;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter counter demo')),

        ///
        /// Here we are using the `ObservableBuilder` to re-build the view whenever the count is changed.
        ///
        /// It listens to the specified `Observable` and re-builds whenever there is a new value set.
        ///
        body: ObservableBuilder(
          observable: clicksObservable,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ///
            /// When the button is pressed, we increment the value of the observable by one.
            ///
            /// This will automatically trigger a re-build of the `ObservableBuilder` above.
            ///
            clicksController.value += 1;
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```
