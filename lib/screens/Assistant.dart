import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';
import 'package:medi_scan_mobile/colors.dart';

class Assistant extends StatefulWidget {
  const Assistant({super.key});

  @override
  State<Assistant> createState() => _AssistantState();
}

class _AssistantState extends State<Assistant> with AutomaticKeepAliveClientMixin {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  bool get wantKeepAlive => true;

  String _getPhilippineTime() {
    final utc = DateTime.now().toUtc();
    final ph = utc.add(Duration(hours: 8));
    return '${ph.hour.toString().padLeft(2, '0')}:${ph.minute.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _messages.add({
      'text': "Hello! I'm your MediScan AI Assistant. I can help you with patient records, medical queries, and administrative tasks. How can I assist you today?",
      'isUser': false,
      'time': _getPhilippineTime(),
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': message, 'isUser': true, 'time': _getPhilippineTime()});
    });
    _messageController.clear();
    _scrollToBottom();
    
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _messages.add({'text': _getAIResponse(message), 'isUser': false, 'time': _getPhilippineTime()});
      });
      _scrollToBottom();
    });
  }

  String _getAIResponse(String userMessage) {
    if (userMessage.toLowerCase().contains('diabetes')) {
      return "Here are the patients with diabetes:\n\n• Maria Santos - Type 2 Diabetes\n• Juan Dela Cruz - Type 1 Diabetes\n• Ana Garcia - Gestational Diabetes\n\nWould you like more details about any of these patients?";
    } else if (userMessage.toLowerCase().contains('emergency')) {
      return "Recent emergency visits:\n\n• John Smith - Chest pain (2 hours ago)\n• Lisa Johnson - Severe allergic reaction (4 hours ago)\n• Mike Brown - Fracture (6 hours ago)\n\nAll patients are stable and receiving appropriate care.";
    }
    return "I understand your query. Let me help you with that medical information. Could you please provide more specific details so I can assist you better?";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: reusableAppBar("Assistant", LucideIcons.bot),
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Description for AI Medical Assistant
          SizedBox(height: 8),
          Text("AI Medical Assistant", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("Chat with our AI assistant for medical record queries and administrative help", 
               textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          
          // Chat Section
          Expanded(
            child: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  // Chat Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.message_circle, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text("Chat Assistant", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  
                  // Description below chat assistant section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Text("Ask questions about patients, appointments, or medical records", 
                               style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                  ),
                  
                  // Messages
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(15),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: message['isUser'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  if (!message['isUser']) ...[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                                      child: Icon(LucideIcons.bot, color: Colors.white, size: 14),
                                    ),
                                    SizedBox(width: 6),
                                  ],
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: message['isUser'] ? AppColors.primary : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(message['text'], style: TextStyle(color: message['isUser'] ? Colors.white : Colors.black, fontSize: 15)),
                                          SizedBox(height: 2),
                                          Text(message['time'], style: TextStyle(color: message['isUser'] ? Colors.white70 : Colors.grey.shade600, fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (message['isUser']) ...[
                                    SizedBox(width: 6),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(16)),
                                      child: Icon(LucideIcons.user, color: Colors.grey.shade600, size: 20),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Quick action buttons - only show for first message
                            if (index == 0 && _messages.length == 1)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () => _sendMessage("List all patients with diabetes"),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Text("List all patients with diabetes", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () => _sendMessage("Show recent emergency visits"),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Text("Show recent emergency visits", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  
                  // Input Section 
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: "Ask about patients, appointments, or medical records...",
                                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                border: InputBorder.none,
                                prefixIcon: Icon(LucideIcons.search, color: Colors.grey.shade400, size: 16),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              ),
                              style: TextStyle(fontSize: 12),
                              onSubmitted: _sendMessage,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _sendMessage(_messageController.text),
                            child: Container(
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
                              child: Icon(LucideIcons.send, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}