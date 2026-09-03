// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _incomeBracketMeta = const VerificationMeta(
    'incomeBracket',
  );
  @override
  late final GeneratedColumn<String> incomeBracket = GeneratedColumn<String>(
    'income_bracket',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _casteCategoryMeta = const VerificationMeta(
    'casteCategory',
  );
  @override
  late final GeneratedColumn<String> casteCategory = GeneratedColumn<String>(
    'caste_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _curriculumMeta = const VerificationMeta(
    'curriculum',
  );
  @override
  late final GeneratedColumn<String> curriculum = GeneratedColumn<String>(
    'curriculum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skillsMeta = const VerificationMeta('skills');
  @override
  late final GeneratedColumn<String> skills = GeneratedColumn<String>(
    'skills',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectsMeta = const VerificationMeta(
    'subjects',
  );
  @override
  late final GeneratedColumn<String> subjects = GeneratedColumn<String>(
    'subjects',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interestsMeta = const VerificationMeta(
    'interests',
  );
  @override
  late final GeneratedColumn<String> interests = GeneratedColumn<String>(
    'interests',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aspirationsMeta = const VerificationMeta(
    'aspirations',
  );
  @override
  late final GeneratedColumn<String> aspirations = GeneratedColumn<String>(
    'aspirations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredLanguageMeta = const VerificationMeta(
    'preferredLanguage',
  );
  @override
  late final GeneratedColumn<String> preferredLanguage =
      GeneratedColumn<String>(
        'preferred_language',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isFirstGenLearnerMeta = const VerificationMeta(
    'isFirstGenLearner',
  );
  @override
  late final GeneratedColumn<bool> isFirstGenLearner = GeneratedColumn<bool>(
    'is_first_gen_learner',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_first_gen_learner" IN (0, 1))',
    ),
  );
  static const VerificationMeta _hasFormalCurriculumMeta =
      const VerificationMeta('hasFormalCurriculum');
  @override
  late final GeneratedColumn<bool> hasFormalCurriculum = GeneratedColumn<bool>(
    'has_formal_curriculum',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_formal_curriculum" IN (0, 1))',
    ),
  );
  static const VerificationMeta _boardMeta = const VerificationMeta('board');
  @override
  late final GeneratedColumn<String> board = GeneratedColumn<String>(
    'board',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
    'grade',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _marksMeta = const VerificationMeta('marks');
  @override
  late final GeneratedColumn<String> marks = GeneratedColumn<String>(
    'marks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unstructuredLearningMeta =
      const VerificationMeta('unstructuredLearning');
  @override
  late final GeneratedColumn<String> unstructuredLearning =
      GeneratedColumn<String>(
        'unstructured_learning',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isPendingSyncMeta = const VerificationMeta(
    'isPendingSync',
  );
  @override
  late final GeneratedColumn<bool> isPendingSync = GeneratedColumn<bool>(
    'is_pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    age,
    state,
    district,
    incomeBracket,
    casteCategory,
    curriculum,
    skills,
    subjects,
    interests,
    aspirations,
    gender,
    preferredLanguage,
    isFirstGenLearner,
    hasFormalCurriculum,
    board,
    grade,
    marks,
    unstructuredLearning,
    isPendingSync,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    }
    if (data.containsKey('income_bracket')) {
      context.handle(
        _incomeBracketMeta,
        incomeBracket.isAcceptableOrUnknown(
          data['income_bracket']!,
          _incomeBracketMeta,
        ),
      );
    }
    if (data.containsKey('caste_category')) {
      context.handle(
        _casteCategoryMeta,
        casteCategory.isAcceptableOrUnknown(
          data['caste_category']!,
          _casteCategoryMeta,
        ),
      );
    }
    if (data.containsKey('curriculum')) {
      context.handle(
        _curriculumMeta,
        curriculum.isAcceptableOrUnknown(data['curriculum']!, _curriculumMeta),
      );
    }
    if (data.containsKey('skills')) {
      context.handle(
        _skillsMeta,
        skills.isAcceptableOrUnknown(data['skills']!, _skillsMeta),
      );
    }
    if (data.containsKey('subjects')) {
      context.handle(
        _subjectsMeta,
        subjects.isAcceptableOrUnknown(data['subjects']!, _subjectsMeta),
      );
    }
    if (data.containsKey('interests')) {
      context.handle(
        _interestsMeta,
        interests.isAcceptableOrUnknown(data['interests']!, _interestsMeta),
      );
    }
    if (data.containsKey('aspirations')) {
      context.handle(
        _aspirationsMeta,
        aspirations.isAcceptableOrUnknown(
          data['aspirations']!,
          _aspirationsMeta,
        ),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('preferred_language')) {
      context.handle(
        _preferredLanguageMeta,
        preferredLanguage.isAcceptableOrUnknown(
          data['preferred_language']!,
          _preferredLanguageMeta,
        ),
      );
    }
    if (data.containsKey('is_first_gen_learner')) {
      context.handle(
        _isFirstGenLearnerMeta,
        isFirstGenLearner.isAcceptableOrUnknown(
          data['is_first_gen_learner']!,
          _isFirstGenLearnerMeta,
        ),
      );
    }
    if (data.containsKey('has_formal_curriculum')) {
      context.handle(
        _hasFormalCurriculumMeta,
        hasFormalCurriculum.isAcceptableOrUnknown(
          data['has_formal_curriculum']!,
          _hasFormalCurriculumMeta,
        ),
      );
    }
    if (data.containsKey('board')) {
      context.handle(
        _boardMeta,
        board.isAcceptableOrUnknown(data['board']!, _boardMeta),
      );
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    }
    if (data.containsKey('marks')) {
      context.handle(
        _marksMeta,
        marks.isAcceptableOrUnknown(data['marks']!, _marksMeta),
      );
    }
    if (data.containsKey('unstructured_learning')) {
      context.handle(
        _unstructuredLearningMeta,
        unstructuredLearning.isAcceptableOrUnknown(
          data['unstructured_learning']!,
          _unstructuredLearningMeta,
        ),
      );
    }
    if (data.containsKey('is_pending_sync')) {
      context.handle(
        _isPendingSyncMeta,
        isPendingSync.isAcceptableOrUnknown(
          data['is_pending_sync']!,
          _isPendingSyncMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      ),
      incomeBracket: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_bracket'],
      ),
      casteCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caste_category'],
      ),
      curriculum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}curriculum'],
      ),
      skills: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skills'],
      ),
      subjects: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subjects'],
      ),
      interests: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interests'],
      ),
      aspirations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aspirations'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      preferredLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_language'],
      ),
      isFirstGenLearner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_first_gen_learner'],
      ),
      hasFormalCurriculum: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_formal_curriculum'],
      ),
      board: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}board'],
      ),
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade'],
      ),
      marks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marks'],
      ),
      unstructuredLearning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unstructured_learning'],
      ),
      isPendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_sync'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final String name;
  final int? age;
  final String? state;
  final String? district;
  final String? incomeBracket;
  final String? casteCategory;
  final String? curriculum;
  final String? skills;
  final String? subjects;
  final String? interests;
  final String? aspirations;
  final String? gender;
  final String? preferredLanguage;
  final bool? isFirstGenLearner;
  final bool? hasFormalCurriculum;
  final String? board;
  final String? grade;
  final String? marks;
  final String? unstructuredLearning;
  final bool isPendingSync;
  final DateTime updatedAt;
  const Profile({
    required this.id,
    required this.name,
    this.age,
    this.state,
    this.district,
    this.incomeBracket,
    this.casteCategory,
    this.curriculum,
    this.skills,
    this.subjects,
    this.interests,
    this.aspirations,
    this.gender,
    this.preferredLanguage,
    this.isFirstGenLearner,
    this.hasFormalCurriculum,
    this.board,
    this.grade,
    this.marks,
    this.unstructuredLearning,
    required this.isPendingSync,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    if (!nullToAbsent || incomeBracket != null) {
      map['income_bracket'] = Variable<String>(incomeBracket);
    }
    if (!nullToAbsent || casteCategory != null) {
      map['caste_category'] = Variable<String>(casteCategory);
    }
    if (!nullToAbsent || curriculum != null) {
      map['curriculum'] = Variable<String>(curriculum);
    }
    if (!nullToAbsent || skills != null) {
      map['skills'] = Variable<String>(skills);
    }
    if (!nullToAbsent || subjects != null) {
      map['subjects'] = Variable<String>(subjects);
    }
    if (!nullToAbsent || interests != null) {
      map['interests'] = Variable<String>(interests);
    }
    if (!nullToAbsent || aspirations != null) {
      map['aspirations'] = Variable<String>(aspirations);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || preferredLanguage != null) {
      map['preferred_language'] = Variable<String>(preferredLanguage);
    }
    if (!nullToAbsent || isFirstGenLearner != null) {
      map['is_first_gen_learner'] = Variable<bool>(isFirstGenLearner);
    }
    if (!nullToAbsent || hasFormalCurriculum != null) {
      map['has_formal_curriculum'] = Variable<bool>(hasFormalCurriculum);
    }
    if (!nullToAbsent || board != null) {
      map['board'] = Variable<String>(board);
    }
    if (!nullToAbsent || grade != null) {
      map['grade'] = Variable<String>(grade);
    }
    if (!nullToAbsent || marks != null) {
      map['marks'] = Variable<String>(marks);
    }
    if (!nullToAbsent || unstructuredLearning != null) {
      map['unstructured_learning'] = Variable<String>(unstructuredLearning);
    }
    map['is_pending_sync'] = Variable<bool>(isPendingSync);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      incomeBracket: incomeBracket == null && nullToAbsent
          ? const Value.absent()
          : Value(incomeBracket),
      casteCategory: casteCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(casteCategory),
      curriculum: curriculum == null && nullToAbsent
          ? const Value.absent()
          : Value(curriculum),
      skills: skills == null && nullToAbsent
          ? const Value.absent()
          : Value(skills),
      subjects: subjects == null && nullToAbsent
          ? const Value.absent()
          : Value(subjects),
      interests: interests == null && nullToAbsent
          ? const Value.absent()
          : Value(interests),
      aspirations: aspirations == null && nullToAbsent
          ? const Value.absent()
          : Value(aspirations),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      preferredLanguage: preferredLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredLanguage),
      isFirstGenLearner: isFirstGenLearner == null && nullToAbsent
          ? const Value.absent()
          : Value(isFirstGenLearner),
      hasFormalCurriculum: hasFormalCurriculum == null && nullToAbsent
          ? const Value.absent()
          : Value(hasFormalCurriculum),
      board: board == null && nullToAbsent
          ? const Value.absent()
          : Value(board),
      grade: grade == null && nullToAbsent
          ? const Value.absent()
          : Value(grade),
      marks: marks == null && nullToAbsent
          ? const Value.absent()
          : Value(marks),
      unstructuredLearning: unstructuredLearning == null && nullToAbsent
          ? const Value.absent()
          : Value(unstructuredLearning),
      isPendingSync: Value(isPendingSync),
      updatedAt: Value(updatedAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int?>(json['age']),
      state: serializer.fromJson<String?>(json['state']),
      district: serializer.fromJson<String?>(json['district']),
      incomeBracket: serializer.fromJson<String?>(json['incomeBracket']),
      casteCategory: serializer.fromJson<String?>(json['casteCategory']),
      curriculum: serializer.fromJson<String?>(json['curriculum']),
      skills: serializer.fromJson<String?>(json['skills']),
      subjects: serializer.fromJson<String?>(json['subjects']),
      interests: serializer.fromJson<String?>(json['interests']),
      aspirations: serializer.fromJson<String?>(json['aspirations']),
      gender: serializer.fromJson<String?>(json['gender']),
      preferredLanguage: serializer.fromJson<String?>(
        json['preferredLanguage'],
      ),
      isFirstGenLearner: serializer.fromJson<bool?>(json['isFirstGenLearner']),
      hasFormalCurriculum: serializer.fromJson<bool?>(
        json['hasFormalCurriculum'],
      ),
      board: serializer.fromJson<String?>(json['board']),
      grade: serializer.fromJson<String?>(json['grade']),
      marks: serializer.fromJson<String?>(json['marks']),
      unstructuredLearning: serializer.fromJson<String?>(
        json['unstructuredLearning'],
      ),
      isPendingSync: serializer.fromJson<bool>(json['isPendingSync']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int?>(age),
      'state': serializer.toJson<String?>(state),
      'district': serializer.toJson<String?>(district),
      'incomeBracket': serializer.toJson<String?>(incomeBracket),
      'casteCategory': serializer.toJson<String?>(casteCategory),
      'curriculum': serializer.toJson<String?>(curriculum),
      'skills': serializer.toJson<String?>(skills),
      'subjects': serializer.toJson<String?>(subjects),
      'interests': serializer.toJson<String?>(interests),
      'aspirations': serializer.toJson<String?>(aspirations),
      'gender': serializer.toJson<String?>(gender),
      'preferredLanguage': serializer.toJson<String?>(preferredLanguage),
      'isFirstGenLearner': serializer.toJson<bool?>(isFirstGenLearner),
      'hasFormalCurriculum': serializer.toJson<bool?>(hasFormalCurriculum),
      'board': serializer.toJson<String?>(board),
      'grade': serializer.toJson<String?>(grade),
      'marks': serializer.toJson<String?>(marks),
      'unstructuredLearning': serializer.toJson<String?>(unstructuredLearning),
      'isPendingSync': serializer.toJson<bool>(isPendingSync),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Profile copyWith({
    String? id,
    String? name,
    Value<int?> age = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> district = const Value.absent(),
    Value<String?> incomeBracket = const Value.absent(),
    Value<String?> casteCategory = const Value.absent(),
    Value<String?> curriculum = const Value.absent(),
    Value<String?> skills = const Value.absent(),
    Value<String?> subjects = const Value.absent(),
    Value<String?> interests = const Value.absent(),
    Value<String?> aspirations = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> preferredLanguage = const Value.absent(),
    Value<bool?> isFirstGenLearner = const Value.absent(),
    Value<bool?> hasFormalCurriculum = const Value.absent(),
    Value<String?> board = const Value.absent(),
    Value<String?> grade = const Value.absent(),
    Value<String?> marks = const Value.absent(),
    Value<String?> unstructuredLearning = const Value.absent(),
    bool? isPendingSync,
    DateTime? updatedAt,
  }) => Profile(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age.present ? age.value : this.age,
    state: state.present ? state.value : this.state,
    district: district.present ? district.value : this.district,
    incomeBracket: incomeBracket.present
        ? incomeBracket.value
        : this.incomeBracket,
    casteCategory: casteCategory.present
        ? casteCategory.value
        : this.casteCategory,
    curriculum: curriculum.present ? curriculum.value : this.curriculum,
    skills: skills.present ? skills.value : this.skills,
    subjects: subjects.present ? subjects.value : this.subjects,
    interests: interests.present ? interests.value : this.interests,
    aspirations: aspirations.present ? aspirations.value : this.aspirations,
    gender: gender.present ? gender.value : this.gender,
    preferredLanguage: preferredLanguage.present
        ? preferredLanguage.value
        : this.preferredLanguage,
    isFirstGenLearner: isFirstGenLearner.present
        ? isFirstGenLearner.value
        : this.isFirstGenLearner,
    hasFormalCurriculum: hasFormalCurriculum.present
        ? hasFormalCurriculum.value
        : this.hasFormalCurriculum,
    board: board.present ? board.value : this.board,
    grade: grade.present ? grade.value : this.grade,
    marks: marks.present ? marks.value : this.marks,
    unstructuredLearning: unstructuredLearning.present
        ? unstructuredLearning.value
        : this.unstructuredLearning,
    isPendingSync: isPendingSync ?? this.isPendingSync,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      state: data.state.present ? data.state.value : this.state,
      district: data.district.present ? data.district.value : this.district,
      incomeBracket: data.incomeBracket.present
          ? data.incomeBracket.value
          : this.incomeBracket,
      casteCategory: data.casteCategory.present
          ? data.casteCategory.value
          : this.casteCategory,
      curriculum: data.curriculum.present
          ? data.curriculum.value
          : this.curriculum,
      skills: data.skills.present ? data.skills.value : this.skills,
      subjects: data.subjects.present ? data.subjects.value : this.subjects,
      interests: data.interests.present ? data.interests.value : this.interests,
      aspirations: data.aspirations.present
          ? data.aspirations.value
          : this.aspirations,
      gender: data.gender.present ? data.gender.value : this.gender,
      preferredLanguage: data.preferredLanguage.present
          ? data.preferredLanguage.value
          : this.preferredLanguage,
      isFirstGenLearner: data.isFirstGenLearner.present
          ? data.isFirstGenLearner.value
          : this.isFirstGenLearner,
      hasFormalCurriculum: data.hasFormalCurriculum.present
          ? data.hasFormalCurriculum.value
          : this.hasFormalCurriculum,
      board: data.board.present ? data.board.value : this.board,
      grade: data.grade.present ? data.grade.value : this.grade,
      marks: data.marks.present ? data.marks.value : this.marks,
      unstructuredLearning: data.unstructuredLearning.present
          ? data.unstructuredLearning.value
          : this.unstructuredLearning,
      isPendingSync: data.isPendingSync.present
          ? data.isPendingSync.value
          : this.isPendingSync,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('state: $state, ')
          ..write('district: $district, ')
          ..write('incomeBracket: $incomeBracket, ')
          ..write('casteCategory: $casteCategory, ')
          ..write('curriculum: $curriculum, ')
          ..write('skills: $skills, ')
          ..write('subjects: $subjects, ')
          ..write('interests: $interests, ')
          ..write('aspirations: $aspirations, ')
          ..write('gender: $gender, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('isFirstGenLearner: $isFirstGenLearner, ')
          ..write('hasFormalCurriculum: $hasFormalCurriculum, ')
          ..write('board: $board, ')
          ..write('grade: $grade, ')
          ..write('marks: $marks, ')
          ..write('unstructuredLearning: $unstructuredLearning, ')
          ..write('isPendingSync: $isPendingSync, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    age,
    state,
    district,
    incomeBracket,
    casteCategory,
    curriculum,
    skills,
    subjects,
    interests,
    aspirations,
    gender,
    preferredLanguage,
    isFirstGenLearner,
    hasFormalCurriculum,
    board,
    grade,
    marks,
    unstructuredLearning,
    isPendingSync,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.state == this.state &&
          other.district == this.district &&
          other.incomeBracket == this.incomeBracket &&
          other.casteCategory == this.casteCategory &&
          other.curriculum == this.curriculum &&
          other.skills == this.skills &&
          other.subjects == this.subjects &&
          other.interests == this.interests &&
          other.aspirations == this.aspirations &&
          other.gender == this.gender &&
          other.preferredLanguage == this.preferredLanguage &&
          other.isFirstGenLearner == this.isFirstGenLearner &&
          other.hasFormalCurriculum == this.hasFormalCurriculum &&
          other.board == this.board &&
          other.grade == this.grade &&
          other.marks == this.marks &&
          other.unstructuredLearning == this.unstructuredLearning &&
          other.isPendingSync == this.isPendingSync &&
          other.updatedAt == this.updatedAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> age;
  final Value<String?> state;
  final Value<String?> district;
  final Value<String?> incomeBracket;
  final Value<String?> casteCategory;
  final Value<String?> curriculum;
  final Value<String?> skills;
  final Value<String?> subjects;
  final Value<String?> interests;
  final Value<String?> aspirations;
  final Value<String?> gender;
  final Value<String?> preferredLanguage;
  final Value<bool?> isFirstGenLearner;
  final Value<bool?> hasFormalCurriculum;
  final Value<String?> board;
  final Value<String?> grade;
  final Value<String?> marks;
  final Value<String?> unstructuredLearning;
  final Value<bool> isPendingSync;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.state = const Value.absent(),
    this.district = const Value.absent(),
    this.incomeBracket = const Value.absent(),
    this.casteCategory = const Value.absent(),
    this.curriculum = const Value.absent(),
    this.skills = const Value.absent(),
    this.subjects = const Value.absent(),
    this.interests = const Value.absent(),
    this.aspirations = const Value.absent(),
    this.gender = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.isFirstGenLearner = const Value.absent(),
    this.hasFormalCurriculum = const Value.absent(),
    this.board = const Value.absent(),
    this.grade = const Value.absent(),
    this.marks = const Value.absent(),
    this.unstructuredLearning = const Value.absent(),
    this.isPendingSync = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String name,
    this.age = const Value.absent(),
    this.state = const Value.absent(),
    this.district = const Value.absent(),
    this.incomeBracket = const Value.absent(),
    this.casteCategory = const Value.absent(),
    this.curriculum = const Value.absent(),
    this.skills = const Value.absent(),
    this.subjects = const Value.absent(),
    this.interests = const Value.absent(),
    this.aspirations = const Value.absent(),
    this.gender = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.isFirstGenLearner = const Value.absent(),
    this.hasFormalCurriculum = const Value.absent(),
    this.board = const Value.absent(),
    this.grade = const Value.absent(),
    this.marks = const Value.absent(),
    this.unstructuredLearning = const Value.absent(),
    this.isPendingSync = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? state,
    Expression<String>? district,
    Expression<String>? incomeBracket,
    Expression<String>? casteCategory,
    Expression<String>? curriculum,
    Expression<String>? skills,
    Expression<String>? subjects,
    Expression<String>? interests,
    Expression<String>? aspirations,
    Expression<String>? gender,
    Expression<String>? preferredLanguage,
    Expression<bool>? isFirstGenLearner,
    Expression<bool>? hasFormalCurriculum,
    Expression<String>? board,
    Expression<String>? grade,
    Expression<String>? marks,
    Expression<String>? unstructuredLearning,
    Expression<bool>? isPendingSync,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (state != null) 'state': state,
      if (district != null) 'district': district,
      if (incomeBracket != null) 'income_bracket': incomeBracket,
      if (casteCategory != null) 'caste_category': casteCategory,
      if (curriculum != null) 'curriculum': curriculum,
      if (skills != null) 'skills': skills,
      if (subjects != null) 'subjects': subjects,
      if (interests != null) 'interests': interests,
      if (aspirations != null) 'aspirations': aspirations,
      if (gender != null) 'gender': gender,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (isFirstGenLearner != null) 'is_first_gen_learner': isFirstGenLearner,
      if (hasFormalCurriculum != null)
        'has_formal_curriculum': hasFormalCurriculum,
      if (board != null) 'board': board,
      if (grade != null) 'grade': grade,
      if (marks != null) 'marks': marks,
      if (unstructuredLearning != null)
        'unstructured_learning': unstructuredLearning,
      if (isPendingSync != null) 'is_pending_sync': isPendingSync,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int?>? age,
    Value<String?>? state,
    Value<String?>? district,
    Value<String?>? incomeBracket,
    Value<String?>? casteCategory,
    Value<String?>? curriculum,
    Value<String?>? skills,
    Value<String?>? subjects,
    Value<String?>? interests,
    Value<String?>? aspirations,
    Value<String?>? gender,
    Value<String?>? preferredLanguage,
    Value<bool?>? isFirstGenLearner,
    Value<bool?>? hasFormalCurriculum,
    Value<String?>? board,
    Value<String?>? grade,
    Value<String?>? marks,
    Value<String?>? unstructuredLearning,
    Value<bool>? isPendingSync,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      state: state ?? this.state,
      district: district ?? this.district,
      incomeBracket: incomeBracket ?? this.incomeBracket,
      casteCategory: casteCategory ?? this.casteCategory,
      curriculum: curriculum ?? this.curriculum,
      skills: skills ?? this.skills,
      subjects: subjects ?? this.subjects,
      interests: interests ?? this.interests,
      aspirations: aspirations ?? this.aspirations,
      gender: gender ?? this.gender,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      isFirstGenLearner: isFirstGenLearner ?? this.isFirstGenLearner,
      hasFormalCurriculum: hasFormalCurriculum ?? this.hasFormalCurriculum,
      board: board ?? this.board,
      grade: grade ?? this.grade,
      marks: marks ?? this.marks,
      unstructuredLearning: unstructuredLearning ?? this.unstructuredLearning,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (incomeBracket.present) {
      map['income_bracket'] = Variable<String>(incomeBracket.value);
    }
    if (casteCategory.present) {
      map['caste_category'] = Variable<String>(casteCategory.value);
    }
    if (curriculum.present) {
      map['curriculum'] = Variable<String>(curriculum.value);
    }
    if (skills.present) {
      map['skills'] = Variable<String>(skills.value);
    }
    if (subjects.present) {
      map['subjects'] = Variable<String>(subjects.value);
    }
    if (interests.present) {
      map['interests'] = Variable<String>(interests.value);
    }
    if (aspirations.present) {
      map['aspirations'] = Variable<String>(aspirations.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (preferredLanguage.present) {
      map['preferred_language'] = Variable<String>(preferredLanguage.value);
    }
    if (isFirstGenLearner.present) {
      map['is_first_gen_learner'] = Variable<bool>(isFirstGenLearner.value);
    }
    if (hasFormalCurriculum.present) {
      map['has_formal_curriculum'] = Variable<bool>(hasFormalCurriculum.value);
    }
    if (board.present) {
      map['board'] = Variable<String>(board.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (marks.present) {
      map['marks'] = Variable<String>(marks.value);
    }
    if (unstructuredLearning.present) {
      map['unstructured_learning'] = Variable<String>(
        unstructuredLearning.value,
      );
    }
    if (isPendingSync.present) {
      map['is_pending_sync'] = Variable<bool>(isPendingSync.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('state: $state, ')
          ..write('district: $district, ')
          ..write('incomeBracket: $incomeBracket, ')
          ..write('casteCategory: $casteCategory, ')
          ..write('curriculum: $curriculum, ')
          ..write('skills: $skills, ')
          ..write('subjects: $subjects, ')
          ..write('interests: $interests, ')
          ..write('aspirations: $aspirations, ')
          ..write('gender: $gender, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('isFirstGenLearner: $isFirstGenLearner, ')
          ..write('hasFormalCurriculum: $hasFormalCurriculum, ')
          ..write('board: $board, ')
          ..write('grade: $grade, ')
          ..write('marks: $marks, ')
          ..write('unstructuredLearning: $unstructuredLearning, ')
          ..write('isPendingSync: $isPendingSync, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OpportunitiesTable extends Opportunities
    with TableInfo<$OpportunitiesTable, Opportunity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpportunitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eligibilityMeta = const VerificationMeta(
    'eligibility',
  );
  @override
  late final GeneratedColumn<String> eligibility = GeneratedColumn<String>(
    'eligibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<String> deadline = GeneratedColumn<String>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    category,
    provider,
    description,
    eligibility,
    deadline,
    url,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'opportunities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Opportunity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('eligibility')) {
      context.handle(
        _eligibilityMeta,
        eligibility.isAcceptableOrUnknown(
          data['eligibility']!,
          _eligibilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eligibilityMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Opportunity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Opportunity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      eligibility: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eligibility'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deadline'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $OpportunitiesTable createAlias(String alias) {
    return $OpportunitiesTable(attachedDatabase, alias);
  }
}

class Opportunity extends DataClass implements Insertable<Opportunity> {
  final String id;
  final String title;
  final String category;
  final String provider;
  final String description;
  final String eligibility;
  final String? deadline;
  final String? url;
  final DateTime cachedAt;
  const Opportunity({
    required this.id,
    required this.title,
    required this.category,
    required this.provider,
    required this.description,
    required this.eligibility,
    this.deadline,
    this.url,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['provider'] = Variable<String>(provider);
    map['description'] = Variable<String>(description);
    map['eligibility'] = Variable<String>(eligibility);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<String>(deadline);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  OpportunitiesCompanion toCompanion(bool nullToAbsent) {
    return OpportunitiesCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      provider: Value(provider),
      description: Value(description),
      eligibility: Value(eligibility),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      cachedAt: Value(cachedAt),
    );
  }

  factory Opportunity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Opportunity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      provider: serializer.fromJson<String>(json['provider']),
      description: serializer.fromJson<String>(json['description']),
      eligibility: serializer.fromJson<String>(json['eligibility']),
      deadline: serializer.fromJson<String?>(json['deadline']),
      url: serializer.fromJson<String?>(json['url']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'provider': serializer.toJson<String>(provider),
      'description': serializer.toJson<String>(description),
      'eligibility': serializer.toJson<String>(eligibility),
      'deadline': serializer.toJson<String?>(deadline),
      'url': serializer.toJson<String?>(url),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  Opportunity copyWith({
    String? id,
    String? title,
    String? category,
    String? provider,
    String? description,
    String? eligibility,
    Value<String?> deadline = const Value.absent(),
    Value<String?> url = const Value.absent(),
    DateTime? cachedAt,
  }) => Opportunity(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    provider: provider ?? this.provider,
    description: description ?? this.description,
    eligibility: eligibility ?? this.eligibility,
    deadline: deadline.present ? deadline.value : this.deadline,
    url: url.present ? url.value : this.url,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  Opportunity copyWithCompanion(OpportunitiesCompanion data) {
    return Opportunity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      provider: data.provider.present ? data.provider.value : this.provider,
      description: data.description.present
          ? data.description.value
          : this.description,
      eligibility: data.eligibility.present
          ? data.eligibility.value
          : this.eligibility,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      url: data.url.present ? data.url.value : this.url,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Opportunity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('provider: $provider, ')
          ..write('description: $description, ')
          ..write('eligibility: $eligibility, ')
          ..write('deadline: $deadline, ')
          ..write('url: $url, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    provider,
    description,
    eligibility,
    deadline,
    url,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Opportunity &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.provider == this.provider &&
          other.description == this.description &&
          other.eligibility == this.eligibility &&
          other.deadline == this.deadline &&
          other.url == this.url &&
          other.cachedAt == this.cachedAt);
}

class OpportunitiesCompanion extends UpdateCompanion<Opportunity> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> category;
  final Value<String> provider;
  final Value<String> description;
  final Value<String> eligibility;
  final Value<String?> deadline;
  final Value<String?> url;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const OpportunitiesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.provider = const Value.absent(),
    this.description = const Value.absent(),
    this.eligibility = const Value.absent(),
    this.deadline = const Value.absent(),
    this.url = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OpportunitiesCompanion.insert({
    required String id,
    required String title,
    required String category,
    required String provider,
    required String description,
    required String eligibility,
    this.deadline = const Value.absent(),
    this.url = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       category = Value(category),
       provider = Value(provider),
       description = Value(description),
       eligibility = Value(eligibility);
  static Insertable<Opportunity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? provider,
    Expression<String>? description,
    Expression<String>? eligibility,
    Expression<String>? deadline,
    Expression<String>? url,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (provider != null) 'provider': provider,
      if (description != null) 'description': description,
      if (eligibility != null) 'eligibility': eligibility,
      if (deadline != null) 'deadline': deadline,
      if (url != null) 'url': url,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OpportunitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? category,
    Value<String>? provider,
    Value<String>? description,
    Value<String>? eligibility,
    Value<String?>? deadline,
    Value<String?>? url,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return OpportunitiesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      provider: provider ?? this.provider,
      description: description ?? this.description,
      eligibility: eligibility ?? this.eligibility,
      deadline: deadline ?? this.deadline,
      url: url ?? this.url,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (eligibility.present) {
      map['eligibility'] = Variable<String>(eligibility.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<String>(deadline.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpportunitiesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('provider: $provider, ')
          ..write('description: $description, ')
          ..write('eligibility: $eligibility, ')
          ..write('deadline: $deadline, ')
          ..write('url: $url, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OnboardingDraftsTable extends OnboardingDrafts
    with TableInfo<$OnboardingDraftsTable, OnboardingDraftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnboardingDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStepMeta = const VerificationMeta(
    'currentStep',
  );
  @override
  late final GeneratedColumn<int> currentStep = GeneratedColumn<int>(
    'current_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _draftJsonMeta = const VerificationMeta(
    'draftJson',
  );
  @override
  late final GeneratedColumn<String> draftJson = GeneratedColumn<String>(
    'draft_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPendingSyncMeta = const VerificationMeta(
    'isPendingSync',
  );
  @override
  late final GeneratedColumn<bool> isPendingSync = GeneratedColumn<bool>(
    'is_pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    currentStep,
    draftJson,
    isPendingSync,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'onboarding_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnboardingDraftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('current_step')) {
      context.handle(
        _currentStepMeta,
        currentStep.isAcceptableOrUnknown(
          data['current_step']!,
          _currentStepMeta,
        ),
      );
    }
    if (data.containsKey('draft_json')) {
      context.handle(
        _draftJsonMeta,
        draftJson.isAcceptableOrUnknown(data['draft_json']!, _draftJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_draftJsonMeta);
    }
    if (data.containsKey('is_pending_sync')) {
      context.handle(
        _isPendingSyncMeta,
        isPendingSync.isAcceptableOrUnknown(
          data['is_pending_sync']!,
          _isPendingSyncMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  OnboardingDraftData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnboardingDraftData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      currentStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_step'],
      )!,
      draftJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_json'],
      )!,
      isPendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_sync'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OnboardingDraftsTable createAlias(String alias) {
    return $OnboardingDraftsTable(attachedDatabase, alias);
  }
}

class OnboardingDraftData extends DataClass
    implements Insertable<OnboardingDraftData> {
  final String userId;
  final int currentStep;
  final String draftJson;
  final bool isPendingSync;
  final DateTime updatedAt;
  const OnboardingDraftData({
    required this.userId,
    required this.currentStep,
    required this.draftJson,
    required this.isPendingSync,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['current_step'] = Variable<int>(currentStep);
    map['draft_json'] = Variable<String>(draftJson);
    map['is_pending_sync'] = Variable<bool>(isPendingSync);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OnboardingDraftsCompanion toCompanion(bool nullToAbsent) {
    return OnboardingDraftsCompanion(
      userId: Value(userId),
      currentStep: Value(currentStep),
      draftJson: Value(draftJson),
      isPendingSync: Value(isPendingSync),
      updatedAt: Value(updatedAt),
    );
  }

  factory OnboardingDraftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnboardingDraftData(
      userId: serializer.fromJson<String>(json['userId']),
      currentStep: serializer.fromJson<int>(json['currentStep']),
      draftJson: serializer.fromJson<String>(json['draftJson']),
      isPendingSync: serializer.fromJson<bool>(json['isPendingSync']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'currentStep': serializer.toJson<int>(currentStep),
      'draftJson': serializer.toJson<String>(draftJson),
      'isPendingSync': serializer.toJson<bool>(isPendingSync),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OnboardingDraftData copyWith({
    String? userId,
    int? currentStep,
    String? draftJson,
    bool? isPendingSync,
    DateTime? updatedAt,
  }) => OnboardingDraftData(
    userId: userId ?? this.userId,
    currentStep: currentStep ?? this.currentStep,
    draftJson: draftJson ?? this.draftJson,
    isPendingSync: isPendingSync ?? this.isPendingSync,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OnboardingDraftData copyWithCompanion(OnboardingDraftsCompanion data) {
    return OnboardingDraftData(
      userId: data.userId.present ? data.userId.value : this.userId,
      currentStep: data.currentStep.present
          ? data.currentStep.value
          : this.currentStep,
      draftJson: data.draftJson.present ? data.draftJson.value : this.draftJson,
      isPendingSync: data.isPendingSync.present
          ? data.isPendingSync.value
          : this.isPendingSync,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingDraftData(')
          ..write('userId: $userId, ')
          ..write('currentStep: $currentStep, ')
          ..write('draftJson: $draftJson, ')
          ..write('isPendingSync: $isPendingSync, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, currentStep, draftJson, isPendingSync, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingDraftData &&
          other.userId == this.userId &&
          other.currentStep == this.currentStep &&
          other.draftJson == this.draftJson &&
          other.isPendingSync == this.isPendingSync &&
          other.updatedAt == this.updatedAt);
}

class OnboardingDraftsCompanion extends UpdateCompanion<OnboardingDraftData> {
  final Value<String> userId;
  final Value<int> currentStep;
  final Value<String> draftJson;
  final Value<bool> isPendingSync;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OnboardingDraftsCompanion({
    this.userId = const Value.absent(),
    this.currentStep = const Value.absent(),
    this.draftJson = const Value.absent(),
    this.isPendingSync = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OnboardingDraftsCompanion.insert({
    required String userId,
    this.currentStep = const Value.absent(),
    required String draftJson,
    this.isPendingSync = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       draftJson = Value(draftJson);
  static Insertable<OnboardingDraftData> custom({
    Expression<String>? userId,
    Expression<int>? currentStep,
    Expression<String>? draftJson,
    Expression<bool>? isPendingSync,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (currentStep != null) 'current_step': currentStep,
      if (draftJson != null) 'draft_json': draftJson,
      if (isPendingSync != null) 'is_pending_sync': isPendingSync,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OnboardingDraftsCompanion copyWith({
    Value<String>? userId,
    Value<int>? currentStep,
    Value<String>? draftJson,
    Value<bool>? isPendingSync,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OnboardingDraftsCompanion(
      userId: userId ?? this.userId,
      currentStep: currentStep ?? this.currentStep,
      draftJson: draftJson ?? this.draftJson,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (currentStep.present) {
      map['current_step'] = Variable<int>(currentStep.value);
    }
    if (draftJson.present) {
      map['draft_json'] = Variable<String>(draftJson.value);
    }
    if (isPendingSync.present) {
      map['is_pending_sync'] = Variable<bool>(isPendingSync.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingDraftsCompanion(')
          ..write('userId: $userId, ')
          ..write('currentStep: $currentStep, ')
          ..write('draftJson: $draftJson, ')
          ..write('isPendingSync: $isPendingSync, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $OpportunitiesTable opportunities = $OpportunitiesTable(this);
  late final $OnboardingDraftsTable onboardingDrafts = $OnboardingDraftsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    opportunities,
    onboardingDrafts,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  required String name,
  Value<int?> age,
  Value<String?> state,
  Value<String?> district,
  Value<String?> incomeBracket,
  Value<String?> casteCategory,
  Value<String?> curriculum,
  Value<String?> skills,
  Value<String?> subjects,
  Value<String?> interests,
  Value<String?> aspirations,
  Value<String?> gender,
  Value<String?> preferredLanguage,
  Value<bool?> isFirstGenLearner,
  Value<bool?> hasFormalCurriculum,
  Value<String?> board,
  Value<String?> grade,
  Value<String?> marks,
  Value<String?> unstructuredLearning,
  Value<bool> isPendingSync,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> age,
  Value<String?> state,
  Value<String?> district,
  Value<String?> incomeBracket,
  Value<String?> casteCategory,
  Value<String?> curriculum,
  Value<String?> skills,
  Value<String?> subjects,
  Value<String?> interests,
  Value<String?> aspirations,
  Value<String?> gender,
  Value<String?> preferredLanguage,
  Value<bool?> isFirstGenLearner,
  Value<bool?> hasFormalCurriculum,
  Value<String?> board,
  Value<String?> grade,
  Value<String?> marks,
  Value<String?> unstructuredLearning,
  Value<bool> isPendingSync,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incomeBracket => $composableBuilder(
    column: $table.incomeBracket,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get casteCategory => $composableBuilder(
    column: $table.casteCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get curriculum => $composableBuilder(
    column: $table.curriculum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skills => $composableBuilder(
    column: $table.skills,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjects => $composableBuilder(
    column: $table.subjects,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interests => $composableBuilder(
    column: $table.interests,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aspirations => $composableBuilder(
    column: $table.aspirations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFirstGenLearner => $composableBuilder(
    column: $table.isFirstGenLearner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasFormalCurriculum => $composableBuilder(
    column: $table.hasFormalCurriculum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get board => $composableBuilder(
    column: $table.board,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marks => $composableBuilder(
    column: $table.marks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unstructuredLearning => $composableBuilder(
    column: $table.unstructuredLearning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incomeBracket => $composableBuilder(
    column: $table.incomeBracket,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get casteCategory => $composableBuilder(
    column: $table.casteCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get curriculum => $composableBuilder(
    column: $table.curriculum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skills => $composableBuilder(
    column: $table.skills,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjects => $composableBuilder(
    column: $table.subjects,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interests => $composableBuilder(
    column: $table.interests,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aspirations => $composableBuilder(
    column: $table.aspirations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFirstGenLearner => $composableBuilder(
    column: $table.isFirstGenLearner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasFormalCurriculum => $composableBuilder(
    column: $table.hasFormalCurriculum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get board => $composableBuilder(
    column: $table.board,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marks => $composableBuilder(
    column: $table.marks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unstructuredLearning => $composableBuilder(
    column: $table.unstructuredLearning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get incomeBracket => $composableBuilder(
    column: $table.incomeBracket,
    builder: (column) => column,
  );

  GeneratedColumn<String> get casteCategory => $composableBuilder(
    column: $table.casteCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get curriculum => $composableBuilder(
    column: $table.curriculum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get skills =>
      $composableBuilder(column: $table.skills, builder: (column) => column);

  GeneratedColumn<String> get subjects =>
      $composableBuilder(column: $table.subjects, builder: (column) => column);

  GeneratedColumn<String> get interests =>
      $composableBuilder(column: $table.interests, builder: (column) => column);

  GeneratedColumn<String> get aspirations => $composableBuilder(
    column: $table.aspirations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFirstGenLearner => $composableBuilder(
    column: $table.isFirstGenLearner,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasFormalCurriculum => $composableBuilder(
    column: $table.hasFormalCurriculum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get board =>
      $composableBuilder(column: $table.board, builder: (column) => column);

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get marks =>
      $composableBuilder(column: $table.marks, builder: (column) => column);

  GeneratedColumn<String> get unstructuredLearning => $composableBuilder(
    column: $table.unstructuredLearning,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> incomeBracket = const Value.absent(),
                Value<String?> casteCategory = const Value.absent(),
                Value<String?> curriculum = const Value.absent(),
                Value<String?> skills = const Value.absent(),
                Value<String?> subjects = const Value.absent(),
                Value<String?> interests = const Value.absent(),
                Value<String?> aspirations = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> preferredLanguage = const Value.absent(),
                Value<bool?> isFirstGenLearner = const Value.absent(),
                Value<bool?> hasFormalCurriculum = const Value.absent(),
                Value<String?> board = const Value.absent(),
                Value<String?> grade = const Value.absent(),
                Value<String?> marks = const Value.absent(),
                Value<String?> unstructuredLearning = const Value.absent(),
                Value<bool> isPendingSync = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                age: age,
                state: state,
                district: district,
                incomeBracket: incomeBracket,
                casteCategory: casteCategory,
                curriculum: curriculum,
                skills: skills,
                subjects: subjects,
                interests: interests,
                aspirations: aspirations,
                gender: gender,
                preferredLanguage: preferredLanguage,
                isFirstGenLearner: isFirstGenLearner,
                hasFormalCurriculum: hasFormalCurriculum,
                board: board,
                grade: grade,
                marks: marks,
                unstructuredLearning: unstructuredLearning,
                isPendingSync: isPendingSync,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int?> age = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> district = const Value.absent(),
                Value<String?> incomeBracket = const Value.absent(),
                Value<String?> casteCategory = const Value.absent(),
                Value<String?> curriculum = const Value.absent(),
                Value<String?> skills = const Value.absent(),
                Value<String?> subjects = const Value.absent(),
                Value<String?> interests = const Value.absent(),
                Value<String?> aspirations = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> preferredLanguage = const Value.absent(),
                Value<bool?> isFirstGenLearner = const Value.absent(),
                Value<bool?> hasFormalCurriculum = const Value.absent(),
                Value<String?> board = const Value.absent(),
                Value<String?> grade = const Value.absent(),
                Value<String?> marks = const Value.absent(),
                Value<String?> unstructuredLearning = const Value.absent(),
                Value<bool> isPendingSync = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                age: age,
                state: state,
                district: district,
                incomeBracket: incomeBracket,
                casteCategory: casteCategory,
                curriculum: curriculum,
                skills: skills,
                subjects: subjects,
                interests: interests,
                aspirations: aspirations,
                gender: gender,
                preferredLanguage: preferredLanguage,
                isFirstGenLearner: isFirstGenLearner,
                hasFormalCurriculum: hasFormalCurriculum,
                board: board,
                grade: grade,
                marks: marks,
                unstructuredLearning: unstructuredLearning,
                isPendingSync: isPendingSync,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$OpportunitiesTableCreateCompanionBuilder =
    OpportunitiesCompanion Function({
      required String id,
      required String title,
      required String category,
      required String provider,
      required String description,
      required String eligibility,
      Value<String?> deadline,
      Value<String?> url,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$OpportunitiesTableUpdateCompanionBuilder =
    OpportunitiesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> category,
      Value<String> provider,
      Value<String> description,
      Value<String> eligibility,
      Value<String?> deadline,
      Value<String?> url,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$OpportunitiesTableFilterComposer
    extends Composer<_$AppDatabase, $OpportunitiesTable> {
  $$OpportunitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eligibility => $composableBuilder(
    column: $table.eligibility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OpportunitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $OpportunitiesTable> {
  $$OpportunitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eligibility => $composableBuilder(
    column: $table.eligibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OpportunitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OpportunitiesTable> {
  $$OpportunitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eligibility => $composableBuilder(
    column: $table.eligibility,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$OpportunitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OpportunitiesTable,
          Opportunity,
          $$OpportunitiesTableFilterComposer,
          $$OpportunitiesTableOrderingComposer,
          $$OpportunitiesTableAnnotationComposer,
          $$OpportunitiesTableCreateCompanionBuilder,
          $$OpportunitiesTableUpdateCompanionBuilder,
          (
            Opportunity,
            BaseReferences<_$AppDatabase, $OpportunitiesTable, Opportunity>,
          ),
          Opportunity,
          PrefetchHooks Function()
        > {
  $$OpportunitiesTableTableManager(_$AppDatabase db, $OpportunitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OpportunitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OpportunitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OpportunitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> eligibility = const Value.absent(),
                Value<String?> deadline = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OpportunitiesCompanion(
                id: id,
                title: title,
                category: category,
                provider: provider,
                description: description,
                eligibility: eligibility,
                deadline: deadline,
                url: url,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String category,
                required String provider,
                required String description,
                required String eligibility,
                Value<String?> deadline = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OpportunitiesCompanion.insert(
                id: id,
                title: title,
                category: category,
                provider: provider,
                description: description,
                eligibility: eligibility,
                deadline: deadline,
                url: url,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OpportunitiesTable, Opportunity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OpportunitiesTable,
                    Opportunity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OpportunitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OpportunitiesTable,
      Opportunity,
      $$OpportunitiesTableFilterComposer,
      $$OpportunitiesTableOrderingComposer,
      $$OpportunitiesTableAnnotationComposer,
      $$OpportunitiesTableCreateCompanionBuilder,
      $$OpportunitiesTableUpdateCompanionBuilder,
      (
        Opportunity,
        BaseReferences<_$AppDatabase, $OpportunitiesTable, Opportunity>,
      ),
      Opportunity,
      PrefetchHooks Function()
    >;
typedef $$OnboardingDraftsTableCreateCompanionBuilder =
    OnboardingDraftsCompanion Function({
      required String userId,
      Value<int> currentStep,
      required String draftJson,
      Value<bool> isPendingSync,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$OnboardingDraftsTableUpdateCompanionBuilder =
    OnboardingDraftsCompanion Function({
      Value<String> userId,
      Value<int> currentStep,
      Value<String> draftJson,
      Value<bool> isPendingSync,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OnboardingDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $OnboardingDraftsTable> {
  $$OnboardingDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get draftJson => $composableBuilder(
    column: $table.draftJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OnboardingDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $OnboardingDraftsTable> {
  $$OnboardingDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draftJson => $composableBuilder(
    column: $table.draftJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OnboardingDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnboardingDraftsTable> {
  $$OnboardingDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => column,
  );

  GeneratedColumn<String> get draftJson =>
      $composableBuilder(column: $table.draftJson, builder: (column) => column);

  GeneratedColumn<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OnboardingDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnboardingDraftsTable,
          OnboardingDraftData,
          $$OnboardingDraftsTableFilterComposer,
          $$OnboardingDraftsTableOrderingComposer,
          $$OnboardingDraftsTableAnnotationComposer,
          $$OnboardingDraftsTableCreateCompanionBuilder,
          $$OnboardingDraftsTableUpdateCompanionBuilder,
          (
            OnboardingDraftData,
            BaseReferences<
              _$AppDatabase,
              $OnboardingDraftsTable,
              OnboardingDraftData
            >,
          ),
          OnboardingDraftData,
          PrefetchHooks Function()
        > {
  $$OnboardingDraftsTableTableManager(
    _$AppDatabase db,
    $OnboardingDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnboardingDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnboardingDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OnboardingDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> currentStep = const Value.absent(),
                Value<String> draftJson = const Value.absent(),
                Value<bool> isPendingSync = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnboardingDraftsCompanion(
                userId: userId,
                currentStep: currentStep,
                draftJson: draftJson,
                isPendingSync: isPendingSync,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<int> currentStep = const Value.absent(),
                required String draftJson,
                Value<bool> isPendingSync = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnboardingDraftsCompanion.insert(
                userId: userId,
                currentStep: currentStep,
                draftJson: draftJson,
                isPendingSync: isPendingSync,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OnboardingDraftsTable, OnboardingDraftData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $OnboardingDraftsTable,
                    OnboardingDraftData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OnboardingDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnboardingDraftsTable,
      OnboardingDraftData,
      $$OnboardingDraftsTableFilterComposer,
      $$OnboardingDraftsTableOrderingComposer,
      $$OnboardingDraftsTableAnnotationComposer,
      $$OnboardingDraftsTableCreateCompanionBuilder,
      $$OnboardingDraftsTableUpdateCompanionBuilder,
      (
        OnboardingDraftData,
        BaseReferences<
          _$AppDatabase,
          $OnboardingDraftsTable,
          OnboardingDraftData
        >,
      ),
      OnboardingDraftData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$OpportunitiesTableTableManager get opportunities =>
      $$OpportunitiesTableTableManager(_db, _db.opportunities);
  $$OnboardingDraftsTableTableManager get onboardingDrafts =>
      $$OnboardingDraftsTableTableManager(_db, _db.onboardingDrafts);
}
