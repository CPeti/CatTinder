import 'package:flutter/material.dart';
import 'package:cat_tinder/db_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LikedImagesPage extends StatefulWidget {
  @override
  _LikedImagesPageState createState() => _LikedImagesPageState();
}

class _LikedImagesPageState extends State<LikedImagesPage> {
  List<String> _likedUrls = [];
  int? _selectedImageIndex;

  @override
  void initState() {
    super.initState();
    _loadLikedUrls();
  }

  Future<void> _loadLikedUrls() async {
    List<String> urls = await DatabaseHelper.instance.getUrls('liked_images');
    //reverse the list so that the most recent liked image is at the top
    urls = urls.reversed.toList();
    setState(() {
      _likedUrls = urls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          expandedHeight: 200.0,
          leadingWidth: 100,
          snap: false,
          floating: false,
          pinned: false,
          flexibleSpace: FlexibleSpaceBar(
            // Background image,
            centerTitle: true,
            //pink text
            title: Padding(
              padding: EdgeInsets.only(right: 50.0),
              child: Text(
                'Liked cats',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //use pink 200
                  color: Colors.pink.shade200,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            background: Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 90.0),
              child: SvgPicture.asset(
                'images/top.svg',
                width: 40,
                // Optionally set height if needed
              ),
            ),
            // Centered title
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedImageIndex == index) {
                      _selectedImageIndex = null; // Deselect image
                    } else {
                      _selectedImageIndex = index; // Select new image
                    }
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _likedUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Text('Image not available'));
                          },
                        ),
                      ),
                      if (_selectedImageIndex == index)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey, // Gray background
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors
                                        .white), // White icon for better contrast
                                onPressed: () {
                                  // remove from liked images
                                  DatabaseHelper.instance.deleteUrl(
                                      'liked_images', _likedUrls[index]);
                                  _loadLikedUrls();
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            childCount: _likedUrls.length,
          ),
        ),
      ],
    );
  }
}
