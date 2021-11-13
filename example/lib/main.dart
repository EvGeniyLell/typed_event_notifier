import 'dart:math';

import 'package:event_notifier/event_notifier.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

/// Example app.
class App extends StatelessWidget {
  /// Create [App] instance.
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

/*
The events for example, which will be sent through the notifier.
They have abstract base class (used as parent type),
and extends from it events.
for example two types with different content.
 */

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

/*
The example of notifier.
They can send notifiers to listeners with object
and notifier listeners if they registered on this object type.
 */

/// Class [ExampleNotifier]
class ExampleNotifier extends EventNotifier<Event> {
  /// Create [ExampleNotifier] instance.
  ExampleNotifier();

  int _currentPage = 0;

  /// Current index of page.
  int get currentPage => _currentPage;

  set currentPage(int index) {
    _currentPage = index;
    notifyListeners(CurrentPageChangedEvent(currentPage: currentPage));
  }

  final Set<int> _loadedPages = <int>{};

  /// List of indexes of loaded pages.
  List<int> get loadedPages => _loadedPages.toList(growable: false);

  set loadedPages(List<int> list) {
    final Set<int> loadedPages = list.toSet();
    _loadedPages.addAll(loadedPages);
    notifyListeners(PagesLoadedEvent(pages: loadedPages));
  }
}

/*
The example of listener on `current page changed` event only.
 */

/// Class [CurrentPageOnlyListener].
class CurrentPageOnlyListener extends StatefulWidget {
  /// Create [CurrentPageOnlyListener] instance.
  const CurrentPageOnlyListener({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  /// Notifier.
  final ExampleNotifier notifier;

  @override
  State<CurrentPageOnlyListener> createState() =>
      _CurrentPageOnlyListenerState();
}

class _CurrentPageOnlyListenerState extends State<CurrentPageOnlyListener> {
  String message = 'empty';

  void currentPageChanged(CurrentPageChangedEvent event) {
    setState(() {
      message = 'now current page is ${event.currentPage}';
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

/*
The example of listener on any event.
 */

/// Class [AnyListener].
class AnyListener extends StatefulWidget {
  /// Create [AnyListener] instance.
  const AnyListener({
    required this.notifier,
    Key? key,
  }) : super(key: key);

  /// Notifier.
  final ExampleNotifier notifier;

  @override
  State<AnyListener> createState() => _AnyListenerState();
}

class _AnyListenerState extends State<AnyListener> {
  String message = 'empty';

  void any(Event event) {
    if (event is CurrentPageChangedEvent) {
      setState(() {
        message = 'now current page is ${event.currentPage}';
      });
    }
    if (event is PagesLoadedEvent) {
      setState(() {
        message = 'new loaded pages is ${event.pages}';
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

/// Class [MyHomePage].
class MyHomePage extends StatelessWidget {
  /// Create [MyHomePage] instance.
  MyHomePage({
    required this.title,
    Key? key,
  }) : super(key: key);

  /// Title of homepage.
  final String title;

  /// Notifier.
  final ExampleNotifier notifier = ExampleNotifier();

  void _setNewCurrentPage() {
    final Random random = Random();
    notifier.currentPage = random.nextInt(100);
  }

  void _setNewLoadedPages() {
    final Random random = Random();
    notifier.loadedPages = <int>[
      random.nextInt(100),
      random.nextInt(100),
      random.nextInt(100)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CurrentPageOnlyListener(notifier: notifier),
            const SizedBox(height: 10),
            AnyListener(notifier: notifier),
            const SizedBox(height: 10),
            const Text(
              'You can push the buttons to notify listeners.',
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _setNewCurrentPage,
              child: const Text('New Current Page'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _setNewLoadedPages,
              child: const Text('New Loaded Pages List'),
            ),
          ],
        ),
      ),
    );
  }
}
