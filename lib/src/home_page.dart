import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gmaps/components/websitesviewer/webs_viewing.dart';
import 'package:gmaps/models/categories_news_model.dart';
import 'package:gmaps/models/news_channel_headlines_model.dart';
import 'package:gmaps/src/categories_screen.dart';
import 'package:gmaps/src/news_detail_screen.dart';
import 'package:gmaps/theme/theme_provider.dart';
import 'package:gmaps/view_model/news_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum NewsFilterList { bbcNews, aryNews, cryptoNews, cbc, alJazeera }

class _HomePageState extends State<HomePage> {
  NewsViewModel newsViewModel = NewsViewModel();
  NewsFilterList? selectedMenu;
  String name = 'bbc-news';
  final format = DateFormat('MMMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoriesScreen(),
              ),
            );
          },
          icon: Image.asset(
            "images/category_icon.png",
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          "News",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(Icons.dark_mode),
          ),
          PopupMenuButton<NewsFilterList>(
            onSelected: (NewsFilterList item) {
              if (NewsFilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (NewsFilterList.aryNews.name == item.name) {
                name = 'ary-news';
              }
              if (NewsFilterList.alJazeera.name == item.name) {
                name = 'al-jazeera-english';
              }
              if (NewsFilterList.cbc.name == item.name) {
                name = 'cbc-news';
              }
              if (NewsFilterList.cryptoNews.name == item.name) {
                name = 'crypto-coins-news';
              }

              setState(() {
                selectedMenu = item;
              });
            },
            initialValue: selectedMenu,
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) => <PopupMenuEntry<NewsFilterList>>[
              PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.bbcNews,
                child: Text(
                  "BBC News",
                ),
              ),
              PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.aryNews,
                child: Text(
                  "ARY News",
                ),
              ),
              PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.alJazeera,
                child: Text(
                  "AlJazeera News",
                ),
              ),
              PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.cbc,
                child: Text(
                  "Cbc News",
                ),
              ),
              PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.cryptoNews,
                child: Text(
                  "Crypto News",
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Color.fromARGB(255, 96, 232, 239),
                      size: 40,
                    ),
                  );
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return InkWell(
                          onTap: () {
                            //Navigation to NEWS DETAIL
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewsDetailScreen(
                                  newsIMG: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  newsTitle: snapshot
                                      .data!.articles![index].title
                                      .toString(),
                                  newsDate: snapshot
                                      .data!.articles![index].publishedAt
                                      .toString(),
                                  authors: snapshot
                                      .data!.articles![index].author
                                      .toString(),
                                  newsDescription: snapshot
                                      .data!.articles![index].description
                                      .toString(),
                                  content: snapshot
                                      .data!.articles![index].content
                                      .toString(),
                                  source: snapshot
                                      .data!.articles![index].source!.name
                                      .toString(),
                                  webURL: snapshot.data!.articles![index].url
                                      .toString(),
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * .02,
                                  ),
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  child: snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? SpinKitCircle(
                                          color: Colors.red,
                                          size: 30,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data!
                                                .articles![index].urlToImage
                                                .toString(),
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              child: SpinKitFadingCircle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      alignment: Alignment.bottomCenter,
                                      height: height * .22,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * .7,
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * .7,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi("General"),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Color.fromARGB(255, 96, 232, 239),
                      size: 40,
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: snapshot
                                    .data!.articles![index].urlToImage
                                    .toString(),
                                fit: BoxFit.cover,
                                height: height * .18,
                                width: width * .3,
                                placeholder: (context, url) => Container(
                                  child: SpinKitFadingCircle(
                                    color: Colors.grey,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: height * .18,
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      maxLines: 3,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => WebsitesClones(
                                              webURL: snapshot
                                                  .data!.articles![index].url
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Read More",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Read More",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          format.format(dateTime),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
