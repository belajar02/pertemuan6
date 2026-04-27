import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/animated_dialog.dart';

class PertemuanPage extends StatefulWidget {
  final int pertemuanKe;
  final String title;

  const PertemuanPage({
    super.key,
    required this.pertemuanKe,
    required this.title,
  });

  @override
  State<PertemuanPage> createState() => _PertemuanPageState();
}

class _PertemuanPageState extends State<PertemuanPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Untuk Radio Button (Pertemuan 4)
  String? _selectedGender;
  
  // Untuk ListView (Pertemuan 5)
  String? _selectedKelas;
  final List<String> kelasList = ['A', 'B', 'C', 'D', 'E'];
  
  // Untuk Checkbox (Pertemuan 6)
  List<String> _selectedSkills = [];
  final List<Map<String, String>> skillList = [
    {'name': 'Flutter', 'emoji': '📱'},
    {'name': 'Dart', 'emoji': '🎯'},
    {'name': 'UI/UX', 'emoji': '🎨'},
    {'name': 'Backend', 'emoji': '⚙️'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> _showAnimatedDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AnimatedDialog(
        title: 'Konfirmasi Data',
        content: 'Apakah data yang Anda isi sudah benar?',
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
      ),
    );
    
    if (result == true) {
      _showSuccessToast('✅ Data berhasil disimpan! Terima kasih ${_namaController.text}');
      _resetForm();
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaController.clear();
    _nimController.clear();
    _emailController.clear();
    setState(() {
      _selectedGender = null;
      _selectedKelas = null;
      _selectedSkills.clear();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _showAnimatedDialog();
    }
  }

  String _getMateriDescription() {
    switch (widget.pertemuanKe) {
      case 1:
        return '📌 Cara Install Flutter:\n\n'
            '1. Download Flutter SDK dari flutter.dev\n'
            '2. Extract folder Flutter\n'
            '3. Tambahkan ke PATH environment\n'
            '4. Jalankan flutter doctor\n'
            '5. Install Android Studio / VS Code\n'
            '6. Setup emulator atau sambungkan device';
      case 2:
        return '📌 Cara Setup SDK Flutter:\n\n'
            '1. Buka Control Panel > System > Environment Variables\n'
            '2. Tambahkan path Flutter/bin ke PATH\n'
            '3. Jalankan "flutter doctor --android-licenses"\n'
            '4. Setup Android SDK path\n'
            '5. Verify dengan "flutter doctor -v"';
      case 3:
        return '📌 Materi Hello World & Layout:\n\n'
            '// Column & Row Example\n'
            'Column(\n'
            '  children: [\n'
            '    Text("Hello World"),\n'
            '    Row(\n'
            '      children: [Icon(Icons.star), Text("Flutter")],\n'
            '    ),\n'
            '  ],\n'
            ')';
      default:
        return 'Silakan isi form registrasi di bawah ini:';
    }
  }

  Widget _buildForm() {
    switch (widget.pertemuanKe) {
      case 4:
        return _buildRadioForm();
      case 5:
        return _buildListViewForm();
      case 6:
        return _buildCheckboxForm();
      default:
        return _buildDefaultForm();
    }
  }

  Widget _buildDefaultForm() {
    return Column(
      children: [
        _buildTextField(_namaController, 'Nama Lengkap', Icons.person),
        const SizedBox(height: 16),
        _buildTextField(_nimController, 'NIM', Icons.numbers),
        const SizedBox(height: 16),
        _buildTextField(_emailController, 'Email', Icons.email, isEmail: true),
      ],
    );
  }

  Widget _buildRadioForm() {
    return Column(
      children: [
        _buildTextField(_namaController, 'Nama Lengkap', Icons.person),
        const SizedBox(height: 16),
        _buildTextField(_nimController, 'NIM', Icons.numbers),
        const SizedBox(height: 16),
        _buildTextField(_emailController, 'Email', Icons.email, isEmail: true),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      activeColor: Colors.pink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListViewForm() {
    return Column(
      children: [
        _buildTextField(_namaController, 'Nama Lengkap', Icons.person),
        const SizedBox(height: 16),
        _buildTextField(_nimController, 'NIM', Icons.numbers),
        const SizedBox(height: 16),
        _buildTextField(_emailController, 'Email', Icons.email, isEmail: true),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Kelas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: kelasList.map((kelas) {
                    return RadioListTile(
                      title: Text('Kelas $kelas'),
                      value: kelas,
                      groupValue: _selectedKelas,
                      onChanged: (value) {
                        setState(() {
                          _selectedKelas = value;
                        });
                      },
                      activeColor: Colors.blue,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxForm() {
    return Column(
      children: [
        _buildTextField(_namaController, 'Nama Lengkap', Icons.person),
        const SizedBox(height: 16),
        _buildTextField(_nimController, 'NIM', Icons.numbers),
        const SizedBox(height: 16),
        _buildTextField(_emailController, 'Email', Icons.email, isEmail: true),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Skill yang dikuasai',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...skillList.map((skill) {
                return CheckboxListTile(
                  title: Text('${skill['emoji']} ${skill['name']}'),
                  value: _selectedSkills.contains(skill['name']),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedSkills.add(skill['name']!);
                      } else {
                        _selectedSkills.remove(skill['name']);
                      }
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero,
                );
              }),
              if (_selectedSkills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Chip(
                    label: Text('Terpilih: ${_selectedSkills.join(", ")}'),
                    backgroundColor: Colors.blue.shade100,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        if (isEmail && !value.contains('@')) {
          return 'Email tidak valid';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FadeTransition(
        opacity: _animationController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Materi Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu_book, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'Materi ${widget.title}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getMateriDescription(),
                      style: const TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Form Registrasi
              if (widget.pertemuanKe >= 4)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.assignment, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            'Form Registrasi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: _buildForm(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Submit Registrasi',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Form registrasi akan tersedia mulai Pertemuan 4',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}