import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asau_chat/themes/theme_provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class CustomChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final TextStyle emojiStyle;  // Add emojiStyle as a parameter

  const CustomChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.emojiStyle,  // Pass emojiStyle when creating the widget
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final _utils = EmojiPickerUtils();
    // Define colors based on user role and theme mode
    final backgroundColor = isCurrentUser
        ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
        : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200);

    final textColor = isCurrentUser
        ? Colors.white
        : (isDarkMode ? Colors.white : Colors.black);

    // Apply emoji style to the message before displaying it
    final styledMessage = _utils.setEmojiTextStyle(message, emojiStyle: emojiStyle);

    return Row(
      mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.4, // Adjust width
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
          child: RichText(
            text: TextSpan(
              children: styledMessage,
              style: TextStyle(color: textColor),
            ),
            softWrap: true,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}
