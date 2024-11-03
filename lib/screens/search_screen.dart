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
          "https://www.bing.com/images/search?view=detailV2&ccid=HH27Tuq%2f&id=3B39FF84C5B615A2963493B76B88CA5F63B1D21C&thid=OIP.HH27Tuq_dqp1xXHyk0sLdAHaDr&mediaurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.1c7dbb4eeabf76aa75c571f2934b0b74%3frik%3dHNKxY1%252fKiGu3kw%26riu%3dhttp%253a%252f%252fupload.wikimedia.org%252fwikipedia%252fcommons%252fb%252fb6%252fJakarta_Skyline_Part_2.jpg%26ehk%3dXkNrqg8odUYYYQ5FZss5vZ5B5NUV2dqqR61UFTaENb4%253d%26risl%3d%26pid%3dImgRaw%26r%3d0&exph=450&expw=906&q=%22image%22%3a+%22https%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2fe%2fe7%2fJakarta_skyline.jpg%22&simid=607992101008778264&FORM=IRPRST&ck=8F59A0E2265E22D1F9E1F82AA464C2DD&selectedIndex=0&itb=0&ajaxhist=0&ajaxserp=0"
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
        title: Text('Pencarian'),
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
                labelText: 'Cari...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                _filterResults(query);
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final item = searchResults[index];
                  return ListTile(
                    title: Text(item['title']!),
                    subtitle: Text(item['description']!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            title: item['title']!,
                            description: item['description']!,
                            image: item['image']!, // Mengirim URL gambar
                          ),
                        ),
                      );
                    },
                  );
                },
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
  final String image; // Tambahkan parameter untuk gambar

  DetailScreen(
      {required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Image.network(image), // Tampilkan gambar menggunakan Image.network
            SizedBox(height: 16),
            Text(description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
