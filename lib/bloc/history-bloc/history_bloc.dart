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
          for (var a = 0; a < history.length; a++) {
            if (history[a].enrollStatus.toString() == '3') {
              emit(HistoryLoaded(history: history, period: period));
              // emit(HistoryEmpty());
              print('romeo');
            } else {  
              emit(HistoryEmpty());
              print('juliet');
            }
          }
        } catch (e) {
          print(state);
          emit(HistoryError(e.toString()));
        }
      }
    });
  }
}
