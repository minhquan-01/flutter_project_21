import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  ChatMessage({required this.text, required this.isMe});
}

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Chào bạn! Honda Showroom có thể giúp gì cho bạn hôm nay?", isMe: false),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _faqs = [
    {"q": "Bảo hành xe mới?", "a": "Tất cả xe máy Honda mới đều được bảo hành chính hãng 3 năm hoặc 30.000km tùy điều kiện nào đến trước."},
    {"q": "Mua xe trả góp?", "a": "Chúng tôi hỗ trợ trả góp qua thẻ tín dụng và các công ty tài chính với lãi suất cực kỳ hấp dẫn chỉ từ 0%."},
    {"q": "Lái thử xe?", "a": "Bạn có thể để lại số điện thoại tại đây hoặc gọi Hotline 1800-123-456 để đặt lịch lái thử nhé!"},
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isMe: true));
    });
    _scrollToBottom();

    // Giả lập phản hồi
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(text: "Cảm ơn bạn đã quan tâm! Tư vấn viên của chúng tôi sẽ phản hồi bạn trong giây lát.", isMe: false));
        });
        _scrollToBottom();
      }
    });
  }

  void _handleFAQ(String question, String answer) {
    setState(() {
      _messages.add(ChatMessage(text: question, isMe: true));
      _messages.add(ChatMessage(text: answer, isMe: false));
    });
    _scrollToBottom();
  }

  void _showChatDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: 400,
              height: 550,
              child: Column(
                children: [
                  // Header
                  Container(
                    color: const Color(0xFFCC0000),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        const Icon(Icons.support_agent, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        const Text("CSKH Trực tuyến", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.white))
                      ],
                    ),
                  ),
                  
                  // Message List
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade100,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(15),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          return Align(
                            alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: msg.isMe ? const Color(0xFFCC0000) : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15),
                                  topRight: const Radius.circular(15),
                                  bottomLeft: msg.isMe ? const Radius.circular(15) : Radius.zero,
                                  bottomRight: msg.isMe ? Radius.zero : const Radius.circular(15),
                                ),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                              ),
                              child: Text(msg.text, style: TextStyle(color: msg.isMe ? Colors.white : Colors.black87, fontSize: 14)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // FAQ Chips
                  Container(
                    color: Colors.grey.shade100,
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: _faqs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ActionChip(
                            label: Text(_faqs[index]["q"]!, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                            onPressed: () {
                              _handleFAQ(_faqs[index]["q"]!, _faqs[index]["a"]!);
                              setDialogState(() {}); // Cập nhật UI bên trong Dialog
                            },
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade300)),
                          ),
                        );
                      },
                    ),
                  ),

                  // Input
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: (val) {
                              _handleSend(val);
                              setDialogState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: "Nhập tin nhắn...",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: const Color(0xFFCC0000),
                          radius: 22,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white, size: 18),
                            onPressed: () {
                              _handleSend(_textController.text);
                              setDialogState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _showChatDialog,
      backgroundColor: const Color(0xFFCC0000),
      icon: const Icon(Icons.support_agent, color: Colors.white),
      label: const Text("Chat với CSKH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
