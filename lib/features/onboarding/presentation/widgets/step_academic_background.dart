import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/onboarding_providers.dart';

class StepAcademicBackground extends ConsumerStatefulWidget {
  const StepAcademicBackground({super.key});

  @override
  ConsumerState<StepAcademicBackground> createState() => _StepAcademicBackgroundState();
}

class _StepAcademicBackgroundState extends ConsumerState<StepAcademicBackground> {
  bool _hasFormalCurriculum = true;
  String _selectedBoard = '';
  String _selectedGrade = '';
  late TextEditingController _marksController;
  late TextEditingController _unstructuredController;
  final Set<String> _selectedPracticalSubjects = {};
  bool _isRecordingVoiceNote = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingStateProvider).draft;
    _hasFormalCurriculum = draft.hasFormalCurriculum;
    _selectedBoard = draft.board.isNotEmpty ? draft.board : 'State Board';
    _selectedGrade = draft.grade.isNotEmpty ? draft.grade : 'Class 10 Pass';
    _marksController = TextEditingController(text: draft.marks);
    _unstructuredController = TextEditingController(text: draft.unstructuredLearning);
    _selectedPracticalSubjects.addAll(draft.practicalSubjects);
  }

  @override
  void dispose() {
    _marksController.dispose();
    _unstructuredController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    ref.read(onboardingStateProvider.notifier).updateAcademicBackground(
          hasFormalCurriculum: _hasFormalCurriculum,
          board: _selectedBoard,
          grade: _selectedGrade,
          marks: _marksController.text.trim(),
          unstructuredLearning: _unstructuredController.text.trim(),
          practicalSubjects: _selectedPracticalSubjects.toList(),
        );
  }

  void _simulateVoiceNoteRecording(AppLocalizations l10n) {
    setState(() => _isRecordingVoiceNote = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎙️ ${l10n.voiceNoteHint}...'),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isRecordingVoiceNote = false;
          final transcribedText =
              'Studied up to Class 10 at local school. Skilled in repairing irrigation pump motors, tractor maintenance, and organic wheat farming.';
          _unstructuredController.text = transcribedText;
          _selectedPracticalSubjects.addAll(['Farming & Agriculture', 'Mobile & Electrical Repair']);
        });
        _notifyChange();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${l10n.voiceNoteRecordedSuccess}'),
            duration: const Duration(seconds: 3),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OnboardingState>(onboardingStateProvider, (prev, next) {
      if (prev?.draft != next.draft) {
        if (_selectedBoard != next.draft.board && next.draft.board.isNotEmpty) {
          setState(() => _selectedBoard = next.draft.board);
        }
        if (_selectedGrade != next.draft.grade && next.draft.grade.isNotEmpty) {
          setState(() => _selectedGrade = next.draft.grade);
        }
        if (_marksController.text != next.draft.marks) {
          _marksController.text = next.draft.marks;
        }
        if (_unstructuredController.text != next.draft.unstructuredLearning) {
          _unstructuredController.text = next.draft.unstructuredLearning;
        }
        if (_hasFormalCurriculum != next.draft.hasFormalCurriculum) {
          setState(() => _hasFormalCurriculum = next.draft.hasFormalCurriculum);
        }
        if (next.draft.practicalSubjects.isNotEmpty) {
          setState(() {
            _selectedPracticalSubjects.clear();
            _selectedPracticalSubjects.addAll(next.draft.practicalSubjects);
          });
        }
      }
    });

    final l10n = AppLocalizations.of(context)!;
    final options = ref.watch(academicOptionsProvider);
    final draft = ref.watch(onboardingStateProvider).draft;
    final practicalSubjects = options.getPracticalSubjects(state: draft.state);
    final boards = options.getEducationBoards();
    final grades = options.getGradeLevels();


    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.academicTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.academicSubtitle,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          // Segmented switch: Formal vs Practical
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    key: const Key('formal_mode_btn'),
                    onTap: () {
                      setState(() => _hasFormalCurriculum = true);
                      _notifyChange();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _hasFormalCurriculum ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _hasFormalCurriculum
                            ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          l10n.academicModeStructured,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _hasFormalCurriculum ? AppTheme.primaryBlue : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    key: const Key('unstructured_mode_btn'),
                    onTap: () {
                      setState(() => _hasFormalCurriculum = false);
                      _notifyChange();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_hasFormalCurriculum ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: !_hasFormalCurriculum
                            ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          l10n.academicModeUnstructured,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: !_hasFormalCurriculum ? AppTheme.primaryBlue : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Structured fields (Board & Grade & Marks)
          if (_hasFormalCurriculum) ...[
            Text(l10n.fieldBoard, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBDBDBD), width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  key: const Key('onboarding_board_dropdown'),
                  value: boards.contains(_selectedBoard) ? _selectedBoard : boards.first,
                  isExpanded: true,
                  items: boards
                      .map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 16))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedBoard = val);
                      _notifyChange();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(l10n.fieldGrade, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBDBDBD), width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  key: const Key('onboarding_grade_dropdown'),
                  value: grades.contains(_selectedGrade) ? _selectedGrade : grades.first,
                  isExpanded: true,
                  items: grades
                      .map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(fontSize: 16))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedGrade = val);
                      _notifyChange();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(l10n.fieldMarks, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 6),
            TextField(
              key: const Key('onboarding_marks_input'),
              controller: _marksController,
              decoration: InputDecoration(
                hintText: l10n.fieldMarksHint,
                prefixIcon: const Icon(Icons.grade_outlined),
              ),
              onChanged: (_) => _notifyChange(),
            ),
            const SizedBox(height: 24),
          ],

          // Unstructured / Self-Description & Voice Note section
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withAlpha(120),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryBlue.withAlpha(60)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.unstructuredLearningPrompt,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    // Voice note microphone button
                    InkWell(
                      key: const Key('voice_note_button'),
                      onTap: _isRecordingVoiceNote ? null : () => _simulateVoiceNoteRecording(l10n),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isRecordingVoiceNote ? AppTheme.errorRed : AppTheme.primaryBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isRecordingVoiceNote ? Icons.mic : Icons.mic_none,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.voiceNoteButton,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.unstructuredLearningHint,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 10),
                TextField(
                  key: const Key('unstructured_learning_input'),
                  controller: _unstructuredController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: l10n.unstructuredLearningHint,
                  ),
                  onChanged: (_) => _notifyChange(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Regional Practical Subjects & Skills Tag Picker
          Text(
            l10n.commonSubjectsTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.commonSubjectsSubtitle,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: practicalSubjects.map((subject) {
              final isSelected = _selectedPracticalSubjects.contains(subject);
              return FilterChip(
                key: Key('subject_chip_$subject'),
                label: Text(subject),
                selected: isSelected,
                selectedColor: AppTheme.primaryContainer,
                checkmarkColor: AppTheme.primaryBlue,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPracticalSubjects.add(subject);
                    } else {
                      _selectedPracticalSubjects.remove(subject);
                    }
                  });
                  _notifyChange();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
