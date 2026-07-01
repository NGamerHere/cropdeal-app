class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? profilePhoto;
  final String role;
  final bool isOnboarded;
  final int onBoardingStep;
  final String? googleId;
  final int? businessTypeId;
  final String? businessType;
  final int? userTypeId;
  final String? userType;
  final int? cityId;
  final String? city;
  final int? areaId;
  final String? area;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhoto,
    required this.role,
    required this.isOnboarded,
    required this.onBoardingStep,
    this.googleId,
    this.businessTypeId,
    this.businessType,
    this.userTypeId,
    this.userType,
    this.cityId,
    this.city,
    this.areaId,
    this.area,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print(json['city']);
    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profilePhoto: json['profilePhoto'] as String?,
      role: json['role'] as String? ?? 'User',
      isOnboarded: json['isOnboarded'] as bool? ?? false,
      onBoardingStep: json['onBoardingStep'] as int? ?? 0,
      googleId: json['googleId'] as String?,
      businessTypeId: json['businessTypeId'] as int?,
      businessType: (json['businessType'] as Map<String, dynamic>?)?['name'] as String?,
      userTypeId: json['userTypeId'] as int?,
      userType: (json['userType'] as Map<String, dynamic>?)?['name'] as String?,
      cityId: json['cityId'] as int?,
      city: (json['city'] as Map<String, dynamic>?)?['name'] as String?,
      areaId: json['areaId'] as int?,
      area: (json['area'] as Map<String, dynamic>?)?['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePhoto': profilePhoto,
      'role': role,
      'isOnboarded': isOnboarded,
      'onBoardingStep': onBoardingStep,
      'googleId': googleId,
      'businessTypeId': businessTypeId,
      'businessType': businessType,
      'userTypeId': userTypeId,
      'userType': userType,
      'cityId': cityId,
      'city': city,
      'areaId': areaId,
      'area': area,
    };
  }
}
