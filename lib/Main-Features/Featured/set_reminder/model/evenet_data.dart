// models/event_data.dart
class EventData {
  int? id; // Auto-generated ID for the event in the database
  String name;
  DateTime startDate;
  DateTime endDate;

  EventData({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  // Convert the EventData object to a map for saving to the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  // Create an EventData object from a map retrieved from the database
  static EventData fromMap(Map<String, dynamic> map) {
    return EventData(
      id: map['id'],
      name: map['name'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }
}
