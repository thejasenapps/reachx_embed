import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reachx_embed/core/env_config.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

class TranscriptGenerator {
  final String apiKey = EnvConfig.groqApi;
  final YoutubeExplode _youtubeExplode = YoutubeExplode();


  Future<File> getAudio(String videoId) async {
    try {

      final manifest = await _youtubeExplode.videos.streamsClient.getManifest(videoId);
      final audioStreamInfo = manifest.audioOnly.withHighestBitrate();

      final totalSize = audioStreamInfo.size.totalBytes;

      final dir = await getTemporaryDirectory();
      final filepath = '${dir.path}/youtube_audio.mp3';
      final file = File(filepath);

      if (await file.exists()) await file.delete();
      final output = file.openWrite();

      final audioStream = _youtubeExplode.videos.streamsClient.get(audioStreamInfo);

      debugPrint("Downloading audio...");
      int downloaded = 0;

      await for (final chunk in audioStream) {
        downloaded += chunk.length;
        output.add(chunk);

        double progress = downloaded / totalSize * 100;
        debugPrint("Download progress: ${progress.toStringAsFixed(2)}%");
      }

      await output.close();
      debugPrint("Completed saving file: $filepath");

      return file;

    } catch(e) {
      debugPrint("Unknown error: $e");
      throw Exception("Failed to download audio");
    }
  }

  Future<List<Map<String, dynamic>>> transcribeAssetMp3(String videoId) async {
    try {

      final File file = await getAudio(videoId);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.groq.com/openai/v1/audio/transcriptions'),
      );

      request.headers['Authorization'] = 'Bearer $apiKey';
      request.fields['model'] = 'whisper-large-v3';
      request.fields['response_format'] = 'verbose_json';

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: 'audio.mp3',
      ));

      // 5. Send request
      final response = await request.send();
      final jsonText = await response.stream.bytesToString();

      if (response.statusCode == 200) {

        final data = json.decode(jsonText);

        List<Map<String, dynamic>> segments = [];

        for(var segment in data["segments"]) {
          segments.add({
            "start": segment["start"],
            "end": segment["end"],
            "text": segment["text"]
          });
        }

        return segments;
      } else {
        throw Exception('Groq API error');
      }
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }


  Future<String> fetchTranscriptFromSupadata(String videoId) async {
    try {
      final Map<String, dynamic> data = {
        "video_url": "https://www.youtube.com/watch?v=$videoId"
      };
      
      final response = await http.post(
        Uri.parse("https://youtubetranscripter-production.up.railway.app/transcript/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(data)
      );


      if(response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded["transcript"];
      }

      debugPrint("API error ${response.statusCode}: ${response.body}");
      return "";
      
    } catch (e) {
      debugPrint("Unknown error: $e");
      return '';
    }
  }
}
