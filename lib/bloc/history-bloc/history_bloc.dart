import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imte_mobile/models/history-model.dart';
import 'package:imte_mobile/resources/enroll_provider.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    final _enrollProvider = EnrollProvider();

    on<HistoryEvent>((event, emit) async {
      if (event is GetHistoryList || event is GetMoreHistoryList) {
        emit(HistoryLoading());
        try {
          final history = await _enrollProvider.fetchEnroll();
          final period = await _enrollProvider.fetchPeriod();
          if (history.length == 0) {
            emit(HistoryEmpty());
            print(state);
          } else {
            emit(HistoryLoaded(history: history, period: period));
            print(state);
          }
        } catch (e) {
          print(state);

          emit(HistoryError(e.toString()));
        }
      }
    });
  }
}
