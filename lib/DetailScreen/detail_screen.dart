import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String image;

  DetailScreen({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarks') ?? [];
    setState(() {
      isBookmarked = bookmarks.contains(widget.title);
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarks') ?? [];

    if (isBookmarked) {
      bookmarks.remove(widget.title);
    } else {
      bookmarks.add(widget.title);
    }

    await prefs.setStringList('bookmarks', bookmarks);
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  Future<void> _shareDestination() async {
    final String message =
        'Check out this place: ${widget.title} - ${widget.description}';
    await Share.share(message);
  }

  Future<void> _showRatingDialog() async {
    double rating = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate this Destination'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.0,
                unratedColor: Colors.grey,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Leave a comment'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Simpan rating dan komentar di tempat yang sesuai (misalnya, database)
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar utama dengan dekorasi
            Container(
              width: double.infinity,
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Icon(Icons.broken_image, size: 50));
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite,
                                color:
                                    isBookmarked ? Colors.red : Colors.white),
                            onPressed: _toggleBookmark,
                          ),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.white),
                            onPressed: _shareDestination,
                          ),
                          IconButton(
                            icon: Icon(Icons.star, color: Colors.white),
                            onPressed: _showRatingDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            // Card untuk konten informasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
