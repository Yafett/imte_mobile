import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imte_mobile/bloc/news-bloc/news_bloc.dart';
import 'package:imte_mobile/models/News-model.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:imte_mobile/widget/news-card.dart';
import 'package:intl/intl.dart';

import 'news-detail-page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsBloc _newsBloc = NewsBloc();

  @override
  void initState() {
    super.initState();
    _newsBloc.add(GetNewsList());
  }

  @override
  Widget build(BuildContext context) {
    return _buildNewsPage();
  }

  Widget _buildNewsPage() {
    return Scaffold(
      body: Scaffold(
        body: BlocBuilder<NewsBloc, NewsState>(
          bloc: _newsBloc,
          builder: (context, state) {
            if (state is NewsLoaded) {
              News news = state.news[0];
              print(news.filename);
              return Column(
                children: [
                  _buildHeader(news),
                  _buildNewsList(state),
                ],
              );
            } else if (state is NewsError) {
              return Center(
                child: Text(state.message.toString()),
              );
            } else {
              print('not loaded');
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildNewsList(state) {
    return RefreshIndicator(
      onRefresh: () async => context.read<NewsBloc>().add(GetMoreNewsList()),
      child: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height * 0.50,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: state.news.length,
            itemBuilder: (context, index) {
              News news = state.news[index];
              return _buildNewsCard(news);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(news) {
    DateTime dt = DateTime.parse(news.createdAt);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              newsImage:
                  'https://adm.imte.education/img/BlogImages/' + news.filename,
              newsTitle: news.title,
              newsDate: DateFormat.yMMMd().format(dt),
              newsUser: news.firstName,
              newsContent: news.content,
            ),
          ),
        );
      },
      child: Container(
          padding: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height * 0.5 - 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                  BlendMode.darken),
              image: new NetworkImage(
                'https://adm.imte.education/img/BlogImages/' + news.filename,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                news.title,
                textAlign: TextAlign.start,
                style:
                    whiteTextStyle.copyWith(fontSize: 28, fontWeight: semiBold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'see more',
                    style: whiteTextStyle.copyWith(
                        fontSize: 16, fontWeight: semiBold),
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildNewsCard(news) {
    DateTime dt = DateTime.parse(news.createdAt);

    return newsCard(
      image: Image.network(
          'https://adm.imte.education/img/BlogImages/' + news.filename),
      newsTitle: news.title,
      newsDate: DateFormat.yMMMd().format(dt),
      newsImage: 'https://adm.imte.education/img/BlogImages/' + news.filename,
      newsUser: news.firstName,
      newsContent: news.content,
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
