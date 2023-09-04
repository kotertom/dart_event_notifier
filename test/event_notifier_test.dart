import 'package:event_notifier/event_notifier.dart';
import 'package:test/test.dart';

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
  test(
      'Calling increment twice synchronously emits event twice and '
      'reading the value afterward gives 2', () {
    final counter = Counter();

    expect(
      counter.events,
      emitsInOrder(
        [
          isA<Incremented>(),
          isA<Incremented>(),
        ],
      ),
    );

    counter
      ..increment()
      ..increment();

    expect(counter.value, equals(2));

    counter.dispose();
  });

  test(
      'Calling increment twice synchronously emits event twice and '
      'reading the value between increments gives 1', () {
    final counter = Counter();

    counter.increment();
    final firstRead = counter.value;
    counter.increment();
    final secondRead = counter.value;

    expect(firstRead, equals(1));
    expect(secondRead, equals(2));

    counter.dispose();
  });

  test(
      'Event stream listeners are asynchronous, so calling notify multiple '
      'times synchronously yields value available in next dart task', () async {
    final counter = Counter();

    expect(
      counter.events.map((event) => counter.value),
      emitsInOrder([2, 2, 3]),
    );

    counter
      ..increment()
      ..increment();

    await Future<void>.delayed(Duration.zero);

    counter.increment();

    expect(counter.value, equals(3));

    counter.dispose();
  });
}
