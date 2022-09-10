import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imte_mobile/models/profile-model.dart';
import 'package:imte_mobile/resources/profile_provider.dart';

part 'getProfile_event.dart';
part 'getProfile_state.dart';

class GetProfileBloc extends Bloc<ProfileEvent, GetProfileState> {
  GetProfileBloc() : super(GetProfileInitial()) {
    final _profileProvider = new ProfileProvider();

    on<GetProfileList>(
      (event, emit) async {
        try {
          emit(GetProfileLoading());
          final pList = await _profileProvider.fetchProfileList();
          emit(GetProfileLoaded(pList));
          if (pList.error != null) {
            emit(GetProfileError(pList.error));
          }
        } on NetworkError {
          emit(const GetProfileError(
              "Failed to fetch data. is your device online?"));
        }
      },
    );
  }
}
