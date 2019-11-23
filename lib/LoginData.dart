class LoginData {
  String token;
  String name;
  String email;
  bool isAdmin;
  String message;

  LoginData({this.token, this.name, this.email, this.isAdmin, this.message});

  LoginData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    email = json['email'];
    isAdmin = json['isAdmin'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['name'] = this.name;
    data['email'] = this.email;
    data['isAdmin'] = this.isAdmin;
    data['message'] = this.message;
    return data;
  }
}
