part of 'getProfile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<GetProfile> get props => [];
}

class GetProfileList extends ProfileEvent {}
