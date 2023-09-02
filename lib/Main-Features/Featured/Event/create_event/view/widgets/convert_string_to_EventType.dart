import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/event_types.dart';

EventType eventTypeFromString(String eventTypeString) {
  switch (eventTypeString) {
    case 'InternalClubEvent':
      return EventType.InternalClubEvent;
    case 'Party':
      return EventType.Party;
    case 'InternalTeamEvent':
      return EventType.InternalTeamEvent;
    case 'FriendlyMatch':
      return EventType.FriendlyMatch;
    case 'DailyTraining':
      return EventType.DailyTraining;
    case 'PartyEvent':
      return EventType.PartyEvent;
    case 'Training':
      return EventType.Training;
    default:
      throw ArgumentError('Invalid event type string: $eventTypeString');
  }
}
