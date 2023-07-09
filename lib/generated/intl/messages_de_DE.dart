// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de_DE locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de_DE';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "getStarted": MessageLookupByLibrary.simpleMessage("Loslegen"),
        "next": MessageLookupByLibrary.simpleMessage("weiter"),
        "onboarding_detail1": MessageLookupByLibrary.simpleMessage(
            "Jedes Clubmitglied kann ein individuelles\n Profil erstellen und Informationen zu \nihrenStärken und Spieltypen \nangeben."),
        "onboarding_detail2": MessageLookupByLibrary.simpleMessage(
            "Mit dieser Funktion können Clubmitglieder\n Tennisplätze reservieren. Sie können \nfreie Zeiten anzeigen und Buchungen\neinfach vornehmen."),
        "onboarding_detail3": MessageLookupByLibrary.simpleMessage(
            "Hier finden Sie Spieler, die zu einer \nbestimmten Zeit spielen möchten oder\n ein ähnliches Spielniveau \nwie Sie haben."),
        "onboarding_detail4": MessageLookupByLibrary.simpleMessage(
            "Sie erhalten Informationen zu\nbevorstehenden Turnieren,\nVeranstaltungen, Spielaktualisierungen\noder wichtigen Clubankündigungen."),
        "onboarding_header1":
            MessageLookupByLibrary.simpleMessage("Erstelle dein Profil"),
        "onboarding_header2":
            MessageLookupByLibrary.simpleMessage("Platzreservierung"),
        "onboarding_header3":
            MessageLookupByLibrary.simpleMessage("Matchmaking"),
        "onboarding_header4":
            MessageLookupByLibrary.simpleMessage("Benachrichtigungen"),
        "skip": MessageLookupByLibrary.simpleMessage("Überspringen")
      };
}
