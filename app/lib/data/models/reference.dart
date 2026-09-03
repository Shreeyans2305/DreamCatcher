class Language {
  final String code;
  final String name;
  final String nativeName;
  final String script;
  final bool isActive;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.script,
    this.isActive = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;

  static List<Language> get defaultLanguages => [
        Language(code: 'en', name: 'English', nativeName: 'English', script: 'Latin'),
        Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', script: 'Devanagari'),
        Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', script: 'Bengali'),
        Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', script: 'Gujarati'),
        Language(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', script: 'Kannada'),
        Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी', script: 'Devanagari'),
        Language(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', script: 'Odia'),
        Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', script: 'Tamil'),
        Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', script: 'Telugu'),
      ];

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['native_name'] as String? ?? json['name'] as String,
      script: json['script'] as String? ?? 'Latin',
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class LocationItem {
  final String id;
  final String country;
  final String? state;
  final String? district;
  final String? taluka;
  final String? village;
  final String? pincode;
  final String ruralUrban;

  LocationItem({
    required this.id,
    required this.country,
    this.state,
    this.district,
    this.taluka,
    this.village,
    this.pincode,
    this.ruralUrban = 'unknown',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get displayName {
    final parts = [
      if (village != null && village!.isNotEmpty) village!,
      if (taluka != null && taluka!.isNotEmpty) taluka!,
      if (district != null && district!.isNotEmpty) district!,
      if (state != null && state!.isNotEmpty) state!,
    ];
    return parts.isEmpty ? country : parts.join(', ');
  }

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      id: json['id'] as String,
      country: json['country'] as String? ?? 'India',
      state: json['state'] as String?,
      district: json['district'] as String?,
      taluka: json['taluka'] as String?,
      village: json['village'] as String?,
      pincode: json['pincode'] as String?,
      ruralUrban: json['rural_urban'] as String? ?? 'unknown',
    );
  }

  static List<LocationItem> get defaultLocations => [
        LocationItem(id: '862bd376-ba2f-4265-a31f-28b7978c9039', country: 'India', state: 'Bihar', district: 'Muzaffarpur', taluka: 'Bochahan', village: 'Sarfuddinpur', pincode: '843103', ruralUrban: 'rural'),
        LocationItem(id: '0b9635a4-989d-49e4-8d78-2e542b6b5224', country: 'India', state: 'Gujarat', district: 'Kutch', taluka: 'Bhuj', village: 'Madhapar', pincode: '370020', ruralUrban: 'rural'),
        LocationItem(id: 'de35088f-d6ac-4f07-b3b7-548772f0b607', country: 'India', state: 'Madhya Pradesh', district: 'Jhabua', taluka: 'Thandla', village: 'Khatamba', pincode: '457777', ruralUrban: 'rural'),
        LocationItem(id: '1d4379b9-6d81-4359-abef-9235925dde04', country: 'India', state: 'Maharashtra', district: 'Chhatrapati Sambhajinagar', taluka: 'Paithan', village: 'Bidkin', pincode: '431105', ruralUrban: 'rural'),
        LocationItem(id: 'c767cf03-00d6-46b3-a42d-b34db917ab10', country: 'India', state: 'Delhi', district: 'New Delhi', taluka: null, village: null, pincode: '110001', ruralUrban: 'urban'),
      ];
}

class SkillItem {
  final String id;
  final String canonicalName;
  final String category;
  final String? description;

  SkillItem({
    required this.id,
    required this.canonicalName,
    required this.category,
    this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory SkillItem.fromJson(Map<String, dynamic> json) {
    return SkillItem(
      id: json['id'] as String,
      canonicalName: json['canonical_name'] as String,
      category: json['category'] as String? ?? 'general',
      description: json['description'] as String?,
    );
  }

  static List<SkillItem> get defaultSkills => [
        SkillItem(id: '64278ca2-05bf-4576-a671-4fdb9343eab3', canonicalName: 'Basic Computer Operations & MS Office', category: 'digital'),
        SkillItem(id: 'a2f9159e-779b-48c6-8902-a70d4533705d', canonicalName: 'Community Communication', category: 'soft'),
        SkillItem(id: 'e1e4d96e-ab64-4aad-8177-3a54adef2142', canonicalName: 'Crop Production & Soil Testing', category: 'scientific'),
        SkillItem(id: 'c4f04e21-1f4c-4c96-8408-03d4b12bb3c0', canonicalName: 'Electrical Wiring & Circuit Repair', category: 'technical'),
        SkillItem(id: 'd0c6f061-39ef-4206-ae4d-6e1e563222f9', canonicalName: 'Data Analysis', category: 'technical'),
      ];
}

class InterestItem {
  final String id;
  final String name;
  final String category;
  final String? description;

  InterestItem({
    required this.id,
    required this.name,
    required this.category,
    this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterestItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory InterestItem.fromJson(Map<String, dynamic> json) {
    return InterestItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'general',
      description: json['description'] as String?,
    );
  }

  static List<InterestItem> get defaultInterests => [
        InterestItem(id: 'bfa26037-7e1e-4656-bf28-99aca9a83318', name: 'Agriculture & Rural Development', category: 'agriculture'),
        InterestItem(id: '209faff4-04ea-46e9-9418-2d909880b604', name: 'Civil Engineering & Construction', category: 'engineering'),
        InterestItem(id: '06007bf6-6f25-4765-a9b3-258549e45583', name: 'Computers & Technology', category: 'technology'),
        InterestItem(id: '10db46f5-5ae1-4c96-bbd7-1c3b782ce62e', name: 'Dairy Farming', category: 'agriculture'),
        InterestItem(id: '8e8bb897-ba15-45f7-80c3-9105d4b01827', name: 'Electrical & Machine Work', category: 'engineering'),
      ];
}
