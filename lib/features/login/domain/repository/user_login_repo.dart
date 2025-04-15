import 'package:fil_pilot/features/login/domain/entities/user_entity.dart';

abstract interface class UserLoginRepo {
  Future<UserEntity?> loginWithNameandNo(String name, String empNo);
}
