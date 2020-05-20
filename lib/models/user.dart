class User {
  String name;
  String email;
  String password;

  User({this.name, this.email, this.password});

  User.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.email = json['email'];
    this.password = json['password'];
  }

  Map<String, dynamic> toJsonRegister() {
    return {
      'name': this.name,
      'email': this.email,
      'password': this.password,
    };
  }

  Map<String, dynamic> toJsonLogin() {
    return {
      'email': this.email,
      'password': this.password,
    };
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, password: $password}';
  }
}
