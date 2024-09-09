class AuthResponse {
  final String? token;
  final String? message;

  AuthResponse({this.token, this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['access_token'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'error_message': message,
    };
  }
}
