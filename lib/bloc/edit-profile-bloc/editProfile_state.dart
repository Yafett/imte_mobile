part of 'editProfile_bloc.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();
  
  @override
  List<Object> get props => [];
}


class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileError extends EditProfileState {
  final String? message;
  EditProfileError(this.message);
}
