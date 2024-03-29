import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imte_mobile/models/history-model.dart';
import 'package:imte_mobile/resources/enroll_provider.dart';

part 'enroll_event.dart';
part 'enroll_state.dart';

class EnrollBloc extends Bloc<EnrollEvent, EnrollState> {
  EnrollBloc() : super(EnrollInitial()) {
    final _enrollProvider = EnrollProvider();

    on<EnrollEvent>((event, emit) async {
      if (event is GetEnrollList || event is GetMoreEnrollList) {
        emit(EnrollLoading());
        try {
          final enroll = await _enrollProvider.fetchEnroll();
          final period = await _enrollProvider.fetchPeriod();
          if (enroll.length == 0) {
            emit(EnrollEmpty());
            print(state);
          } else {
            emit(EnrollLoaded(enroll: enroll, period: period));
          }
        } catch (e) {
          emit(EnrollError(e.toString()));
        }
      }
    });
  }
}
