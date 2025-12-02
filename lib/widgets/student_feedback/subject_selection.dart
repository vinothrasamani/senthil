import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/student_feedback_controller.dart';

class SubjectSelection extends ConsumerStatefulWidget {
  const SubjectSelection({super.key});

  @override
  ConsumerState<SubjectSelection> createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends ConsumerState<SubjectSelection> {
  final Set<String> _selectedSubjects = {};

  @override
  void initState() {
    super.initState();
    final currentSelection = ref.read(StudentFeedbackController.subject);
    if (currentSelection != null && currentSelection.isNotEmpty) {
      _selectedSubjects.addAll(currentSelection.split(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.read(StudentFeedbackController.subjectList);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, colorScheme, theme),
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant.withAlpha(175),
            ),
            Flexible(
              child: _buildContent(context, list, colorScheme, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 16, 20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.secondaryContainer
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.library_books_rounded,
                color: colorScheme.primary, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Subjects',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _selectedSubjects.isEmpty
                      ? 'Choose one or more subjects'
                      : '${_selectedSubjects.length} subject${_selectedSubjects.length > 1 ? 's' : ''} selected',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<String> list,
      ColorScheme colorScheme, ThemeData theme) {
    if (list.isEmpty) {
      return _buildEmptyState(context, colorScheme, theme);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: list
            .map((item) => _buildSubjectChip(context, item, colorScheme, theme))
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(175),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inbox_outlined,
                  size: 64, color: colorScheme.onSurfaceVariant.withAlpha(175)),
            ),
            SizedBox(height: 24),
            Text(
              'No Subjects Available',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please check back later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectChip(BuildContext context, String label,
      ColorScheme colorScheme, ThemeData theme) {
    final isSelected = _selectedSubjects.contains(label);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedSubjects.remove(label);
            } else {
              _selectedSubjects.add(label);
            }
            final result = _selectedSubjects.join(',');
            ref.read(StudentFeedbackController.subject.notifier).state = result;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.primaryContainer.withAlpha(200),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected
                ? null
                : colorScheme.surfaceContainerHighest.withAlpha(180),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withAlpha(175)
                  : colorScheme.outline.withAlpha(90),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withAlpha(65),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: 2),
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded,
                        size: 16, color: colorScheme.onPrimary)
                    : null,
              ),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
