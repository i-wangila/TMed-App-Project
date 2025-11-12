import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/appointment_service.dart';
import '../services/review_service.dart';
import '../services/call_service.dart';
import '../models/appointment.dart';
import '../models/message.dart';
import 'reschedule_appointment_screen.dart';
import 'rate_provider_screen.dart';
import 'call_screen.dart';
import 'chat_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'My Appointments',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _buildTabButton('Upcoming', 0)),
                        Expanded(child: _buildTabButton('Completed', 1)),
                        Expanded(child: _buildTabButton('Cancelled', 2)),
                      ],
                    ),
                  ),
                  Expanded(child: _buildTabContent()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.grey[800]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    List<Appointment> appointments;
    String emptyMessage;
    IconData emptyIcon;

    switch (_selectedTabIndex) {
      case 0:
        appointments = AppointmentService.getUpcomingAppointments();
        emptyMessage = 'No upcoming appointments';
        emptyIcon = Icons.calendar_today;
        break;
      case 1:
        appointments = AppointmentService.getCompletedAppointments();
        emptyMessage = 'No completed appointments';
        emptyIcon = Icons.check_circle_outline;
        break;
      case 2:
        appointments = AppointmentService.getCancelledAppointments();
        emptyMessage = 'No cancelled appointments';
        emptyIcon = Icons.cancel_outlined;
        break;
      default:
        appointments = [];
        emptyMessage = 'No appointments';
        emptyIcon = Icons.calendar_today;
    }

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(appointment),
        );
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
    final communicationType = _getCommunicationTypeText(
      appointment.communicationType,
    );

    return Material(
      color: Colors.transparent,
      child: AbsorbPointer(
        absorbing: false, // Allow button interactions
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AbsorbPointer(
                    child: Text(
                      appointment.providerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#${appointment.id}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(appointment.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(appointment.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Description', appointment.description),
              const SizedBox(height: 8),
              _buildInfoRow('Communication Type', communicationType),
              const SizedBox(height: 8),
              _buildInfoRow(
                'Date & Time',
                dateFormat.format(appointment.dateTime),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                'Total Payment',
                'KES ${appointment.amount.toStringAsFixed(2)} (Paid)',
              ),
              const SizedBox(height: 16),
              _buildActionButtons(appointment),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Appointment appointment) {
    // Check if appointment is completed and not yet rated
    final isCompleted = appointment.status == AppointmentStatus.completed;
    final hasReview = ReviewService.hasUserReviewedAppointment(appointment.id);
    final isScheduled = appointment.status == AppointmentStatus.scheduled;

    if (isCompleted && !hasReview) {
      // Show rate provider button for completed unrated appointments
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleSecondaryAction(appointment),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _getSecondaryButtonText(appointment.status),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _rateProvider(appointment),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: 18),
                  SizedBox(width: 4),
                  Text('Rate Provider'),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (isCompleted && hasReview) {
      // Show rated status for completed rated appointments
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'Review submitted',
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else if (isScheduled) {
      // Three buttons for scheduled appointments: Voice Call/Video Call, Reschedule, Cancel
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handlePrimaryAction(appointment),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _getPrimaryButtonText(appointment),
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleSecondaryAction(appointment),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Reschedule',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _cancelAppointment(appointment),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ],
      );
    } else {
      // Default buttons for other statuses
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleSecondaryAction(appointment),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _getSecondaryButtonText(appointment.status),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handlePrimaryAction(appointment),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              child: Text(_getPrimaryButtonText(appointment)),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return AbsorbPointer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.inProgress:
        return Colors.orange;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.missed:
        return Colors.grey;
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'SCHEDULED';
      case AppointmentStatus.inProgress:
        return 'IN PROGRESS';
      case AppointmentStatus.completed:
        return 'COMPLETED';
      case AppointmentStatus.cancelled:
        return 'CANCELLED';
      case AppointmentStatus.missed:
        return 'MISSED';
    }
  }

  String _getCommunicationTypeText(CommunicationType type) {
    switch (type) {
      case CommunicationType.video:
        return 'VIDEO CALL';
      case CommunicationType.voice:
        return 'VOICE CALL';
      case CommunicationType.chat:
        return 'CHAT';
      case CommunicationType.inPerson:
        return 'IN-PERSON';
    }
  }

  String _getPrimaryButtonText(Appointment appointment) {
    switch (appointment.communicationType) {
      case CommunicationType.video:
        return 'Video Call';
      case CommunicationType.voice:
        return 'Voice Call';
      case CommunicationType.chat:
        return 'Start Chat';
      case CommunicationType.inPerson:
        return 'View Details';
    }
  }

  String _getSecondaryButtonText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Reschedule';
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
      case AppointmentStatus.missed:
        return 'Book Again';
      case AppointmentStatus.inProgress:
        return 'View Details';
    }
  }

  void _handlePrimaryAction(Appointment appointment) async {
    switch (appointment.communicationType) {
      case CommunicationType.video:
        await _startVideoCall(appointment);
        break;
      case CommunicationType.voice:
        await _startVoiceCall(appointment);
        break;
      case CommunicationType.chat:
        _startChat(appointment);
        break;
      case CommunicationType.inPerson:
        _showAppointmentDetails(appointment);
        break;
    }
  }

  Future<void> _startVideoCall(Appointment appointment) async {
    try {
      final callSession = await CallService.startCall(
        providerId: appointment.providerId,
        providerName: appointment.providerName,
        callType: CallType.video,
        patientId: appointment.patientId,
        patientName: appointment.patientName,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(callSession: callSession),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start video call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startVoiceCall(Appointment appointment) async {
    try {
      final callSession = await CallService.startCall(
        providerId: appointment.providerId,
        providerName: appointment.providerName,
        callType: CallType.voice,
        patientId: appointment.patientId,
        patientName: appointment.patientName,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(callSession: callSession),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start voice call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startChat(Appointment appointment) {
    // Create a message object for the chat
    final message = Message(
      id: 'chat_${appointment.id}',
      senderId: appointment.providerId,
      senderName: appointment.providerName,
      content: 'Hello! I\'m ready for our chat consultation.',
      timestamp: DateTime.now(),
      isRead: true,
      type: MessageType.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(message: message)),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provider: ${appointment.providerName}'),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy at hh:mm a').format(appointment.dateTime)}',
            ),
            const SizedBox(height: 8),
            Text('Type: In-Person Consultation'),
            const SizedBox(height: 8),
            Text('Description: ${appointment.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleSecondaryAction(Appointment appointment) {
    if (appointment.status == AppointmentStatus.scheduled) {
      _showRescheduleDialog(appointment);
    } else {
      _showBookAgainDialog(appointment);
    }
  }

  void _showRescheduleDialog(Appointment appointment) async {
    final navigator = Navigator.of(context);

    final result = await navigator.push(
      MaterialPageRoute(
        builder: (context) => RescheduleAppointmentScreen(
          appointment: appointment,
          isBookingAgain: false,
        ),
      ),
    );

    // If rescheduling was successful, refresh the appointments list
    if (result == true && mounted) {
      setState(() {
        // This will trigger a rebuild and refresh the appointments
      });
    }
  }

  void _rateProvider(Appointment appointment) async {
    final navigator = Navigator.of(context);

    final result = await navigator.push(
      MaterialPageRoute(
        builder: (context) => RateProviderScreen(appointment: appointment),
      ),
    );

    // If rating was successful, refresh the appointments list
    if (result == true && mounted) {
      setState(() {
        // This will trigger a rebuild and refresh the appointments
      });
    }
  }

  void _showBookAgainDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Again'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Would you like to book another appointment with ${appointment.providerName}?',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previous Appointment:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getCommunicationTypeText(appointment.communicationType),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              navigator.pop();

              // Navigate to reschedule screen for booking a new appointment
              final result = await navigator.push(
                MaterialPageRoute(
                  builder: (context) => RescheduleAppointmentScreen(
                    appointment: appointment,
                    isBookingAgain: true,
                  ),
                ),
              );

              // If booking was successful, refresh the appointments list
              if (result == true && mounted) {
                setState(() {
                  // This will trigger a rebuild and refresh the appointments
                });

                // Show success message using captured ScaffoldMessenger
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'New appointment booked with ${appointment.providerName}!',
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Book New Appointment'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel your appointment with ${appointment.providerName}?',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointment Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red[800],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'MMM dd, yyyy at hh:mm a',
                    ).format(appointment.dateTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Note: Cancellation fees may apply depending on the timing.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Appointment'),
          ),
          ElevatedButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);

              // Cancel the appointment
              final success = await AppointmentService.cancelAppointment(
                appointment.id,
              );

              if (success && mounted) {
                setState(() {
                  // This will trigger a rebuild and refresh the appointments
                });

                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Appointment with ${appointment.providerName} has been cancelled',
                    ),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 3),
                  ),
                );
              } else if (mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Failed to cancel appointment. Please try again.',
                    ),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Appointment'),
          ),
        ],
      ),
    );
  }
}
