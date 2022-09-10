import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imte_mobile/models/feed-model.dart';
import 'package:imte_mobile/resources/news_provider.dart';

import '../../models/News-model.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    final _newsProvider = new NewsProvider();

    on<NewsEvent>(
      (event, emit) async {
        if (event is GetNewsList || event is GetMoreNewsList) {
          emit(NewsLoading());
          print('loading');
          try {
            final news = await _newsProvider.fetchNewsList();
            emit(NewsLoaded(news: news));
            print('loaded');
          } catch (e) {
            emit(NewsError(e.toString()));
          }
        }
      },
    );
  }
}
