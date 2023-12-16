// ignore_for_file: depend_on_referenced_packages

import 'package:cat_tinder/pages/image_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'image_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cat_tinder/db_helper.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  Key imageKey = UniqueKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (ref.read(imageProvider).isEmpty) {
      setState(() {
        // Refresh the image data
        ref.read(imageProvider.notifier).fetchImages();
        // Generate a new key for the image widget
        imageKey = UniqueKey();
      });
    }
  }

  void _fetchNewImage() {
    setState(() {
      // Refresh the image data
      ref.read(imageProvider.notifier).fetchImages();
      // Generate a new key for the image widget
      imageKey = UniqueKey();
      var images = ref.read(imageProvider);
    });
  }

  void saveDisliked() async {
    // Dislike action
    // save the image to the disliked list
    String url = ref.read(imageProvider)[0].url;
    await DatabaseHelper.instance.insertUrl('disliked_images', url);
  }

  void saveLiked() async {
    // Like action
    // save the image to the liked list
    String url = ref.read(imageProvider)[0].url;
    await DatabaseHelper.instance.insertUrl('liked_images', url);
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imageProvider);

    return Column(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          child: SvgPicture.asset('images/top.svg', width: 80
              // Optionally set height if needed
              ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Align(
          alignment: Alignment.center,
          child: IntrinsicWidth(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                borderRadius:
                    BorderRadius.circular(10.0), // Match the ClipRRect's radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.5), // Shadow color and opacity
                    spreadRadius: 2, // Extent of the shadow
                    blurRadius: 8, // Blur effect
                    offset: const Offset(0, 3), // Changes position of shadow
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
                          maxHeight: MediaQuery.of(context).size.height /
                              2.2, // Set the maximum height for the image
                        ),
                        //load precached image
                        child: images.isNotEmpty
                            ? Image.network(images[0].url, key: imageKey)
                            : CircularProgressIndicator(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(
                          10.0), // Add padding inside the card
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: SvgPicture.asset('images/x.svg'),
                            onPressed: () {
                              // Dislike action
                              saveDisliked();
                              _fetchNewImage();
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset('images/heart.svg'),
                            onPressed: () {
                              // Like action
                              saveLiked();
                              _fetchNewImage();
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
      const Padding(
        padding: EdgeInsets.only(left: 60.0, right: 60, top: 20, bottom: 20),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "To like picture of cat click on heart, or swipe right",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
    ]);
  }
}
