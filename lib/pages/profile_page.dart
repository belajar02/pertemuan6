// ignore: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late UserModel user;
  late AnimationController _animationController;
  
  String? _profileImageUrl;
  String? _coverImageUrl;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isEditing = false;
  bool _isLoading = true;
  int _selectedTab = 0;
  
  // Data Keahlian
  final List<Map<String, dynamic>> _skills = [
    {'name': 'Flutter', 'level': 0.85, 'icon': Icons.mobile_friendly, 'color': const Color(0xFF2563EB)},
    {'name': 'Dart', 'level': 0.80, 'icon': Icons.code, 'color': const Color(0xFF10B981)},
    {'name': 'UI/UX Design', 'level': 0.75, 'icon': Icons.design_services, 'color': const Color(0xFFF59E0B)},
    {'name': 'Firebase', 'level': 0.70, 'icon': Icons.fireplace, 'color': const Color(0xFFEF4444)},
    {'name': 'Git', 'level': 0.82, 'icon': Icons.account_tree, 'color': const Color(0xFF8B5CF6)},
    {'name': 'REST API', 'level': 0.78, 'icon': Icons.api, 'color': const Color(0xFFEC4899)},
  ];
  
  // Data Hobi
  final List<Map<String, dynamic>> _hobbies = [
    {'name': 'Coding', 'icon': Icons.code, 'color': const Color(0xFF2563EB), 'emoji': '💻'},
    {'name': 'Reading', 'icon': Icons.menu_book, 'color': const Color(0xFF10B981), 'emoji': '📚'},
    {'name': 'Gaming', 'icon': Icons.sports_esports, 'color': const Color(0xFFF59E0B), 'emoji': '🎮'},
    {'name': 'Music', 'icon': Icons.music_note, 'color': const Color(0xFFEF4444), 'emoji': '🎵'},
    {'name': 'Photography', 'icon': Icons.camera_alt, 'color': const Color(0xFF8B5CF6), 'emoji': '📷'},
    {'name': 'Traveling', 'icon': Icons.flight, 'color': const Color(0xFFEC4899), 'emoji': '✈️'},
  ];
  
  // Data Sertifikat
  // ignore: unused_field
  final List<Map<String, dynamic>> _certificates = [
    {'name': 'Flutter Developer', 'issuer': 'Google', 'year': '2024', 'icon': Icons.verified},
    {'name': 'UI/UX Design', 'issuer': 'Dicoding', 'year': '2023', 'icon': Icons.design_services},
    {'name': 'JavaScript Expert', 'issuer': 'CODEPolitan', 'year': '2023', 'icon': Icons.javascript},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
    _initializeUser();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _initializeUser() async {
    await _loadUserData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        user = UserModel.fromJson(jsonDecode(userData));
      } else {
        user = UserModel(
          name: 'Chandra Dianarto Putra',
          bio: 'Mahasiswa Sistem Informasi • Flutter Developer',
          university: 'Universitas Pamulang',
          major: 'Sistem Informasi',
          phone: '+62 812 3456 7890',
          email: 'chandra@unpam.ac.id',
        );
      }
      
      _nameController.text = user.name;
      _bioController.text = user.bio;
      _phoneController.text = user.phone;
      _emailController.text = user.email;
      
      _profileImageUrl = prefs.getString('profile_image_url');
      _coverImageUrl = prefs.getString('cover_image_url');
    } catch (e) {
      print('Error loading user data: $e');
      user = UserModel(
        name: 'Chandra Dianarto Putra',
        bio: 'Mahasiswa Sistem Informasi • Flutter Developer',
        university: 'Universitas Pamulang',
        major: 'Sistem Informasi',
        phone: '+62 812 3456 7890',
        email: 'chandra@unpam.ac.id',
      );
    }
  }

  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      user.name = _nameController.text;
      user.bio = _bioController.text;
      user.phone = _phoneController.text;
      user.email = _emailController.text;
      
      await prefs.setString('user_data', jsonEncode(user.toJson()));
      
      if (_profileImageUrl != null) {
        await prefs.setString('profile_image_url', _profileImageUrl!);
      }
      if (_coverImageUrl != null) {
        await prefs.setString('cover_image_url', _coverImageUrl!);
      }
      
      setState(() {
        _isEditing = false;
      });
      _showToast('Data berhasil disimpan!');
    } catch (e) {
      _showToast('Gagal menyimpan data: $e');
    }
  }

  Future<void> _pickImage(bool isProfile) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        setState(() {
          if (isProfile) {
            _profileImageUrl = pickedFile.path;
          } else {
            _coverImageUrl = pickedFile.path;
          }
        });
        _showToast('Foto berhasil diubah!');
        await _saveUserData();
      }
    } catch (e) {
      _showToast('Gagal mengambil gambar: $e');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat profil...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(  // ← INI YANG MEMPERBAIKI SCROLL
        child: Column(
          children: [
            // ========== COVER + PROFILE PICTURE SECTION ==========
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Cover Image
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: (_coverImageUrl != null && _coverImageUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(_coverImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (_coverImageUrl == null || _coverImageUrl!.isEmpty)
                      ? _buildDefaultCover()
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                ),
                
                // Tombol Edit Cover
                if (_isEditing)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _pickImage(false),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                
                // Foto Profil di Tengah Cover
                Positioned(
                  bottom: -60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: ClipOval(
                            child: GestureDetector(
                              onTap: _isEditing ? () => _pickImage(true) : null,
                              child: (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
                                  ? Image.network(
                                      _profileImageUrl!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return _buildDefaultProfile();
                                      },
                                    )
                                  : _buildDefaultProfile(),
                            ),
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 70),
            
            // Nama
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
            const SizedBox(height: 4),
            
            // Bio
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Text(
                user.bio,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Stats Row
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItemLarge(label: 'Posts', value: '248', color: Colors.blue),
                  _StatItemLarge(label: 'Followers', value: '12.5K', color: Colors.green),
                  _StatItemLarge(label: 'Following', value: '894', color: Colors.purple),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About Me Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.school, 'Universitas', user.university, Colors.blue),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.book, 'Jurusan', user.major, Colors.purple),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.phone, 'Telepon', user.phone, Colors.green,
                              isEditable: true, onEdit: () => _showEditDialog('Telepon', _phoneController, 'phone')),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.email, 'Email', user.email, Colors.red,
                              isEditable: true, onEdit: () => _showEditDialog('Email', _emailController, 'email')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildTabItem(0, 'Keahlian', Icons.build),
                  _buildTabItem(1, 'Hobi', Icons.favorite),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tab Content
            _selectedTab == 0 ? _buildSkillsTab() : _buildHobbiesTab(),
            
            const SizedBox(height: 100), // Spacer bottom agar tidak kepotong FAB
          ],
        ),
      ),
      
      floatingActionButton: _isEditing
          ? FloatingActionButton.extended(
              onPressed: _saveUserData,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
              backgroundColor: Colors.green,
            )
          : FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              backgroundColor: Colors.blue,
            ),
    );
  }
  
  Widget _buildDefaultCover() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2563EB),
            Color(0xFF7C3AED),
            Color(0xFFEC4899),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_alt,
              size: 50,
              color: Colors.white.withOpacity(0.4),
            ),
            const SizedBox(height: 8),
            Text(
              'Cover Photo',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDefaultProfile() {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
        ),
      ),
      child: const Center(
        child: Text(
          'CD',
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  
  Widget _buildTabItem(int index, String title, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(21),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 18),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSkillsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ..._skills.map((skill) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (skill['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(skill['icon'], color: skill['color'], size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(skill['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const Spacer(),
                        Text('${(skill['level'] * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: skill['level'],
                      backgroundColor: Colors.grey.shade200,
                      color: skill['color'],
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHobbiesTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: _hobbies.length,
        itemBuilder: (context, index) {
          final hobby = _hobbies[index];
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (hobby['color'] as Color).withOpacity(0.1),
                  (hobby['color'] as Color).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (hobby['color'] as Color).withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(hobby['emoji'], style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Icon(hobby['icon'], color: hobby['color'], size: 28),
                const SizedBox(height: 8),
                Text(hobby['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value, Color color,
      {bool isEditable = false, VoidCallback? onEdit}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[600], fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isEditable && _isEditing)
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }
  
  void _showEditDialog(String field, TextEditingController controller, String key) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: field,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (key == 'phone') user.phone = controller.text;
                  if (key == 'email') user.email = controller.text;
                });
                Navigator.pop(context);
                _saveUserData();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}

// Stat Item untuk Posts, Followers, Following
class _StatItemLarge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  
  const _StatItemLarge({
    required this.label,
    required this.value,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}