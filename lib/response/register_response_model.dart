class RegisterResponse {
  final String? message;

  RegisterResponse({this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
        message: json['message']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message
    };
  }
}