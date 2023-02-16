// ignore_for_file: must_be_immutable

part of 'enroll_bloc.dart';

abstract class EnrollState extends Equatable {
  const EnrollState();

  @override
  List<Object> get props => [];
}

class EnrollInitial extends EnrollState {}

class EnrollLoading extends EnrollState {}

class EnrollLoaded extends EnrollState {
  List<History> enroll;
  List<Period> period;

  EnrollLoaded({required this.enroll, required this.period});
}

class EnrollEmpty extends EnrollState {}

class EnrollError extends EnrollState {
  final String? message;
  EnrollError(this.message);
}
