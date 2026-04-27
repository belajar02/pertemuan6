class UserModel {
  String name;
  String bio;
  String university;
  String major;
  String phone;
  String email;
  String? profileImageUrl;
  String? coverImageUrl;

  UserModel({
    required this.name,
    required this.bio,
    required this.university,
    required this.major,
    required this.phone,
    required this.email,
    this.profileImageUrl,
    this.coverImageUrl,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'bio': bio,
    'university': university,
    'major': major,
    'phone': phone,
    'email': email,
    'profileImageUrl': profileImageUrl,
    'coverImageUrl': coverImageUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] ?? 'Chandra Dianarto Putra',
    bio: json['bio'] ?? 'Mahasiswa Sistem Informasi',
    university: json['university'] ?? 'Universitas Pamulang',
    major: json['major'] ?? 'Sistem Informasi',
    phone: json['phone'] ?? '+62 812 3456 7890',
    email: json['email'] ?? 'chandra@email.com',
    profileImageUrl: json['profileImageUrl'],
    coverImageUrl: json['coverImageUrl'],
  );
}