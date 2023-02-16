part of 'enroll_bloc.dart';

abstract class EnrollEvent extends Equatable {
  const EnrollEvent();

  @override
  List<Object> get props => [];
}

class GetEnrollList extends EnrollEvent {}

class GetMoreEnrollList extends EnrollEvent {}