import 'package:equatable/equatable.dart';
import 'package:fil_pilot/features/login/domain/entities/user_entity.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;

  LoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class LoginLogout extends LoginState {}
