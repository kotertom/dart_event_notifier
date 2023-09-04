import 'package:dart_event_notifier/dart_event_notifier.dart';

sealed class CounterEvent {
  const CounterEvent();
}

final class Incremented extends CounterEvent {
  const Incremented();
}

final class Decremented extends CounterEvent {
  const Decremented();
}

class Counter with EventNotifier<CounterEvent> {
  var _value = 0;
  int get value => _value;

  void increment() {
    _value++;
    notify(Incremented());
  }

  void decrement() {
    _value--;
    notify(Decremented());
  }
}

Future<void> main() async {
  final counter = Counter();

  counter.events.listen((event) {
    print('Received event: $event; current value: ${counter.value}');
  });

  // This will print twice: once with the Incremented event, and once with
  // the Decremented event. In both cases the value is 0 because the stream
  // callback is asynchronous while the counter has been incremented
  // and decremented synchronously.
  counter
    ..increment()
    ..decrement();
  // -> Received event: Instance of 'Incremented'; current value: 0
  // -> Received event: Instance of 'Decremented'; current value: 0

  await Future<void>.delayed(Duration.zero);

  // This will print twice as well with the same events but the values are now
  // 1 and 0, respectively. This is because the print callback had a chance
  // to run before `decrement` was called.
  counter.increment();
  // -> Received event: Instance of 'Incremented'; current value: 1
  await Future<void>.delayed(Duration.zero);
  counter.decrement();
  // -> Received event: Instance of 'Decremented'; current value: 0
}
