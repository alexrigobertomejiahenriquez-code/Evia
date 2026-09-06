import 'package:flutter_test/flutter_test.dart';

import 'package:evia/models/notification_item.dart';
import 'package:evia/services/notifications/notification_service_local.dart';
import 'package:evia/features/notifications/presentation/controllers/notification_controller.dart';

void main() {
  // Deterministic dates for tests
  final date1 = DateTime.utc(2020, 1, 1);
  final date2 = DateTime.utc(2020, 1, 2);

  group('NotificationController', () {
    test('loadNotifications loads notifications from service', () async {
      final fake = FakeNotificationService(items: [
        NotificationItem(id: '1', title: 'T1', body: 'B1', date: date1),
      ]);
      final controller = NotificationController(service: fake);

      await controller.loadNotifications();

      expect(controller.items.length, 1);
      expect(controller.items.first.id, '1');
      expect(controller.error, isNull);
    });

    test('loadNotifications updates loading correctly', () async {
      final fake = FakeNotificationService(items: [
        NotificationItem(id: '1', title: 'T1', body: 'B1', date: date1),
      ], delayMs: 50);
      final controller = NotificationController(service: fake);

      final loadingStates = <bool>[];
      controller.addListener(() {
        loadingStates.add(controller.loading);
      });

      final future = controller.loadNotifications();
      // right after calling loadNotifications, loading should be true
      expect(controller.loading, isTrue);

      await future;

      // ensure loading toggled and final state is false
      expect(loadingStates.contains(true), isTrue);
      expect(loadingStates.last, isFalse);
    });

    test('loadNotifications captures service error and exposes error', () async {
      final fake = FakeNotificationService(items: [], throwOnGet: true);
      final controller = NotificationController(service: fake);

      await controller.loadNotifications();

      expect(controller.items, isEmpty);
      expect(controller.error, isNotNull);
      expect(controller.loading, isFalse);
    });

    test('addNotification adds and updates items and clears error on success', () async {
      // Start with a fake service that throws on get to produce a real error
      final fake = FakeNotificationService(items: [], throwOnGet: true);
      final controller = NotificationController(service: fake);

      // produce an error via loadNotifications
      await controller.loadNotifications();
      expect(controller.error, isNotNull);

      // Switch fake to normal operation
      fake.throwOnGet = false;
      await fake.saveNotifications([]); // ensure fake has an initially empty storage

      final item = NotificationItem(id: '10', title: 'New', body: 'New body', date: date2);
      await controller.addNotification(item);

      // After successful addNotification, error should be cleared and item present
      expect(controller.error, isNull);
      expect(controller.items.isNotEmpty, isTrue);
      expect(controller.items.first.id, '10');
    });

    test('removeNotification removes the item and updates items', () async {
      final a = NotificationItem(id: 'a', title: 'A', body: 'A', date: date1);
      final b = NotificationItem(id: 'b', title: 'B', body: 'B', date: date2);
      final fake = FakeNotificationService(items: [a, b]);
      final controller = NotificationController(service: fake);

      await controller.loadNotifications();
      expect(controller.items.length, 2);

      await controller.removeNotification('a');
      expect(controller.items.length, 1);
      expect(controller.items.first.id, 'b');
    });

    test('markRead updates read state correctly', () async {
      final a = NotificationItem(id: 'a', title: 'A', body: 'A', date: date1, read: false);
      final fake = FakeNotificationService(items: [a]);
      final controller = NotificationController(service: fake);

      await controller.loadNotifications();
      await controller.markRead('a', true);
      expect(controller.items.first.read, isTrue);

      await controller.markRead('a', false);
      expect(controller.items.first.read, isFalse);
    });

    test('markAllRead marks all notifications as read', () async {
      final a = NotificationItem(id: 'a', title: 'A', body: 'A', date: date1, read: false);
      final b = NotificationItem(id: 'b', title: 'B', body: 'B', date: date2, read: false);
      final fake = FakeNotificationService(items: [a, b]);
      final controller = NotificationController(service: fake);

      await controller.loadNotifications();
      await controller.markAllRead();

      expect(controller.items.every((i) => i.read), isTrue);
    });

    test('clearAll empties items and notifies listeners', () async {
      final a = NotificationItem(id: 'a', title: 'A', body: 'A', date: date1);
      final fake = FakeNotificationService(items: [a]);
      final controller = NotificationController(service: fake);

      await controller.loadNotifications();
      expect(controller.items.isNotEmpty, isTrue);

      var notified = false;
      controller.addListener(() {
        notified = true;
      });

      await controller.clearAll();
      expect(controller.items, isEmpty);
      expect(notified, isTrue);
    });

    test('successful operation clears previous error', () async {
      final fake = FakeNotificationService(items: [], throwOnGet: true);
      final controller = NotificationController(service: fake);

      // produce an error
      await controller.loadNotifications();
      expect(controller.error, isNotNull);

      // switch fake to normal
      fake.throwOnGet = false;
      await fake.saveNotifications([NotificationItem(id: 'x', title: 'X', body: 'X', date: date1)]);

      await controller.loadNotifications();
      expect(controller.error, isNull);
      expect(controller.items.length, 1);
    });
  });
}
