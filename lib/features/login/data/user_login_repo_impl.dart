import 'package:fil_pilot/features/login/data/datasources/fastapi_login_datasource.dart';
import 'package:fil_pilot/features/login/domain/entities/user_entity.dart';
import 'package:fil_pilot/features/login/domain/repository/user_login_repo.dart';
import 'package:fil_pilot/main.dart';

class UserLoginRepoImpl implements UserLoginRepo {
  final FastapiLoginDatasource fastapiLoginDatasource =
      FastapiLoginDatasource(baseUrl: baseUrl);

  @override
  Future<UserEntity?> loginWithNameandNo(String name, String empNo) async {
    try {
      final body = await fastapiLoginDatasource.loginWithNameandNo(name, empNo);

      if (body == null) {
        return null;
      }
      final UserEntity user = UserEntity(
          name: body['name'], empNo: body['empNo'], type: body['type']);
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
