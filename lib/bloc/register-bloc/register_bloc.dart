import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imte_mobile/resources/auth_provider.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    final _authProvider = new AuthProvider();

    on<Register>((event, emit) async {
      try {
        emit(RegisterLoading());
        final result = await _authProvider.register(
            event.firstName,
            event.lastName,
            event.unit,
            event.email,
            event.mobile,
            event.password,
            event.confirmPassword);
        if (result == 'User Register Successful.') {
          emit(RegisterSuccess());
        } else {
          emit(RegisterError(result));
        }
      } on NetworkError {
        emit(RegisterError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
