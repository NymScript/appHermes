class AuthLogin {
  final int document;
  final String password;

  AuthLogin({required this.document, required this.password, requi});

  /// Converts JSON data to an `AuthLogin` instance.
  factory AuthLogin.fromJson(Map<String, dynamic> json) {
    return AuthLogin(
      document: json['document'],
      password: json['password'],
    );
  }

  /// Converts `AuthLogin` instance to JSON format, suitable for API requests.
  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'password': password,
    };
  }
}
