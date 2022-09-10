part of 'editProfile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class PageLoaded extends EditProfileEvent {}

class Edit extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final String gender;
  final String place;
  final String birth;
  final String mobile;
  final String address;
  final String wali;
  final String city;
  final String noWali;

  Edit(
    this.firstName,
    this.lastName,
    this.gender,
    this.place,
    this.birth,
    this.mobile,
    this.address,
    this.wali,
    this.city,
    this.noWali,
  );
}
