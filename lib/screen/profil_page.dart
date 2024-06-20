import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'developer_profile_page.dart'; // Import halaman profil developer

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  ProfilePage({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isEditingName = false;
  bool _isEditingPassword = false;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToDeveloperProfiles() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeveloperProfilePage()),
    );
  }

  void _toggleEditingName() {
    setState(() {
      _isEditingName = !_isEditingName;
    });
  }

  void _toggleEditingPassword() {
    setState(() {
      _isEditingPassword = !_isEditingPassword;
    });
  }

  void _saveChanges() {
    setState(() {
      _isEditingName = false;
      _isEditingPassword = false;
    });
    // Save changes logic here, if necessary
  }

  void _saveNameChanges() {
    setState(() {
      _isEditingName = false;
    });
    // Logic for saving name changes
  }

  void _savePasswordChanges() {
    setState(() {
      _isEditingPassword = false;
    });
    // Logic for saving password changes
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Color.fromRGBO(239, 247, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/sampul.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                ),
                Positioned(
                  bottom: -40,
                  left: 16.0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage('assets/garfield.png') as ImageProvider,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  left: 96.0,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: ValueListenableBuilder(
                      valueListenable: _nameController,
                      builder: (context, TextEditingValue value, __) {
                        return Text(
                          '@ ${value.text}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60), // Adjusted for floating avatar position
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  EditableProfileInfo(
                    label: 'Nama',
                    controller: _nameController,
                    isEditing: _isEditingName,
                    toggleEditing: _toggleEditingName,
                    saveChanges: _saveNameChanges,
                  ),
                  SizedBox(height: 20),
                  EditableProfileInfo(
                    label: 'Email',
                    controller: _emailController,
                    isEditable: false, // Email is not editable
                  ),
                  SizedBox(height: 20),
                  EditableProfileInfo(
                    label: 'Kata Sandi',
                    controller: _passwordController,
                    obscureText: true,
                    isEditing: _isEditingPassword,
                    toggleEditing: _toggleEditingPassword,
                    saveChanges: _savePasswordChanges,
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToDeveloperProfiles,
                      icon: Icon(Icons.group),
                      label: Text('Profile Developer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 60, 217, 214),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableProfileInfo extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool isEditing;
  final bool isEditable;
  final VoidCallback? toggleEditing;
  final VoidCallback? saveChanges;

  EditableProfileInfo({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.isEditing = false,
    this.isEditable = true,
    this.toggleEditing,
    this.saveChanges,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      obscureText: obscureText,
                      enabled: isEditing,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (isEditable)
                    GestureDetector(
                      onTap: isEditing ? saveChanges : toggleEditing,
                      child: Icon(
                        isEditing ? Icons.save : Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }
}