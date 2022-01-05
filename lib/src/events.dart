import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class OnNewWebViewPopEvent {}

class ONewWebViewTitleChangeEvent {
  String title;
  ONewWebViewTitleChangeEvent(this.title);
}
