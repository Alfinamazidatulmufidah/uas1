import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(239, 247, 255, 1),
        title: Text('Profile Developer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DeveloperCard(
                name: 'Alfina Mazidatul Mufidah',
                npm: '22082010002',
                imagePath: 'assets/pina.png',
                email: 'mailto:22082010002@student.upnjatim.ac.id',
                instagram:
                    'https://www.instagram.com/mfdhfinaa?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==',
                linkedin:
                    'https://www.linkedin.com/in/alfina-mazidatul-mufidah-abba41256/',
                github: 'https://www.github.com/Alfinamazidatulmufidah',
                emailIconPath: 'assets/Gmail.png',
                instagramIconPath: 'assets/instagram.png',
                linkedinIconPath: 'assets/Linkedin.png',
                githubIconPath: 'assets/Github.png',
              ),
              SizedBox(height: 20),
              DeveloperCard(
                name: 'Adelia Putri Pratiwi',
                npm: '22082010034',
                imagePath: 'assets/adell.png',
                email: 'mailto:22082010034@student.upnjatim.ac.id',
                instagram:
                    'https://www.instagram.com/adelealeap_?igsh=MTBrM2p0c2xuMjE3dw==',
                linkedin: 'https://www.linkedin.com/in/adeliaputri-121389265/',
                github: 'https://github.com/adelialiae',
                emailIconPath: 'assets/Gmail.png',
                instagramIconPath: 'assets/instagram.png',
                linkedinIconPath: 'assets/Linkedin.png',
                githubIconPath: 'assets/Github.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String npm;
  final String imagePath;
  final String email;
  final String instagram;
  final String linkedin;
  final String github;
  final String emailIconPath;
  final String instagramIconPath;
  final String linkedinIconPath;
  final String githubIconPath;

  DeveloperCard({
    required this.name,
    required this.npm,
    required this.imagePath,
    required this.email,
    required this.instagram,
    required this.linkedin,
    required this.github,
    required this.emailIconPath,
    required this.instagramIconPath,
    required this.linkedinIconPath,
    required this.githubIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  npm,
                  style: TextStyle(color: Colors.grey),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset(emailIconPath, width: 20, height: 20),
                      onPressed: () => _launchURL(email),
                    ),
                    IconButton(
                      icon:
                          Image.asset(instagramIconPath, width: 20, height: 20),
                      onPressed: () => _launchURL(instagram),
                    ),
                    IconButton(
                      icon:
                          Image.asset(linkedinIconPath, width: 20, height: 20),
                      onPressed: () => _launchURL(linkedin),
                    ),
                    IconButton(
                      icon: Image.asset(githubIconPath, width: 20, height: 20),
                      onPressed: () => _launchURL(github),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}