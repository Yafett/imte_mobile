part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class PageLoaded extends LoginEvent {}

class Login extends LoginEvent {
  final String email;
  final String password;

  Login(this.email, this.password);
}
