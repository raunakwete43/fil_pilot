import 'package:fil_pilot/features/login/domain/repository/user_login_repo.dart';
import 'package:fil_pilot/features/login/presentation/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserLoginRepo userLoginRepo;
  LoginCubit({required this.userLoginRepo}) : super(LoginInitial());

  Future<void> loginWithNameandNo(String name, String empNo) async {
    try {
      emit(LoginLoading());
      final user = await userLoginRepo.loginWithNameandNo(name, empNo);

      if (user != null) {
        emit(LoginSuccess(user: user));
      } else {
        emit(LoginFailure(error: "Login failed. Invalid credentials."));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
      emit(LoginInitial());
    }
  }

  Future<void> logout() async {
    emit(LoginLogout());
  }
}
