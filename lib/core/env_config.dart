import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const bool isWeb = bool.fromEnvironment('IS_WEB', defaultValue:  false);


  static Future<void> loadEnv () async {
    if(!isWeb) {
      String envFile = '.env.prod';
      try {
        await dotenv.load(fileName: envFile);
      } catch (e) {
        throw Exception('Failed to load environment file: $envFile. Make sure it exists');
      }
    }
  }

  static String get apiKey {
    return const String.fromEnvironment('API_KEY', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('API_KEY')
                    : dotenv.env['API_KEY'] ??  '';
  }

  static String get googleMapsApiKey {
    return const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('GOOGLE_MAPS_API_KEY')
        : dotenv.env['GOOGLE_MAPS_API_KEY'] ??  '';
  }

  static String get razorpayId {
    return const String.fromEnvironment('RAZORPAY_ID', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('RAZORPAY_ID')
        : dotenv.env['RAZORPAY_ID'] ??  '';
  }

  static String get razorpaySecret {
    return const String.fromEnvironment('RAZORPAY_SECRET', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('RAZORPAY_SECRET')
        : dotenv.env['RAZORPAY_SECRET'] ??  '';
  }


  static String get whatsappNumber {
    return const String.fromEnvironment('BUSINESS_WHATSAPP_NUMBER', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('BUSINESS_WHATSAPP_NUMBER')
        : dotenv.env['BUSINESS_WHATSAPP_NUMBER'] ??  '';
  }

  static String get whatsappAccessToken {
    return const String.fromEnvironment('WHATSAPP_ACCESS_TOKEN', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('WHATSAPP_ACCESS_TOKEN')
        : dotenv.env['WHATSAPP_ACCESS_TOKEN'] ??  '';
  }


  static String get googleGenerativeAIToken {
    return const String.fromEnvironment('GOOGLE_GENERATIVE_AI_TOKEN', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('GOOGLE_GENERATIVE_AI_TOKEN')
        : dotenv.env['GOOGLE_GENERATIVE_AI_TOKEN'] ??  '';
  }
  static String get youtubeAPI {
    return const String.fromEnvironment('YOUTUBE_API', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('YOUTUBE_API')
        : dotenv.env['YOUTUBE_API'] ??  '';
  }

  static String get companyMailUsername {
    return const String.fromEnvironment('WEBMAIL_USERNAME', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('WEBMAIL_USERNAME')
        : dotenv.env['WEBMAIL_USERNAME'] ??  '';
  }

  static String get companyMailPassword {
    return const String.fromEnvironment('WEBMAIL_SECURITY', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('WEBMAIL_SECURITY')
        : dotenv.env['WEBMAIL_SECURITY'] ??  '';
  }

  static String get groqApi {
    return const String.fromEnvironment('GROQ_API', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('GROQ_API')
        : dotenv.env['GROQ_API'] ??  '';
  }

  static String get supabaseApi {
    return const String.fromEnvironment('SUPABASE_API', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('SUPABASE_API')
        : dotenv.env['SUPABASE_API'] ??  '';
  }

  static String get supabaseFeedApi {
    return const String.fromEnvironment('SUPABASE_FEED_API', defaultValue:  '')
        .isNotEmpty ? const String.fromEnvironment('SUPABASE_FEED_API')
        : dotenv.env['SUPABASE_FEED_API'] ??  '';
  }
}