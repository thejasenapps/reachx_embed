import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';

class MailingClass {
  String smtpHost = 'reachx.pro';
  int smtpPort = 465;

  static const username = String.fromEnvironment("WEBMAIL_USERNAME");
  static const password = String.fromEnvironment("WEBMAIL_SECURITY");


  Future<Results> sendMail(String mail, String name) async {
    final smtpServer = SmtpServer(
        smtpHost,
        port: smtpPort,
        ssl: true,
        username: username,
        password: password
    );

    final message = Message()
      ..from = Address(username, 'ReachX')
      ..recipients.add(mail)
      ..subject = 'Invitation from $name'
      ..text = '''
          Hi there,
          
          $name is growing their passion with ReachX. Join us and be part of a community where we share, support, and grow together.
          
          Click the link below to download the app and join now:
          https://reachx.pro/download-app.html
          
          Best regards,  
          The ReachX Team
          ''';


    try {
      final sendReport = await send(message, smtpServer);
      debugPrint("Message send: $sendReport");
      return Results.success(sendReport.toString());
    } on MailerException catch(e) {
      debugPrint('Message not sent');
      for(var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
      return Results.error("Mail not sent");
    } catch(e){
      debugPrint(e.toString());
      return Results.error('Unknown error');
    }
  }


  Future<Results> sendSignUpMail(String mail, String name) async {
    final smtpServer = SmtpServer(
        smtpHost,
        port: smtpPort,
        ssl: true,
        username: username,
        password: password
    );

    final message = Message()
      ..from = Address(username, 'ReachX')
      ..recipients.add(mail)
      ..subject = 'Invitation from $name'
      ..text = '''
          Hi there,
          
          $name is growing their passion with ReachX. Join us and be part of a community where we share, support, and grow together.
          
          Click the link below to download the app and join now:
          https://reachx.pro/download-app.html
          
          Best regards,  
          The ReachX Team
          ''';


    try {
      final sendReport = await send(message, smtpServer);
      debugPrint("Message send: $sendReport");
      return Results.success(sendReport.toString());
    } on MailerException catch(e) {
      debugPrint('Message not sent');
      for(var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
      return Results.error("Mail not sent");
    } catch(e){
      debugPrint(e.toString());
      return Results.error('Unknown error');
    }
  }
}