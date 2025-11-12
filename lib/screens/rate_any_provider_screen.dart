import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/review_service.dart';
import '../services/user_service.dart';

class RateAnyProviderScreen extends StatefulWidget {
  final String providerId;
  final String providerName;
  final ProviderType providerType;
  final String? appointmentId;
  final String? description;

  const RateAnyProviderScreen({
    super.key,
    required this.providerId,
    required this.providerName,
    required this.providerType,
    this.appointmentId,
    this.description,
  });

  @override
  State<RateAnyProviderScreen> createState() => _RateAnyProviderScreenState();
}

class _RateAnyProviderScreenState extends State<RateAnyProviderScreen> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rate & Review',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProviderInfo(),
            const SizedBox(height: 32),
            _buildRatingSection(),
            const SizedBox(height: 32),
            _buildCommentSection(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getProviderTypeColor(
                widget.providerType,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getProviderTypeIcon(widget.providerType),
              size: 24,
              color: _getProviderTypeColor(widget.providerType),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.providerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getProviderTypeLabel(widget.providerType),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                if (widget.description != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How was your experience?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rate your overall experience with ${widget.providerName}',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starNumber = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = starNumber;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    starNumber <= _selectedRating
                        ? Icons.star
                        : Icons.star_border,
                    size: 40,
                    color: starNumber <= _selectedRating
                        ? Colors.amber[600]
                        : Colors.grey[400],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedRating > 0)
          Center(
            child: Text(
              _getRatingText(_selectedRating),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getRatingColor(_selectedRating),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share your experience',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Help others by sharing details about your experience',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _commentController,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Write your review here...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterStyle: TextStyle(color: Colors.grey[500]),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
        _buildQuickComments(),
      ],
    );
  }

  Widget _buildQuickComments() {
    final quickComments = _getQuickCommentsForProviderType(widget.providerType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick comments:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickComments.map((comment) {
            return GestureDetector(
              onTap: () {
                final currentText = _commentController.text;
                final newText = currentText.isEmpty
                    ? comment
                    : '$currentText. $comment';
                _commentController.text = newText;
                _commentController.selection = TextSelection.fromPosition(
                  TextPosition(offset: newText.length),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getProviderTypeColor(
                    widget.providerType,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getProviderTypeColor(
                      widget.providerType,
                    ).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  comment,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getProviderTypeColor(widget.providerType),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final canSubmit =
        _selectedRating > 0 && _commentController.text.trim().isNotEmpty;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSubmit && !_isSubmitting ? _submitReview : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Submit Review',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your review will help other patients make informed decisions',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<String> _getQuickCommentsForProviderType(ProviderType type) {
    switch (type) {
      case ProviderType.doctor:
        return [
          'Professional and caring',
          'Explained everything clearly',
          'Good communication',
          'Punctual and efficient',
          'Would recommend',
          'Knowledgeable',
        ];
      case ProviderType.hospital:
        return [
          'Clean facilities',
          'Professional staff',
          'Modern equipment',
          'Good organization',
          'Comfortable environment',
          'Efficient service',
        ];
      case ProviderType.pharmacy:
        return [
          'Wide selection of medications',
          'Helpful pharmacist',
          'Quick service',
          'Good prices',
          'Convenient location',
          'Home delivery available',
        ];
      case ProviderType.laboratory:
        return [
          'Quick results',
          'Accurate testing',
          'Professional technicians',
          'Clean facility',
          'Home sample collection',
          'Clear reports',
        ];
      case ProviderType.clinic:
        return [
          'Friendly staff',
          'Short waiting time',
          'Good facilities',
          'Affordable prices',
          'Convenient hours',
          'Professional service',
        ];
      case ProviderType.nutritionist:
        return [
          'Personalized meal plans',
          'Knowledgeable advice',
          'Practical recommendations',
          'Good follow-up',
          'Effective results',
          'Patient and understanding',
        ];
    }
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
      case 2:
        return Colors.red[600]!;
      case 3:
        return Colors.orange[600]!;
      case 4:
      case 5:
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Color _getProviderTypeColor(ProviderType type) {
    switch (type) {
      case ProviderType.doctor:
        return Colors.blue;
      case ProviderType.hospital:
        return Colors.red;
      case ProviderType.pharmacy:
        return Colors.green;
      case ProviderType.laboratory:
        return Colors.purple;
      case ProviderType.clinic:
        return Colors.orange;
      case ProviderType.nutritionist:
        return Colors.teal;
    }
  }

  String _getProviderTypeLabel(ProviderType type) {
    switch (type) {
      case ProviderType.doctor:
        return 'Doctor';
      case ProviderType.hospital:
        return 'Hospital';
      case ProviderType.pharmacy:
        return 'Pharmacy';
      case ProviderType.laboratory:
        return 'Laboratory';
      case ProviderType.clinic:
        return 'Clinic';
      case ProviderType.nutritionist:
        return 'Nutritionist';
    }
  }

  IconData _getProviderTypeIcon(ProviderType type) {
    switch (type) {
      case ProviderType.doctor:
        return Icons.medical_services;
      case ProviderType.hospital:
        return Icons.local_hospital;
      case ProviderType.pharmacy:
        return Icons.local_pharmacy;
      case ProviderType.laboratory:
        return Icons.science;
      case ProviderType.clinic:
        return Icons.healing;
      case ProviderType.nutritionist:
        return Icons.restaurant_menu;
    }
  }

  void _submitReview() async {
    if (_selectedRating == 0 || _commentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final review = Review(
        id: ReviewService.generateReviewId(),
        providerId: widget.providerId,
        patientId: UserService.currentUser?.email ?? 'current_user',
        patientName: UserService.currentUser?.name ?? 'Current User',
        rating: _selectedRating,
        comment: _commentController.text.trim(),
        createdAt: DateTime.now(),
        appointmentId: widget.appointmentId ?? 'direct_review',
        providerType: widget.providerType,
        providerName: widget.providerName,
      );

      ReviewService.addReview(review);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your review!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit review. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
