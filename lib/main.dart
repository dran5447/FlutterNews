import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';

import 'config.dart'; // Local config file with keys

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new
  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      key: _scaffoldKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: new Column(
            children: <Widget>[
              new Text('Powered by NewsAPI'),
              new Expanded(
                child: Center(
                  child: FutureBuilder<Response>(
                    future: fetchPost(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) { //render results on success
                        return new ListView.builder(
                          itemCount: snapshot.data.articles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Column(
                              children: <Widget>[
                                new Container(
                                  height: 150.0,
                                  padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: new ListTile(
                                    isThreeLine: true,
                                    title: Text(snapshot.data.articles[index].title,
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
                                    subtitle: Text(snapshot.data.articles[index].publishDate),
                                    leading:new CircleAvatar(
                                      maxRadius: 50.0,
                                      backgroundImage: new NetworkImage(snapshot.data.articles[index].imageUrl),
                                    ),
                                    onTap: () {
                                      launch(snapshot.data.articles[index].url);
                                    },
                                  ),
                                ),

                                new Divider(height: 2.0,),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) { //on error, show error text
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner
                      return CircularProgressIndicator();
                    },
                  ),

                ),
              ),
              ],
        ),
      ),
    );
  }
}



Future<Response> fetchPost() async {
  final ConfigOptions config = new ConfigOptions();

  // Using NewsAPI -  https://newsapi.org/
  final response =
    await http.get('https://newsapi.org/v2/top-headlines?country=us&apiKey=' + config.getNewsAPIKey);

  if (response.statusCode == 200) {
    // on success, parse JSON
    return Response.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class Response {
  final int totalResults;
  final List<Article> articles;

  Response({this.totalResults, this.articles});

  factory Response.fromJson(Map<String, dynamic> json){
    var list = json['articles'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Article> articlesList = list.map((i) => Article.fromJson(i)).toList();

    return Response(
      totalResults: json['totalResults'],
      articles: articlesList
    );
  }
}

class Article {
  final String author;
  final String title;
  final String desc;
  final String url;
  final String imageUrl;
  final String publishDate;

  Article({this.author, this.title, this.desc, this.url, this.imageUrl, this.publishDate});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      author: json['author'],
      title: json['title'],
      desc: json['description'],
      url: json['url'],
      imageUrl: json['urlToImage'],
      publishDate: json['publishedAt']
    );
  }
}
