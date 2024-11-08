import 'package:asau_chat/components/custom_chat_bubble.dart';
import 'package:asau_chat/components/custom_textfield.dart';
import 'package:asau_chat/services/auth/auth_service.dart';
import 'package:asau_chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/message_model.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messagesController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final FocusNode focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        scrollDown();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _messagesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> scrollDown() async {
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage() async {
    if (_messagesController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messagesController.text);
      _messagesController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }

        // Map each document to a Message object
        final messages = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Message(
            senderID: data['senderID'],
            senderEmail: data['senderEmail'],
            receiverID: data['receiverID'],
            message: data['message'],
            timestamp: data['timestamp'],
          );
        }).toList();

        WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    final isCurrentUser = message.senderID == _authService.getCurrentUser()!.uid;

    // Format the timestamp
    final formattedTime = DateFormat('dd MMMM yyyy hh:mm a').format(message.timestamp.toDate());

    return Container(
      margin: EdgeInsets.only(
        left: isCurrentUser ? 50.0 : 0.0,
        right: isCurrentUser ? 0.0 : 50.0,
        top: 5.0,
        bottom: 5.0,
      ),
      child: Column(
        crossAxisAlignment:
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
            child: Text(
              message.senderEmail,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          CustomChatBubble(
            message: message.message,
            isCurrentUser: isCurrentUser,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
            child: Text(
              formattedTime,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              hintText: "Type a message",
              obscureText: false,
              controller: _messagesController,
              focusNode: focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 30),
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
