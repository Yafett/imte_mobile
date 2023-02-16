// ignore_for_file: must_be_immutable

part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  List<Feed> feed;

  FeedLoaded({required this.feed});
}

class FeedError extends FeedState {
  final String? message;
  const FeedError(this.message);
}
