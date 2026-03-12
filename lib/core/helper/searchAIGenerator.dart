import 'dart:async';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:reachx_embed/core/global_variables.dart';

class SearchGenAIGenerator {
  final StreamController<String> _controller = StreamController<String>.broadcast();

  Stream<String> get responseStream => _controller.stream;

  String _buffer = '';

  Future<void> getText(String searchKey, bool passionateFound) async {
    _buffer = '';
    _controller.add("");

    try {
      final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash-001');


      String? prompts;

      if(passionateFound) {
        prompts = "Theme: Generate without any self acclamation"
            "behaviour: address the query and act as an advocate for the passionate that related to the query and boast about what the importance of seeking help. "
            "Do not recommend other sites."
            "In the end in the next line without any spaces in between lines, add: 'Here are the right minds for your needs:' "
            "The generated sentence except the one given below should be inside double quotes"
            "Total word count should be less than 15 words"
            "Word count is compulsory"
            "query: $searchKey";
      } else {
        if(isExpert.value) {
          prompts = "Theme: Generate without any self acclamation"
              "behaviour: address the query just enough to give them a useful and unique fact about the query. "
              "Start with: Oops, You requested growth coach is not available at this moment. But did you know:"
              "Do not recommend other sites."
              "Add one space between each sentence"
              "The generated sentence except the one given should be inside double quotes"
              "In th end in the next line, add: 'The right person will get back to you soon. Meanwhile, don't stop growing your passion'"
              "query: $searchKey";
        } else {
          prompts = "Theme: Generate without any self acclamation"
              "behaviour: address the query just enough to give them a useful and unique fact about the query. "
              "Start with: Oops, You requested growth coach is not available at this moment. But did you know:"
              "Do not recommend other sites."
              "Add one space between each sentence"
              "The generated sentence except the one given should be inside double quotes"
              "In th end in the next line, add: 'The right person will get back to you soon. Meanwhile, don't stop growing your passion'"
              "query: $searchKey";
        }
      }

      final content = [Content.text(prompts)];
      final response = model.generateContentStream(content);

      await for (final chunk in response) {
        final text = chunk.text ?? '';
        for(int i = 0; i < text.length; i++) {
          await Future.delayed(const Duration(milliseconds: 30));
          _buffer += text[i];
          _controller.add(_buffer);
        }
      }
    } catch(e){
      print("Error is $e");
      _controller.add("Here are the ideal passionates for you");
    }
  }

  void dispose() {
    _controller.close();
  }
}
