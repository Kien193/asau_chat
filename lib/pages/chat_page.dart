import 'package:asau_chat/components/custom_chat_bubble.dart';
import 'package:asau_chat/components/custom_textfield.dart';
import 'package:asau_chat/services/auth/auth_service.dart';
import 'package:asau_chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../models/message_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _messagesController = TextEditingController();
  late final ChatService _chatService = ChatService();
  late final AuthService _authService = AuthService();
  late final FocusNode focusNode = FocusNode();
  late final ScrollController _scrollController = ScrollController();

  bool _emojiShowing = false;
  String? senderID;

  @override
  void initState() {
    super.initState();
    senderID = _authService.getCurrentUser()?.uid;
    focusNode.addListener(() {
      if (focusNode.hasFocus) scrollDown();
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
      _scrollController.position.maxScrollExtent * 1.5,
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
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
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverID, senderID ?? ''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }

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
          itemBuilder: (context, index) => _buildMessageItem(messages[index]),
        );
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    final isCurrentUser = message.senderID == senderID;
    final textStyle = DefaultEmojiTextStyle.copyWith(
      fontFamily: GoogleFonts.beVietnamPro().fontFamily,
    );
    final formattedTime = DateFormat('dd MMM yyyy hh:mm a').format(message.timestamp.toDate());

    return Container(
      margin: EdgeInsets.only(
        left: isCurrentUser ? 50.0 : 0.0,
        right: isCurrentUser ? 0.0 : 50.0,
        top: 5.0,
        bottom: 5.0,
      ),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
            emojiStyle: textStyle,
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
    final screenSize = MediaQuery.of(context).size;
    final textStyle = DefaultEmojiTextStyle.copyWith(
      fontFamily: GoogleFonts.beVietnamPro().fontFamily,
    );
    final emojiSize = 28 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.3 : 1.0);
    final numEmojiColumns = (screenSize.width / (emojiSize + 18)).floor();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              _buildIconButton(Icons.image, () {}),
              _buildIconButton(
                _emojiShowing ? Icons.keyboard : Icons.emoji_emotions_outlined,
                    () {
                  setState(() {
                    _emojiShowing = !_emojiShowing;
                    if (_emojiShowing) focusNode.unfocus();
                  });
                },
              ),
              Expanded(
                child: CustomTextField(
                  hintText: "Type a message",
                  obscureText: false,
                  controller: _messagesController,
                  focusNode: focusNode,
                ),
              ),
              _buildIconButton(Icons.send, sendMessage),
            ],
          ),
        ),
        if (_emojiShowing)
          SizedBox(
            height: 256,
            child: EmojiPicker(
              textEditingController: _messagesController,
              config: Config(
                emojiTextStyle: textStyle,
                emojiViewConfig: EmojiViewConfig(
                  columns: numEmojiColumns,
                  emojiSizeMax: emojiSize,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  noRecents: const Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  loadingIndicator: const SizedBox.shrink(),
                ),
                categoryViewConfig: CategoryViewConfig(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  tabIndicatorAnimDuration: const Duration(milliseconds: 500),
                ),
                searchViewConfig: SearchViewConfig(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  buttonIconColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
