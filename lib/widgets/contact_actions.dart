import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/student.dart';
import '../config/localization.dart';
import '../services/contact_service.dart';

class ContactActions extends StatelessWidget {
  final String contact;
  final Student student;
  final String className;

  const ContactActions({
    super.key,
    required this.contact,
    required this.student,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1a237e),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.call,
                label: context.tr('call'),
                color: Colors.green,
                onTap: () => ContactService.makeCall(contact),
                onLongPress: () => _showContactMenu(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.message,
                label: context.tr('sms'),
                color: Colors.blue,
                onTap: () => ContactService.sendSms(
                  contact,
                  student.getSummary(className),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.chat,
                label: context.tr('whatsapp'),
                color: const Color(0xFF25D366),
                onTap: () => ContactService.sendWhatsApp(
                  contact,
                  student.getSummary(className),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return Material(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactMenu(BuildContext context) {
    HapticFeedback.mediumImpact();
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              contact,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.call, color: Colors.white),
              ),
              title: Text(context.tr('call')),
              onTap: () {
                Navigator.pop(context);
                ContactService.makeCall(contact);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.message, color: Colors.white),
              ),
              title: Text(context.tr('sms')),
              subtitle: Text('Send pre-filled message'),
              onTap: () {
                Navigator.pop(context);
                ContactService.sendSms(contact, student.getSummary(className));
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF25D366),
                child: Icon(Icons.chat, color: Colors.white),
              ),
              title: Text(context.tr('whatsapp')),
              subtitle: Text('Send via WhatsApp'),
              onTap: () {
                Navigator.pop(context);
                ContactService.sendWhatsApp(contact, student.getSummary(className));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
