import 'dart:convert';

import 'package:imte_mobile/models/News-model.dart';
import 'package:http/http.dart' as http;
import 'package:imte_mobile/models/feed-model.dart';

class NewsProvider {
  final String urlNews = "https://adm.imte.education/api/blog/showAll";
  final String urlFeed = "https://adm.imte.education/api/setup";

  Future<List<News>> fetchNewsList() async {
    try {
      final uri = Uri.parse(urlNews);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final news = json.map((e) => News.fromJson(e)).toList();
        return news;
      } else {
        throw Exception("Failed to load News");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Feed>> fetchFeedList() async {
    try {
      final uri = Uri.parse(urlFeed);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final feed = json.map((e) => Feed.fromJson(e)).toList();
        return feed;
      } else {
        throw Exception("Failed to load Feed");
      }
    } catch (e) {
      rethrow;
    }
  }
}
