// ignore_for_file: must_be_immutable

part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<News> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  List<News> news;
  List<Feed>? feed;

  NewsLoaded({required this.news, this.feed});
}

class NewsError extends NewsState {
  final String? message;
  const NewsError(this.message);
}
