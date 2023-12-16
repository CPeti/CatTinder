import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

String apiKey =
    'live_4SVYc2ZmWrRkkDlhTeSoC4DfbXilUD4JiZZ1gn2rXFYrx4a4hyNkX3viXFLKUQWb';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int currentIndex = 0;
  int limit = 10;
  List<dynamic> catImages = [];

  @override
  void initState() {
    super.initState();
    fetchCatImagesInit();
  }

  Future<void> fetchCatImages() async {
    var response = await http.get(Uri.parse(
        'https://api.thecatapi.com/v1/images/search?limit=$limit&api_key=$apiKey'));

    if (response.statusCode == 200) {
      catImages = json.decode(response.body);
      //precache all the images
      catImages.forEach((catImage) {
        precacheImage(NetworkImage(catImage['url']), context);
      });
    } else {
      // Handle the case when the API is not reachable or returns a non-200 status code
      print('Failed to load cat images');
    }
  }

  //update state function
  void updateState() {
    setState(() {
      _swipeItems = catImages.map((catImage) {
        return SwipeItem(
          content: Content(url: catImage['url']),
          likeAction: () {
            currentIndex++;
            if (currentIndex == limit - 1) {
              fetchCatImages();
            }
            //print("Liked ${catImage['id']}");
          },
          nopeAction: () {
            currentIndex++;
            if (currentIndex == limit - 1) {
              fetchCatImages();
            }
            //print("Nope ${catImage['id']}");
          },
        );
      }).toList();

      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
  }

  Future<void> fetchCatImagesInit() async {
    var response = await http.get(Uri.parse(
        'https://api.thecatapi.com/v1/images/search?limit=$limit&api_key=$apiKey'));

    if (response.statusCode == 200) {
      catImages = json.decode(response.body);
      //precache all the images
      catImages.forEach((catImage) {
        precacheImage(NetworkImage(catImage['url']), context);
      });
    } else {
      // Handle the case when the API is not reachable or returns a non-200 status code
      print('Failed to load cat images');
    }
    //print(catImages.length);
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //appBar: AppBar(
      //  title: Text('Cat photos'),
      //  leading: const Icon(Icons.favorite, color: Colors.white),
      //  backgroundColor: Colors.pink[200],
      //),
      body: Stack(children: [
        // Gradient background

        Container(
          //height: MediaQuery.of(context).size.height / 4 * 3,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 220, 239),
                Colors.white
              ], // Gradient from pink to white
            ),
          ),
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 30, bottom: 0),
                child: SvgPicture.asset('images/top.svg', width: 80
                    // Optionally set height if needed
                    ),
              ),
            ),
            Expanded(
              // Use Expanded to take up all available space except for the BottomAppBar
              child: _swipeItems.isNotEmpty
                  ? Center(
                      child: SwipeCards(
                        matchEngine: _matchEngine,
                        itemBuilder: (BuildContext context, int index) {
                          // check if card is on top of stack
                          return Visibility(
                            visible: index == currentIndex,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0), // Add horizontal space
                              child: Align(
                                alignment: Alignment.center,
                                child: IntrinsicWidth(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set the background color to white
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Match the ClipRRect's radius
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.5), // Shadow color and opacity
                                          spreadRadius:
                                              2, // Extent of the shadow
                                          blurRadius: 8, // Blur effect
                                          offset: const Offset(0,
                                              3), // Changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Set the desired radius for corners of the image
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxHeight: MediaQuery.of(
                                                            context)
                                                        .size
                                                        .height /
                                                    2.2, // Set the maximum height for the image
                                              ),
                                              //load precached image
                                              child: Image(
                                                image: NetworkImage(
                                                    _swipeItems[index]
                                                        .content
                                                        .url),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(
                                                10.0), // Add padding inside the card
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                IconButton(
                                                  icon: SvgPicture.asset(
                                                      'images/x.svg'),
                                                  onPressed: () {
                                                    // Dislike action
                                                    _matchEngine.currentItem
                                                        ?.nope();
                                                  },
                                                ),
                                                IconButton(
                                                  icon: SvgPicture.asset(
                                                      'images/heart.svg'),
                                                  onPressed: () {
                                                    // Like action
                                                    _matchEngine.currentItem
                                                        ?.like();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        onStackFinished: () {
                          currentIndex = 0;
                          // Load more images
                          updateState();
                        },
                      ),
                    )
                  : const CircularProgressIndicator(), // Show a loading indicator while the images are being fetched
            ),
          ],
        ),
      ]),
    );
  }
}

class Content {
  final String url;
  Content({required this.url});
}
