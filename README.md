# event_notifier

This is a very simple Dart package for adding observability to your objects. It
does not have a dependency on Flutter, so can be used in Dart scripts or even
server-side. It's a slight variation on Flutter's
[ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html),
[bloc](https://pub.dev/packages/bloc) et cetera.

The gist of it is that our objects will be notifying of meaningful events that
happen inside of them.

## Usage

See the full example in
[example/event_notifier_example.dart](example/event_notifier_example.dart).

First define the events that can occur in your objects. Sealed classes and enums
are great for this.

```dart
sealed class CounterEvent {
  const CounterEvent();
}

final class Incremented extends CounterEvent {
  const Incremented();
}

final class Decremented extends CounterEvent {
  const Decremented();
}
```

Then write your logic. Mix in the `EventNotifer` and use `notify` to post
important events that users of your class might want to react to!

```dart
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
```

To receive the events, listen to the `events` stream. Simple as that.

```dart
void main() {
  final counter = Counter();

  counter.events.listen((event) {
    print('Received event: $event; current value: ${counter.value}');
  });
}
```
