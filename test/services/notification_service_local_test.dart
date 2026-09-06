import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:evia/services/notifications/notification_service_local.dart';
import 'package:evia/models/notification_item.dart';

void main() {
  const storageKey = 'evia_notifications';

  setUp(() {
    // Ensure each test starts with a clean in-memory SharedPreferences
    SharedPreferences.setMockInitialValues({});
  });

  test('getNotifications returns empty when no storage', () async {
    final service = NotificationServiceLocal();
    final items = await service.getNotifications();
    expect(items, isEmpty);
  });

  test('saveNotifications and getNotifications preserve data and order', () async {
    final service = NotificationServiceLocal();
    final a = NotificationItem(id: 'a', title: 'A', body: 'Body A', date: DateTime.now());
    final b = NotificationItem(id: 'b', title: 'B', body: 'Body B', date: DateTime.now());

    await service.saveNotifications([a, b]);

    final items = await service.getNotifications();
    expect(items.length, 2);
    expect(items[0].id, 'a');
    expect(items[1].id, 'b');
    expect(items[0].title, 'A');
    expect(items[1].body, 'Body B');
  });

  test('add inserts new notification at the start', () async {
    final service = NotificationServiceLocal();
    final old = NotificationItem(id: 'old', title: 'Old', body: 'Old body', date: DateTime.now());
    final newer = NotificationItem(id: 'new', title: 'New', body: 'New body', date: DateTime.now());

    await service.saveNotifications([old]);
    await service.add(newer);

    final items = await service.getNotifications();
    expect(items.length, 2);
    expect(items.first.id, 'new');
  });

  test('remove deletes only the indicated notification', () async {
    final service = NotificationServiceLocal();
    final a = NotificationItem(id: 'a', title: 'A', body: 'Body A', date: DateTime.now());
    final b = NotificationItem(id: 'b', title: 'B', body: 'Body B', date: DateTime.now());

    await service.saveNotifications([a, b]);
    await service.remove('a');

    final items = await service.getNotifications();
    expect(items.length, 1);
    expect(items.first.id, 'b');
  });

  test('markRead updates the read field correctly', () async {
    final service = NotificationServiceLocal();
    final a = NotificationItem(id: 'a', title: 'A', body: 'Body A', date: DateTime.now(), read: false);

    await service.saveNotifications([a]);
    await service.markRead('a', true);

    var items = await service.getNotifications();
    expect(items.first.read, isTrue);

    await service.markRead('a', false);
    items = await service.getNotifications();
    expect(items.first.read, isFalse);
  });

  test('markAllRead marks all notifications as read', () async {
    final service = NotificationServiceLocal();
    final a = NotificationItem(id: 'a', title: 'A', body: 'Body A', date: DateTime.now(), read: false);
    final b = NotificationItem(id: 'b', title: 'B', body: 'Body B', date: DateTime.now(), read: false);

    await service.saveNotifications([a, b]);
    await service.markAllRead();

    final items = await service.getNotifications();
    expect(items.every((i) => i.read), isTrue);
  });

  test('clearAll removes stored data', () async {
    final service = NotificationServiceLocal();
    final a = NotificationItem(id: 'a', title: 'A', body: 'Body A', date: DateTime.now());

    await service.saveNotifications([a]);

    // ensure stored
    var prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(storageKey), isNotNull);

    await service.clearAll();

    final items = await service.getNotifications();
    expect(items, isEmpty);

    prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(storageKey), isNull);
  });

  test('getNotifications handles corrupt JSON gracefully', () async {
    // seed SharedPreferences with invalid JSON without reinitializing the mock
    final prefsSeed = await SharedPreferences.getInstance();
    await prefsSeed.setString(storageKey, 'not-a-json');

    final service = NotificationServiceLocal();

    final items = await service.getNotifications();
    expect(items, isEmpty);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(storageKey), isNull, reason: 'Corrupt storage should be removed');
  });
}
