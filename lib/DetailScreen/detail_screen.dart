import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RatingDatabase {
  static final RatingDatabase instance = RatingDatabase._init();

  static Database? _database;

  RatingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ratings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ratings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        destination TEXT,
        rating REAL,
        comment TEXT
      )
    ''');
  }

  Future<void> insertRating(
      String destination, double rating, String comment) async {
    final db = await instance.database;
    await db.insert('ratings',
        {'destination': destination, 'rating': rating, 'comment': comment});
  }

  Future<List<Map<String, dynamic>>> fetchRatings() async {
    final db = await instance.database;
    return db.query('ratings');
  }
}

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

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  bool isBookmarked = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _checkBookmark();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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

    _controller.forward();
    await Future.delayed(Duration(milliseconds: 300));
    _controller.reverse();
  }

  Future<void> _shareDestination() async {
    final String message =
        'Check out this place: ${widget.title} - ${widget.description}';
    await Share.share(message);
  }

  Future<void> _showRatingDialog() async {
    double rating = 0;
    showDialog(
      context: context, // Pastikan context di sini adalah BuildContext
      builder: (BuildContext context) {
        // Gunakan BuildContext dalam builder
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
                Navigator.of(context)
                    .pop(); // pastikan context yang digunakan adalah BuildContext
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rating berhasil'),
          content:
              Text('Terima kasih telah memberi rating pada destinasi ini.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
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
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(
                isBookmarked ? Icons.favorite : Icons.favorite_border,
                key: ValueKey<bool>(isBookmarked),
                color: isBookmarked ? Colors.red : Colors.white,
              ),
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.title,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: widget.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/placeholder.png');
                },
              ),
            ),
            SizedBox(height: 16),
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
