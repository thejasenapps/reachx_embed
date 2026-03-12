
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

Future<Contact?> fetchContacts() async {
  try {
    if( await FlutterContacts.requestPermission()) {
      return await FlutterContacts.openExternalPick();
    } else {
      return null;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}
