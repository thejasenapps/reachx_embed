import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';

class PassionAIGenerator {
  Future<Results> getAnswer(List<String> answers, bool isTitle) async {

    try {

      final titleSchema = Schema.object(
        properties: {
          'passion_title': Schema.string(
            description: "A concise, professional career title with high financial potential.",
          ),
        },
      );

      final descriptionSchema = Schema.object(
          properties: {
            'passion_description': Schema.string(
              description: "A detailed description in first-person ('I' statements) explaining the passion.",
            ),
            'suitability_analysis': Schema.string(
              description: "A brief sentence explaining why this fits the user's answers."
            )
          },
        propertyOrdering: ['passion_description', 'suitability_analysis']
      );



      final model = FirebaseAI.googleAI().generativeModel(
          model: 'gemini-2.0-flash-001',
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            responseSchema: isTitle ? titleSchema : descriptionSchema
          )
      );
      
      final String userContext = answers.join("\n");
      final content = [Content.text("Analyze these answers and generate the passion data:\n$userContext")];
      
      // String? prompts;
      //
      // for(String value in answers) {
      //   if(prompts != null) {
      //     prompts = "$prompts\n$value";
      //   } else {
      //     prompts = value;
      //   }
      // }
      //
      // if(isTitle) {
      //
      //   String rules = "1. Summarise th content and find the passion title that is close to the prompts given and make it a simple one."
      //       "2. Generate only the passion title and nothing else"
      //       "3. Passion title should be one that is common in real life profession and the passion should have financial benefits"
      //       "4. Keep it short and as general as possible"
      //       "5. Eliminate any explanation or unwanted third party references";
      //
      //   prompts = "$prompts\n\nGenerate a unique passion title for this person using the above answers with following rules: $rules";
      //
      // } else {
      //
      //   String rules = "1. Summarise the content and find the passion description that is close to the prompts given"
      //       "2.Generate only the passion description and why its suitable for me and nothing else"
      //       "3. Make it first person speech"
      //       "4. Eliminate any explanation or unwanted third party references";
      //
      //   prompts = "$prompts\n\nGenerate the passion description for this person using the above answers with following rules: $rules";
      // }
      //
      // final content = [Content.text(prompts)];

      final response = await model.generateContent(content);

      final String? rawJson = response.text;

      if(rawJson != null) {
        try {
          final Map<String, dynamic> data = jsonDecode(rawJson);

          return Results.success(data);
        } catch (e) {
          return Results.error("The AI returned invalid JSON format");
        }
      }

      return Results.error("No response from AI");

    } catch (e) {
      print(e);
      return Results.error("Failed to generate");
    }
  }

}