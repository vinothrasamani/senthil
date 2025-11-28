import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/model/feedback_form_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

var rate = StateProvider.autoDispose<double>((ref) => 0);

class SubjectRatingCard extends ConsumerWidget {
  const SubjectRatingCard({
    super.key,
    required this.hasRating,
    required this.isSmallScreen,
    required this.subject,
    required this.onRate,
    required this.type,
    required this.currentRating,
    required this.isDark,
  });

  final bool hasRating;
  final bool isSmallScreen;
  final double currentRating;
  final bool isDark;
  final String type;
  final void Function(double) onRate;
  final FeedFormSubject subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(rate.notifier).state = currentRating);

    final Color bg1 = isDark
        ? (hasRating ? const Color(0xFF2B1E18) : const Color(0xFF1A1A1D))
        : (hasRating ? Colors.orange.shade50 : Colors.white);
    final Color bg2 = isDark
        ? (hasRating ? const Color(0xFF1E1C1A) : const Color(0xFF2A2A2E))
        : (hasRating ? Colors.white : Colors.grey.shade50);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color starColor =
        isDark ? const Color(0xFFFFA559) : const Color(0xFFFF7429);
    final Color borderColor = hasRating ? starColor : Colors.transparent;
    final Color staffBadgeBg =
        isDark ? const Color(0xFF2D234A) : Colors.deepPurple.shade50;
    final Color staffBadgeText =
        isDark ? const Color(0xFFBFA7FF) : Colors.deepPurple;
    final shadowColor =
        isDark ? starColor.withAlpha(70) : Colors.orange.withAlpha(110);

    return Card(
      elevation: hasRating ? 8 : 4,
      shadowColor: shadowColor,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [bg1, bg2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  subject.fullname,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              if (subject.staffName != null)
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: staffBadgeBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subject.staffName!,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 13,
                        color: staffBadgeText,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              RatingBar.builder(
                initialRating: currentRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: type == 'CBSE' ? 3 : 4,
                itemSize: isSmallScreen ? 28 : 32,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                unratedColor:
                    isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                glowColor: starColor.withAlpha(100),
                itemBuilder: (context, _) =>
                    Icon(Icons.star_rounded, color: starColor),
                onRatingUpdate: (rating) {
                  ref.read(rate.notifier).state = rating;
                  onRate(rating);
                },
              ),
              const SizedBox(height: 8),
              Text(
                hasRating
                    ? _getRatingLabel(currentRating.toInt())
                    : 'Tap to rate',
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: hasRating
                      ? starColor
                      : (isDark ? Colors.grey.shade400 : Colors.grey),
                  fontWeight: hasRating ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    if (type == "CBSE") {
      switch (rating) {
        case 1:
          return 'To Be Improved';
        case 2:
          return 'Average';
        case 3:
          return 'Good';
        default:
          return '';
      }
    } else {
      switch (rating) {
        case 1:
          return 'Average';
        case 2:
          return 'Satisfied';
        case 3:
          return 'Good';
        case 4:
          return 'Very Good';
        default:
          return '';
      }
    }
  }
}
