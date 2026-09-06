// lib/models/notification_item.dart
//
// Modelo de notificación usado por el módulo de notificaciones.

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.read = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? date,
    bool? read,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'date': date.toIso8601String(),
        'read': read,
      };

  factory NotificationItem.fromJson(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      date: DateTime.parse(map['date'] as String),
      read: map['read'] as bool? ?? false,
    );
  }

  @override
  String toString() => 'NotificationItem(id: $id, title: $title, read: $read)';

  @override
  bool operator ==(Object other) => identical(this, other) || (other is NotificationItem && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
