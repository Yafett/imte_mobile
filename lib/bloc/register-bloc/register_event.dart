part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class Register extends RegisterEvent {
  final String unit;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;

  Register(this.unit, this.firstName, this.lastName, this.email, this.mobile,
      this.password, this.confirmPassword);
}
