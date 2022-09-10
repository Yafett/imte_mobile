import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imte_mobile/resources/auth_provider.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    final _authRepository = AuthProvider();

    on<Login>((event, emit) async {
      try {
        emit(LoginLoading());
        final result = await _authRepository.login(event.email, event.password);
        if (result == 'User authentication failed.' ||
            result == 'The given data was invalid.') {
          emit(LoginError(result));
        } else {
          emit(LoginSuccess());
        }
      } on NetworkError {
        emit(LoginError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
