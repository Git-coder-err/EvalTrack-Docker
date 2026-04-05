import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import '../components/app_layout.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Admin Messages',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          Container(
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.g100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                // Contacts List
                _buildContactsList(),
                const VerticalDivider(width: 1, color: AppColors.g100),
                // Chat Area
                Expanded(child: _buildChatArea()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Program Head Comms',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.g900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Direct secure communication channel with the Dean and Administrators',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.g500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildContactsList() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTACTS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppColors.g400,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactItem('Dean\'s Office', 'Active Now', true),
          const SizedBox(height: 12),
          _buildContactItem('Academic Admin', 'Away', false),
        ],
      ),
    );
  }

  Widget _buildContactItem(String name, String status, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.p50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isActive ? AppColors.p600 : AppColors.g200,
            child: Text(
              name[0],
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.g500,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.g900,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive ? Colors.green : AppColors.g400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Column(
      children: [
        // Chat Header
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              const Icon(FontAwesomeIcons.comments,
                  size: 16, color: AppColors.p600),
              const SizedBox(width: 12),
              Text(
                'Direct Message',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              const Icon(FontAwesomeIcons.shieldHalved,
                  size: 12, color: Colors.green),
              const SizedBox(width: 6),
              const Text(
                'End-to-End Encrypted',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.g100),
        // Messages
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildMessageBubble(
                  'Dean\'s Office',
                  'Hello Program Head! Just checking in on the BSIT 1st Year enrollment status. Are we on track for the target?',
                  '10:30 AM',
                  false),
              _buildMessageBubble('You',
                  'Yes Dean, we are currently at 85% capacity for the major subjects.', '10:32 AM', true),
            ],
          ),
        ),
        // Input
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    filled: true,
                    fillColor: AppColors.g50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.p600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(FontAwesomeIcons.paperPlane,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(
      String sender, String text, String time, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                sender,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.g400,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(fontSize: 10, color: AppColors.g300),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: isMe ? AppColors.p600 : AppColors.g50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.g900,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
