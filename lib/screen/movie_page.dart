import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'seat.dart'; // Import SeatSelectionPage

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  final bool isUpcoming; // Tambahkan flag untuk film yang akan datang

  MovieDetailPage({required this.movieId, this.isUpcoming = false});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Map<String, dynamic> movieDetails = {};
  late String trailerUrl = '';
  late List<dynamic> cast = [];
  late List<dynamic> crew = [];

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    final String apiKey = 'da2f154408ef7dab162b747e39577769';
    final String detailsUrl =
        'https://api.themoviedb.org/3/movie/${widget.movieId}?api_key=$apiKey';
    final String creditsUrl =
        'https://api.themoviedb.org/3/movie/${widget.movieId}/credits?api_key=$apiKey';

    try {
      final detailsResponse = await http.get(Uri.parse(detailsUrl));
      final creditsResponse = await http.get(Uri.parse(creditsUrl));
      if (detailsResponse.statusCode == 200 &&
          creditsResponse.statusCode == 200) {
        setState(() {
          movieDetails = json.decode(detailsResponse.body);
          final creditsData = json.decode(creditsResponse.body);
          cast = creditsData['cast'];
          crew = creditsData['crew'];
        });
      } else {
        throw 'Failed to load movie details';
      }

      final videoResponse = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movieId}/videos?api_key=$apiKey'));
      if (videoResponse.statusCode == 200) {
        final videoData = json.decode(videoResponse.body);
        final List videos = videoData['results'];
        final trailer = videos.firstWhere((video) => video['type'] == 'Trailer',
            orElse: () => null);
        if (trailer != null) {
          setState(() {
            trailerUrl = 'https://www.youtube.com/watch?v=${trailer['key']}';
          });
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showTrailer() async {
    if (await canLaunch(trailerUrl)) {
      await launch(trailerUrl);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Could not launch trailer.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (movieDetails.isEmpty) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(239, 247, 255, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(239, 247, 255, 1),
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movieDetails['title'] ?? 'Movie Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movieDetails['poster_path']}',
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Unable to load image');
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieDetails['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rating Usia: ${movieDetails['adult'] ? '18+' : 'PG'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (!widget
                          .isUpcoming) // Tampilkan tombol hanya jika bukan film yang akan datang
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 34, 162, 222),
                          foregroundColor:  Colors.white// Warna biru muda
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeatSelectionPage(
                                  movieTitle: movieDetails['title'],
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w500${movieDetails['poster_path']}',
                                ),
                              ),
                            );
                          },
                          child: const Text('Beli Tiket'),
                        ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 34, 162, 222),
                          foregroundColor:  Colors.white// Warna biru muda
                        ),
                        onPressed: _showTrailer,
                        child: const Text('Trailer'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              movieDetails['overview'] ?? '',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Produser:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              movieDetails['production_companies'] != null
                  ? (movieDetails['production_companies'] as List)
                      .map((c) => c['name'])
                      .join(', ')
                  : '',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Direktor:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              crew
                  .where((c) => c['job'] == 'Director')
                  .map((c) => c['name'])
                  .join(', '),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Penulis:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              crew
                  .where((c) => c['department'] == 'Writing')
                  .map((c) => c['name'])
                  .join(', '),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cast:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              cast.take(5).map((c) => c['name']).join(', '),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
