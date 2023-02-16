// ignore_for_file: must_be_immutable

part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  List<History> history;
  List<Period> period;

  HistoryLoaded({required this.history, required this.period});
}

class HistoryEmpty extends HistoryState {}

class HistoryError extends HistoryState {
  final String? message;
  HistoryError(this.message);
}
