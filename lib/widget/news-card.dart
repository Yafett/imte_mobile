import 'package:flutter/material.dart';
import 'package:imte_mobile/shared/theme.dart';

import '../pages/News/news-detail-page.dart';

class newsCard extends StatelessWidget {
  const newsCard({
 
    required this.image,
    required this.newsTitle,
    required this.newsDate,
    required this.newsImage,
    required this.newsUser,
    required this.newsContent,
  });

 
  final String newsDate;
  final String newsTitle;
  final String newsUser;
  final String newsImage;
  final String newsContent;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewsDetailPage(
                      newsImage: newsImage,
                      newsTitle: newsTitle,
                      newsDate: newsDate,
                      newsUser: newsUser,
                      newsContent: newsContent,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: radiusNormal,
              ),
              child: ClipRRect(
                borderRadius: radiusNormal, // Image border
                child: SizedBox.fromSize(
                  size: Size.fromRadius(48), // Image radius
                  child: image,
                ),
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  new Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: new EdgeInsets.only(right: 13.0),
                    child: new Text(newsTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                            letterSpacing: 0.5)),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 80,
                                  child: Text(
                                    newsUser,
                                    style: greyTextStyle.copyWith(),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width: 80,
                                  child: Text(
                                    newsDate,
                                    style: greyTextStyle.copyWith(),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
