import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:event_notifier/event_notifier.dart';

void main() {
  /// The notifier.
  final EventNotifier<Event> notifier = EventNotifier<Event>();

  /// Mok of currentPageChanged.
  final void Function(CurrentPageChangedEvent event) currentPageChanged =
  MokCurrentPageChanged();

  /// Mok of pagesLoaded.
  final void Function(PagesLoadedEvent event) pagesLoaded = MokPagesLoaded();

  test('should created with empty listeners.', () {
    expect(notifier.numberOfListeners, equals(0));
  });

  test('should registering listeners.', () {
    notifier.addListener(currentPageChanged);
    expect(notifier.numberOfListeners, equals(1));

    notifier.addListener(pagesLoaded);
    expect(notifier.numberOfListeners, equals(2));
  });

  test(
      'should throw assert if registering the same listener '
          'more then one.', () {
    expect(
          () => notifier.addListener(currentPageChanged),
      throwsAssertionError,
    );
    expect(notifier.numberOfListeners, equals(2));

    expect(
          () => notifier.addListener(pagesLoaded),
      throwsAssertionError,
    );
    expect(notifier.numberOfListeners, equals(2));
  });

  test('should notifying listeners.', () {
    final CurrentPageChangedEvent currentPage1 =
    CurrentPageChangedEvent(currentPage: 1);
    notifier.notifyListeners(currentPage1);
    verify(currentPageChanged(currentPage1)).called(1);

    final PagesLoadedEvent pages123 = PagesLoadedEvent(pages: <int>{1, 2, 3});
    notifier.notifyListeners(pages123);
    verify(pagesLoaded(pages123)).called(1);
  });

  test('should unregistering listeners.', () {
    notifier.removeListener(currentPageChanged);
    expect(notifier.numberOfListeners, equals(1));

    notifier.removeListener(pagesLoaded);
    expect(notifier.numberOfListeners, equals(0));
  });

  test('should throw assert if unregistering non-registering listener.', () {
    expect(
          () => notifier.removeListener(currentPageChanged),
      throwsAssertionError,
    );
    expect(notifier.numberOfListeners, equals(0));

    expect(
          () => notifier.removeListener(pagesLoaded),
      throwsAssertionError,
    );
    expect(notifier.numberOfListeners, equals(0));
  });

  test('should not notifying listeners.', () {
    final CurrentPageChangedEvent currentPage2 =
    CurrentPageChangedEvent(currentPage: 2);
    notifier
      ..notifyListeners(currentPage2)
      ..notifyListeners(currentPage2);
    verifyNever(currentPageChanged(currentPage2));

    final PagesLoadedEvent pages234 = PagesLoadedEvent(pages: <int>{2, 3, 4});
    notifier
      ..notifyListeners(pages234)
      ..notifyListeners(pages234);
    verifyNever(pagesLoaded(pages234));
  });
}

/*

Mok Function

 */

class MokCurrentPageChanged extends Mock {
  void call(CurrentPageChangedEvent event);
}

class MokPagesLoaded extends Mock {
  void call(PagesLoadedEvent event);
}

/*

Test event as example

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
