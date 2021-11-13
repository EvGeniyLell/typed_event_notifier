<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

The `EventNotifier` library allows notifying listeners with an object.
listeners can be subscribed on only special type or group objects.

## Installation

Add on pubspec.yml:

```
dependencies:
  event_notifier: ... // latest package version
```

## Usage

See example in `/example` folder

```dart
import 'package:event_notifier/event_notifier.dart';


/// Class [ExampleNotifier].
/// 
/// The example of notifier.
/// It can send notifications to listeners with an object
/// and notify listeners if they are registered for this object type
/// or extended objects.
class ExampleNotifier extends EventNotifier<Event> {
  /// Create [ExampleNotifier] instance.
  ExampleNotifier();
  
  /// Will notify listeners with [CurrentPageChangedEvent] event.
  void currentPage(int index) {
    _currentPage = index;
    notifyListeners(CurrentPageChangedEvent(currentPage: currentPage));
  }

  /// Will notify listeners with [PagesLoadedEvent] event.
  set loadedPages(Set<int> set) {
    _loadedPages.addAll(set);
    notifyListeners(PagesLoadedEvent(pages: set));
  }
}


//The part of example of listener on `current page changed` event only.
class _CurrentPageOnlyListenerState extends State<CurrentPageOnlyListener> {
  String message = 'CurrentPageOnly: empty';

  // Will receive events only with CurrentPageChangedEvent type.
  void currentPageChanged(CurrentPageChangedEvent event) {
    setState(() {
      message = 'CurrentPageOnly: now current page is ${event.currentPage}';
    });
  }

  @override
  void initState() {
    widget.notifier.addListener(currentPageChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(currentPageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }

}

// The part of example of listener on any event.
class _AnyListenerState extends State<AnyListener> {
  String message = 'Any: empty';

  // Will receive events with CurrentPageChangedEvent and PagesLoadedEvent type.
  void any(Event event) {
    if (event is CurrentPageChangedEvent) {
      setState(() {
        message = 'Any: now current page is ${event.currentPage}';
      });
    }
    if (event is PagesLoadedEvent) {
      setState(() {
        message = 'Any: new loaded pages is ${event.pages}';
      });
    }
  }

  @override
  void initState() {
    widget.notifier.addListener(any);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(any);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}

// The events for example, which will be sent through the notifier.
// They have abstract base class (used as parent type),
// and extends from it events.
// for example two types with different content.
/// Class [Event]. 
abstract class Event {
  /// Create [Event] instance.
  Event();
}

/// Class [CurrentPageChangedEvent].
class CurrentPageChangedEvent extends Event {
  /// Index of current page.
  final int currentPage;

  /// Create [CurrentPageChangedEvent] instance.
  CurrentPageChangedEvent({
    required this.currentPage,
  }) : super();
}

/// Class [PagesLoadedEvent].
class PagesLoadedEvent extends Event {
  /// Indexes of loaded pages.
  final Set<int> pages;

  /// Create [PagesLoadedEvent] instance.
  PagesLoadedEvent({
    required this.pages,
  }) : super();
}
```
