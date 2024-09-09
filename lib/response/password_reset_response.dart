class PasswordResetResponse {
  final String? message;
  final bool status;

  PasswordResetResponse({this.message, required this.status});

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetResponse(
        message: json['message'],
        status: json['success']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': status
    };
  }
}