// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cat_tinder/db_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DislikedImagesPage extends StatefulWidget {
  const DislikedImagesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DislikedImagesPageState createState() => _DislikedImagesPageState();
}

class _DislikedImagesPageState extends State<DislikedImagesPage> {
  List<String> _dislikedUrls = [];
  int? _selectedImageIndex;

  @override
  void initState() {
    super.initState();
    _loadDislikedUrls();
  }

  Future<void> _loadDislikedUrls() async {
    List<String> urls =
        await DatabaseHelper.instance.getUrls('disliked_images');
    //reverse the list so that the most recent disliked image is at the top
    urls = urls.reversed.toList();
    setState(() {
      _dislikedUrls = urls;
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
          snap: false,
          floating: false,
          pinned: false,
          flexibleSpace: FlexibleSpaceBar(
            // Background image,
            centerTitle: true,
            //pink text
            title: Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Text(
                'Disliked cats',
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
                  margin: const EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _dislikedUrls[index],
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
                                  // remove from disliked images
                                  DatabaseHelper.instance.deleteUrl(
                                      'disliked_images', _dislikedUrls[index]);
                                  _loadDislikedUrls();
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
            childCount: _dislikedUrls.length,
          ),
        ),
      ],
    );
  }
}
