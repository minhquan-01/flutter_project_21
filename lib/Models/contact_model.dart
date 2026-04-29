class ContactRequest {
  final String? userId;
  final String name;
  final String email;
  final String phone;
  final String subject;
  final String message;

  ContactRequest({
    this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'subject': subject,
      'message': message,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
