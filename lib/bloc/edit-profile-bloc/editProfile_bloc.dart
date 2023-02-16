import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imte_mobile/resources/profile_provider.dart';

part 'editProfile_event.dart';
part 'editProfile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial()) {
    final _profileProvider = new ProfileProvider();

    on<Edit>((event, emit) async {
      try {
        emit(EditProfileLoading());
        final result = await _profileProvider.editProfile(
            event.firstName,
            event.lastName,
            event.gender,
            event.place,
            event.birth,
            event.mobile,
            event.address,
            event.wali,
            event.city,
            event.noWali);
        if (result == 'Update User Profile Berhasil.') {
          emit(EditProfileSuccess());
        } else {
          emit(EditProfileError(result));
        }
      } on NetworkError {
        emit(EditProfileError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
