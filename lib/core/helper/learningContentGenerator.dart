import 'package:firebase_ai/firebase_ai.dart';

class LearningContentGenerator {
  Future<String> getAnswers(String passionDescription, String contentType) async {

    try {
      final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash-001');

      String? prompts;
      prompts = passionDescription;


      if(contentType == "monthly") {

        String rules = "1. List out a full monthly road map to learn the given passion"
            "2. The contents should be a 30 day learning themed content that can be learned from seeing a video"
            "3. There shouldn't be no extra symbols, bold titles or anything"
            "4. Just only give plain simple 30 day roadmap with no titles and only one space in between each paragraph"
            "5. No other explanation or comments needed";

        prompts = "$prompts\n\nGenerate a full month roadmap for this person using the above description with following rules: $rules";

      } else if(contentType == "title") {
        String rules = "1. Create a simple and short title"
            "2. There should be only title and no other explanation needed";

        prompts = "$prompts\n\nGenerate a title for a learningContent from the above description using following rules: $rules";
      } else if(contentType == "description"){
        String rules = "1.The description should be short and well below 20 words."
            "2. It should be in reported speech";

        prompts = "$prompts\n\nGenerate a short description for the above title wth the following rules: $rules";
      } else if(contentType == "timestop"){
        String rules = "1.Find three stops where important quizzes can be asked from the given video."
            "2. Give only those values in seconds separated by commas"
            "3. No other explanation is needed";

        prompts = "$prompts\n\nFind three intervals from the videoId wth the following rules: $rules";
      }  else if(contentType == "questions"){
        String rules = "1.Three questions that can be asked from the given transcript just after a particular topic is discussed"
            "2.Output exactly one line per question group — no extra text or lines"
            "3. Fields must appear in this order, separated by a single space, a hyphen, then a single space:'TIMESTAMP - QUESTION - OPTIONS - ANSWER' "
            "4. TIMESTAMP must use a single integer number of seconds (e.g.330) and use only seconds format"
            "5. QUESTION: the full question text (no hyphen character -)."
            "6. OPTIONS: exactly three options separated by underscores _. Example: Apple_Banana_Cherry or To learn_To earn_To share"
            "7. Do not include punctuation or explanations outside the structured line. No headings, no numbering, no commentary."
            "8. Language: use the same language as the transcript. Preserve original capitalization and punctuation inside the question only (except hyphens are forbidden inside the question text)"
            "9. If the transcript does not contain enough content to make three meaningful questions in the interval, produce as many valid lines as possible (but still follow the format)"
            "10.Return exactly three lines total (one per question) when possible; otherwise return 1 or 2 lines if not enough content."
            "11. The answer should be a single option";

        prompts = "$prompts\n\nGenerate question, multiple options and correct answer for the given videoId and for the given time interval using the following rules: $rules";
      } else if(contentType == "test"){
        String rules = "1.All the words should be in a single paragraph"
            "2. No other explanation  or text is needed";

        prompts = "$prompts\n\nSummarise the content for the given video using the following rules: $rules";
      }

      final content = [Content.text(prompts)];

      final response = await model.generateContent(content);

      print(response.text);

      return response.text ?? '';

    } catch (e) {
      print(e);
      return '';
    }
  }

}