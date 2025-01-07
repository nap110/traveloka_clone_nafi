import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, String>> items = [
    {
      "title": "Jakarta",
      "description": "Ibukota negara Indonesia yang ramai dan modern.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/b/b6/Jakarta_skyline.jpg"
    },
    {
      "title": "Bandung",
      "description": "Kota dengan iklim sejuk dan pegunungan yang indah.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/c/c7/Bandung_Skyline.jpg"
    },
    {
      "title": "Yogyakarta",
      "description": "Kota budaya dan sejarah yang terkenal dengan keraton.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/7/72/Kraton_Yogyakarta.jpg"
    },
    {
      "title": "Surabaya",
      "description": "Kota industri dan pelabuhan utama di Indonesia.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/d/d7/Surabaya_Skyline.jpg"
    },
    {
      "title": "Malang",
      "description": "Kota wisata dengan banyak destinasi alam yang menarik.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/7/79/Malang_Town.jpg"
    },
    {
      "title": "Semarang",
      "description": "Kota dengan sejarah kolonial Belanda dan kuliner lezat.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/f/f1/Semarang_city_view.jpg"
    },
    {
      "title": "Bogor",
      "description":
          "Kota hujan yang terkenal dengan kebun raya dan cuaca sejuk.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/e/ee/Bogor_Botanical_Gardens.jpg"
    },
    {
      "title": "Cirebon",
      "description": "Kota dengan pengaruh budaya yang kaya dan makanan lezat.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/1/1c/Cirebon_Castle.jpg"
    },
    {
      "title": "Kota Tua Jakarta",
      "description":
          "Kawasan bersejarah di Jakarta dengan arsitektur kolonial.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/c/c1/Kota_Tua_Jakarta.jpg"
    },
    {
      "title": "Pekalongan",
      "description": "Kota yang terkenal dengan batik dan kerajinan tangan.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/6/60/Pekalongan_Batik.jpg"
    },
    {
      "title": "Cimahi",
      "description":
          "Kota kecil dekat Bandung yang memiliki pemandangan indah.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/8/81/Cimahi_City_Skyline.jpg"
    },
    {
      "title": "Sukabumi",
      "description": "Kota yang dikelilingi oleh alam dan pegunungan.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/5/54/Sukabumi_Overview.jpg"
    },
    {
      "title": "Tegal",
      "description": "Kota di pesisir utara Jawa dengan banyak kuliner khas.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/7/79/Tegal_City.jpg"
    },
    {
      "title": "Kuningan",
      "description":
          "Kota yang terkenal dengan keindahan alam dan budaya lokal.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/d/d4/Kuningan_Paddy_Fields.jpg"
    },
    {
      "title": "Banyumas",
      "description": "Kota yang kaya akan budaya dan sejarah.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/f/f1/Banyumas_Rice_Terraces.jpg"
    },
  ];

  List<Map<String, String>> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchResults = items; // Awalannya tampilkan semua item
  }

  void _filterResults(String query) {
    final filteredItems = items.where((item) {
      return item['title']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchResults = filteredItems;
    });
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Pengguna harus menekan tombol untuk menutup dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('username'); // Menghapus data pengguna
                await prefs.remove('email'); // Menghapus data email
                await prefs.remove('password'); // Menghapus data password

                // Kembali ke halaman login
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  void _showAccountInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Tidak ada informasi';
    String email = prefs.getString('email') ?? 'Tidak ada informasi';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info Akun'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: $username'),
              Text('Email: $email'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
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
      appBar: AppBar(
        title: Text('Pencarian Kota'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'info') {
                _showAccountInfo();
              } else if (value == 'logout') {
                _showLogoutConfirmationDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'info',
                  child: Text('Info Akun'),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari kota...',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              onChanged: (query) {
                _filterResults(query);
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: searchResults.isNotEmpty
                    ? ListView.builder(
                        key: ValueKey(searchResults.length),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final item = searchResults[index];
                          return Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['image']!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Icon(Icons.error, size: 50);
                                  },
                                ),
                              ),
                              title: Text(item['title']!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(item['description']!,
                                  style: TextStyle(fontSize: 14)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      title: item['title']!,
                                      description: item['description']!,
                                      image: item['image']!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    : Center(child: Text('Tidak ada hasil ditemukan')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  DetailScreen(
      {required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
