class ComplaintModel {
  final String id;
  final String userId;
  final String userName;
  final String message;
  final DateTime timestamp;
  final bool isResolved;

  ComplaintModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.message,
    required this.timestamp,
    this.isResolved = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isResolved': isResolved,
    };
  }

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isResolved: json['isResolved'] ?? false,
    );
  }

  ComplaintModel markAsResolved() {
    return ComplaintModel(
      id: id,
      userId: userId,
      userName: userName,
      message: message,
      timestamp: timestamp,
      isResolved: true,
    );
  }

  bool isNew() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inHours < 24;
  }

  String getStatusText() {
    return isResolved ? 'Selesai' : 'Pending';
  }

  ComplaintModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? message,
    DateTime? timestamp,
    bool? isResolved,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isResolved: isResolved ?? this.isResolved,
    );
  }
}