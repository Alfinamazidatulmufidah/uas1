import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'movie_page.dart';
import 'upcoming_page.dart';
import 'profil_page.dart';
import 'notifikasi.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'movie_model.dart'; // Import the model

class HomePage extends StatefulWidget {
  final String email;

  HomePage({required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  PageController _featuredPageController = PageController();
  Timer? _timer;

  List<Movie> _movies = [];
  String _searchQuery = '';

  @override
  void dispose() {
    _pageController.dispose();
    _featuredPageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovies();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_featuredPageController.page == 2) {
        _featuredPageController.animateToPage(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        _featuredPageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  Future<void> _fetchNowPlayingMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=da2f154408ef7dab162b747e39577769'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _movies = (data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<void> _searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=da2f154408ef7dab162b747e39577769&query=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _movies = (data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      appBar: AppBar(
        title: Image.asset('assets/CINEBOO.png', height: 30),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildHomePage(),
          UpcomingPage(),
          ProfilePage(
            username: 'pinadel',
            password: 'lia123',
            email: 'pindel@gmail.com',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upcoming),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hai,\n${widget.email}',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotifikasiPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari film...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _searchMovies(value);
              },
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              child: PageView.builder(
                controller: _featuredPageController,
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          _movies[index].posterPath != null
                              ? _movies[index].posterPath
                              : 'https://via.placeholder.com/500', // Placeholder if posterPath is null
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return MovieCard(
                  title: movie.title,
                  imageUrl: movie.posterPath != null
                      ? movie.posterPath
                      : 'https://via.placeholder.com/500', // Placeholder if posterPath is null
                  ageRating:
                      'SU', // Replace with appropriate age rating logic if needed
                  description: movie.overview,
                  movieId: movie.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String ageRating;
  final String description;
  final int movieId;

  MovieCard({
    required this.title,
    required this.imageUrl,
    required this.ageRating,
    required this.description,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(
              movieId: movieId,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '2D',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.indigo],
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    ageRating,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}