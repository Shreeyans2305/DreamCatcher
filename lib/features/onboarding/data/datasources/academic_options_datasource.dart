/// Data-driven configuration for regional practical subjects, skills, and aspiration ideas.
/// This allows rural students to select familiar, regional skills without hardcoding options into UI widgets.
class AcademicOptionsDatasource {
  const AcademicOptionsDatasource();

  /// Regional practical subjects and informal learning areas.
  List<String> getPracticalSubjects({String? state}) {
    // Base practical subjects common across rural India
    final baseSubjects = [
      'Farming & Agriculture',
      'Tailoring & Garment Making',
      'Computer Basics & Internet',
      'Spoken English',
      'Mobile & Electrical Repair',
      'Animal Husbandry & Dairy',
      'Basic Mathematics & Accounting',
      'Welding & Carpentry',
      'Solar Panel Maintenance',
      'Community Health & Nursing Basics',
      'Motorcycle & Tractor Mechanics',
      'Handicrafts & Pottery',
    ];

    // Regional additions based on state
    if (state != null) {
      final s = state.toLowerCase();
      if (s.contains('madhya pradesh') || s.contains('punjab') || s.contains('haryana')) {
        return [
          ...baseSubjects,
          'Organic Fertilizer Production',
          'Wheat & Soybean Cultivation',
        ];
      } else if (s.contains('kerala') || s.contains('tamil nadu') || s.contains('karnataka')) {
        return [
          ...baseSubjects,
          'Aquaculture & Fisheries',
          'Coconut & Spice Processing',
        ];
      } else if (s.contains('assam') || s.contains('northeast')) {
        return [
          ...baseSubjects,
          'Tea Plantation & Processing',
          'Bamboo Craft',
        ];
      }
    }

    return baseSubjects;
  }

  /// Curated skills for Step 4 picker
  List<String> getCommonSkills() {
    return [
      'Smartphones & Digital Payments (UPI)',
      'Data Entry & Typing',
      'Customer Communication',
      'Basic Vehicle Repair',
      'Carpentry & Woodwork',
      'Tailoring & Sewing',
      'Cooking & Food Catering',
      'Plumbing & Water Pumps',
      'Electric Wiring & Household Repair',
      'First Aid & Patient Care',
      'Painting & Wall Design',
      'Teaching & Tutoring Kids',
    ];
  }

  /// Curated interest areas for Step 4 picker
  List<String> getCommonInterests() {
    return [
      'Technology & Computers',
      'Agriculture & Organic Farming',
      'Police & Armed Forces',
      'Healthcare & Nursing',
      'Small Business & Retail',
      'Teaching & Education',
      'Renewable Energy & Solar',
      'Banking & Government Jobs',
      'Creative Arts & Crafts',
      'Sports & Athletics',
    ];
  }

  /// Preset aspiration prompt chips for Step 5
  List<String> getAspirationPrompts() {
    return [
      'Not sure yet — need guidance',
      'Want a secure Government job',
      'Want to study further in college',
      'Want to start my own business or shop',
      'Want a practical technical career',
      'Want to earn money while studying',
      'Want to join the Police / Defense Forces',
      'Want to work in Healthcare / Nursing',
    ];
  }

  /// Common states in India for picker
  List<String> getIndianStates() {
    return [
      'Madhya Pradesh',
      'Uttar Pradesh',
      'Bihar',
      'Rajasthan',
      'Maharashtra',
      'Gujarat',
      'West Bengal',
      'Odisha',
      'Chhattisgarh',
      'Jharkhand',
      'Punjab',
      'Haryana',
      'Assam',
      'Karnataka',
      'Tamil Nadu',
      'Andhra Pradesh',
      'Telangana',
      'Kerala',
      'Himachal Pradesh',
      'Uttarakhand',
      'Other',
    ];
  }

  /// Common education boards
  List<String> getEducationBoards() {
    return [
      'State Board',
      'CBSE',
      'Open School (NIOS)',
      'ICSE',
      'Madrasa Board',
      'Other / Informal',
    ];
  }

  /// Grade levels
  List<String> getGradeLevels() {
    return [
      'Below Class 10',
      'Class 10 Pass',
      'Class 12 Pass',
      'ITI / Vocational Diploma',
      'Polytechnic Diploma',
      'College Undergraduate',
      'Graduate / Degree Holder',
    ];
  }

  /// Income brackets
  List<String> getIncomeBrackets() {
    return [
      '< ₹1,00,000 / year',
      '₹1,00,000 - ₹2,50,000 / year',
      '₹2,50,000 - ₹5,00,000 / year',
      '> ₹5,00,000 / year',
    ];
  }

  /// Caste categories
  List<String> getCasteCategories() {
    return [
      'General',
      'OBC',
      'SC',
      'ST',
      'EWS',
    ];
  }
}
