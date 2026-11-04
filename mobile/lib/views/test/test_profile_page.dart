import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ternatespot/controllers/profile_controller.dart';

class TestProfilePage extends StatefulWidget {
  const TestProfilePage({Key? key}) : super(key: key);

  @override
  State<TestProfilePage> createState() => _TestProfilePageState();
}

class _TestProfilePageState extends State<TestProfilePage> {
  final ProfileController _controller = ProfileController();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();

  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final data = await _controller.loadProfile();
    if (data != null) {
      setState(() {
        _userData = data;
        _namaController.text = data['nama'] ?? '';
        _emailController.text = data['email'] ?? '';
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _testUpdateProfile() async {
    setState(() => _isLoading = true);
    final success = await _controller.updateProfile(
      nama: _namaController.text,
      email: _emailController.text,
    );
    _showMessage(
      success ? 'Update profile BERHASIL' : 'Update profile GAGAL',
      success,
    );
    if (success) await _loadProfile();
    setState(() => _isLoading = false);
  }

  Future<void> _testUploadPhoto() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      final success = await _controller.uploadProfilePicture(pickedFile);
      _showMessage(
        success ? 'Upload foto BERHASIL' : 'Upload foto GAGAL',
        success,
      );
      if (success) await _loadProfile();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testLogout() async {
    setState(() => _isLoading = true);
    await _controller.logout();
    _showMessage('Logout BERHASIL', true);
    setState(() {
      _userData = null;
      _namaController.clear();
      _emailController.clear();
    });
    setState(() => _isLoading = false);
  }

  void _showMessage(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Profile (Backend)'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _userData?['foto_profil'] != null
                                ? NetworkImage(_userData!['foto_profil'])
                                : null,
                            child: _userData?['foto_profil'] == null
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _userData?['nama'] ?? 'Belum Login',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(_userData?['email'] ?? ''),
                          const SizedBox(height: 8),
                          Text(
                            'Role: ${_userData?['role'] ?? '-'} | Status: ${_userData?['status'] ?? '-'}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '1. Test Update Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _testUpdateProfile,
                    child: const Text('TEST UPDATE PROFILE'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '2. Test Upload Foto',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _testUploadPhoto,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('PILIH & UPLOAD FOTO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '3. Test Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _testLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text('TEST LOGOUT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
