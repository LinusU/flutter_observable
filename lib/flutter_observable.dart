library flutter_observable;

import 'dart:async';
import 'package:flutter/widgets.dart';

/// A view to a observed value
class Observable<T> {
  final ObservableController<T> _controller;

  /// The current value of this observable
  T get value => _controller._value;

  /// A Stream of the values of this observable
  Stream<T> get stream => _controller._stream;

  Observable._internal(this._controller);

  /// Creates a new Observable from the provided stream and initial value
  Observable.stream(Stream<T> stream, T initialValue): _controller = ObservableController(initialValue) {
    stream.listen((value) { _controller.value = value; }, onDone: () { _controller.close(); });
  }
}

/// A controller with the observable it controls.
///
/// This controller allows updating the value of its observable. This class can be used to create a simple observable that others can listen to, and to change the value of that observable.
class ObservableController<T> {
  final _controller = StreamController<T>.broadcast();

  /// The current value.
  T _value;

  /// Get a stream with updates to the value.
  Stream<T> get _stream => _controller.stream;

  /// Get the current value.
  T get value => this._value;

  /// Set a new value.
  ///
  /// This will notify anyone listening on the observable that a new value was set.
  set value(T value) {
    assert(_controller.isClosed == false);
    this._value = value;
    this._controller.add(value);
  }

  /// The observable that this controller is controlling.
  Observable<T> get observable => Observable<T>._internal(this);

  /// A controller with an observable with the initial specified value.
  ObservableController(T value) : this._value = value;

  /// Closes the observable.
  void close() {
    _controller.close();
  }
}

/// Widget that builds itself based on the latest snapshot of interaction with an Observable.
class ObservableBuilder<T> extends StatelessWidget {
  /// The build strategy currently used by this builder.
  final AsyncWidgetBuilder<T> builder;

  /// The observable to which this builder is currently connected.
  final Observable<T> observable;

  /// Creates a new ObservableBuilder that builds itself based on the latest snapshot of the specified observable and whose build strategy is given by builder.
  const ObservableBuilder({Key key, @required this.builder, @required this.observable})
      : assert(observable != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: this.builder,
      initialData: this.observable.value,
      stream: this.observable.stream,
    );
  }
}
