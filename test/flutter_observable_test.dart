import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_observable/flutter_observable.dart';

void main() {
  test('emits new values', () async {
    final ctrl = ObservableController(1);
    assert(ctrl.value == 1);

    final first = ctrl.observable.stream.first;
    ctrl.value = 2;
    assert(await first == 2);
  });

  test('the observable shows the current value', () async {
    final ctrl = ObservableController(1);

    final observable = ctrl.observable;
    assert(observable.value == 1);

    ctrl.value = 2;
    assert(observable.value == 2);

    ctrl.value = 3;
    assert(observable.value == 3);
  });
}
