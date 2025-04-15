class UserEntity {
  final String name;
  final String empNo;
  final String type;

  UserEntity({
    required this.name,
    required this.empNo,
    required this.type,
  });
}

class UserLoginModel {
  final String name;
  final String empNo;

  UserLoginModel({
    required this.name,
    required this.empNo,
  });

  // fromJson method
  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      name: json['name'],
      empNo: json['empNo'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'empNo': empNo,
    };
  }
}
