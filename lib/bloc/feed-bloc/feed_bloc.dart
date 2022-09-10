import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imte_mobile/models/feed-model.dart';
import 'package:imte_mobile/resources/news_provider.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    final _newsProvider = new NewsProvider();
    on<FeedEvent>((event, emit) async {
      if (event is GetFeedList) {
        emit(FeedLoading());
        print('loading');
        try {
          final feed = await _newsProvider.fetchFeedList();
          emit(FeedLoaded(feed: feed));
          print('loaded');
        } catch (e) {
          emit(FeedError(e.toString()));
        }
      }
    });
  }
}
