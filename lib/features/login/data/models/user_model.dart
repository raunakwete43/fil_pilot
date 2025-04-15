class UserModel {
  final String name;
  final String empNo;
  final String type;

  UserModel({
    required this.name,
    required this.empNo,
    required this.type,
  });

  // fromJson method
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      empNo: json['empNo'],
      type: json['type'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'empNo': empNo,
      'type': type,
    };
  }
}
