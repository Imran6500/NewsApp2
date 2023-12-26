import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channel_api_model.dart';
import 'package:news_app/repositories/newsrepository.dart';
import 'package:news_app/viewModel/category_screen.dart';
import 'package:news_app/viewModel/news_details.dart';
import 'package:news_app/viewModel/news_view_model.dart';

import 'models/news_cateogoy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum FilterList { bbcNews, aryNews, independent, router, cnn, aljazeera }

class _HomePageState extends State<HomePage> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd yyyy');
  String name = 'bbc-News';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()));
            },
            icon: Image.asset('images/category_icon.png'),
          ),
          title: Center(
            child: Text(
              'News',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          actions: [
            PopupMenuButton<FilterList>(
                initialValue: selectedMenu,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                onSelected: (FilterList item) {
                  if (FilterList.bbcNews.name == item.name) {
                    name = 'bbc news';
                  }
                  if (FilterList.aryNews.name == item.name) {
                    name = 'ary-news';
                  }
                  setState(() {
                    selectedMenu = item;
                  });
                },
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem<FilterList>(
                        value: FilterList.bbcNews,
                        child: Text('BBC News'),
                      ),
                      PopupMenuItem<FilterList>(
                        value: FilterList.aryNews,
                        child: Text('Ary News'),
                      ),
                      PopupMenuItem<FilterList>(
                        value: FilterList.aljazeera,
                        child: Text('Aljazeera News'),
                      ),
                      PopupMenuItem<FilterList>(
                        value: FilterList.independent,
                        child: Text('Independent News'),
                      ),
                      PopupMenuItem<FilterList>(
                        value: FilterList.cnn,
                        child: Text('CNN News'),
                      ),
                    ]),
          ]),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChhannelHeadlinesModel>(
                future: NewsViewModel().fetchNewsChannelHeadingApi(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        color: Colors.blue,
                        size: 50,
                      ),
                    );
                  } else {
                    var data = snapshot.data!;

                    return ListView.builder(
                        itemCount: data.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                            newImage: data
                                                .articles![index].urlToImage
                                                .toString(),
                                            newsTitle: data
                                                .articles![index].title
                                                .toString(),
                                            newsDate: data
                                                .articles![index].publishedAt
                                                .toString(),
                                            author: data.articles![index].author
                                                .toString(),
                                            description: data
                                                .articles![index].description
                                                .toString(),
                                            content: data
                                                .articles![index].content
                                                .toString(),
                                            source: data
                                                .articles![index].source!.name
                                                .toString(),
                                          )));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                      height: height * 0.6,
                                      width: width * 0.9,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: height * 0.01,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            child: spinkit2,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                    bottom: 10,
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        height: height * 0.2,
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: width * 0.7,
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
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Text(
                                                      format.format(dateTime),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ]),
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
                }),
          ),
          FutureBuilder<CategoryNewsModel>(
              future: NewsViewModel().fetchcategoryNewsApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50,
                    ),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());

                        return Row(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  height: height * 0.18,
                                  width: width * 0.3,
                                  placeholder: (context, url) => Container(
                                    child: spinkit2,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: height * 0.18,
                                padding: EdgeInsets.only(left: 15),
                                child: Column(children: [
                                  Text(
                                    snapshot.data!.articles![index].title
                                        .toString(),
                                    maxLines: 3,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          format.format(dateTime),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                            )
                          ],
                        );
                      });
                }
              }),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.blue,
  size: 50,
);
