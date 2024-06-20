import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'movie_model.dart';
import 'movie_page.dart';
import 'dart:async';
import 'dart:convert';

class UpcomingPage extends StatefulWidget {
  @override
  _UpcomingPageState createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  List<Movie> _upcomingMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchUpcomingMovies();
  }

  Future<void> _fetchUpcomingMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=da2f154408ef7dab162b747e39577769'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _upcomingMovies = (data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(239, 247, 255, 1),
        elevation: 0,
        title: Text(
          'Upcoming Movies',
          style: GoogleFonts.lato(
            color: Color.fromARGB(
                255, 2, 43, 113),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildUpcomingPage(),
    );
  }

  Widget _buildUpcomingPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            _upcomingMovies.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _upcomingMovies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movieId: _upcomingMovies[index].id,
                        title: _upcomingMovies[index].title,
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${_upcomingMovies[index].posterPath}',
                        ageRating: _upcomingMovies[index].ageRating, // Gunakan ageRating yang sesuai
                        isUpcoming: true,
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
  final int movieId;
  final String title;
  final String imageUrl;
  final String ageRating;
  final bool isUpcoming;

  MovieCard({
    required this.movieId,
    required this.title,
    required this.imageUrl,
    required this.ageRating,
    this.isUpcoming = false,
  });

  Color _getAgeRatingColor() {
    switch (ageRating) {
      case '18+':
        return Colors.red;
      case 'PG':
        return Colors.orange;
      default:
        return Colors.blue; // Untuk SU
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MovieDetailPage(movieId: movieId, isUpcoming: isUpcoming),
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
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: _getAgeRatingColor(),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                ageRating,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
