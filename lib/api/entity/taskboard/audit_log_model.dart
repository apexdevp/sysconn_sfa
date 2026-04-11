class Log {
  final String createdDate; // e.g., "02-04-2026"
  final String createdTime; // e.g., "09:52"
  final String activity;
  final String description;

  Log({
    required this.createdDate,
    required this.createdTime,
    required this.activity,
    required this.description,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      createdDate: json['created_date'] ?? '',
      createdTime: json['created_time'] ?? '',
      activity: json['activity'] ?? '',
      description: json['description'] ?? '',
    );
  }
}