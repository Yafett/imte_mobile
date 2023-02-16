part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<News> get props => [];
}

class GetNewsList extends NewsEvent {}

class GetMoreNewsList extends NewsEvent {}
