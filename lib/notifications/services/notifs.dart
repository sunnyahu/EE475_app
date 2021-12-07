import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pill_pal/blue/data/packets.dart';
import 'package:pill_pal/db/database.dart';
import 'package:pill_pal/med/data/medication.dart';

// Starts the notification service
void initNotifications() {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'reminder_channel',
            channelName: 'Reminder Notifications',
            channelGroupKey: 'reminders',
            channelDescription: 'Notification channel for basic tests'),
        NotificationChannel(
            channelKey: 'leave_channel',
            channelName: 'Left behind channel',
            channelDescription: 'channel for left behind notifications'),
        NotificationChannel(
            channelKey: 'action_channel',
            channelName: 'Action Notifications',
            channelDescription:
                'Channel for when user is supposed to push button')
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupName: 'Reminders',
          channelGroupkey: 'reminders',
        ),
      ],
      debug: true);

  handleNotifTaps();
}

// Handles logic on what to do when user taps on notifications
void handleNotifTaps() {
  AwesomeNotifications().actionStream.listen((ReceivedAction event) async {
    // TODO: Switch on event.buttonKeyPressed
    print(event.buttonKeyPressed);
    print(event.toMap().toString());
  });
}

// Handles background logic for cap open and beacon packets
// interacts directly with the database
//  - record medication events
//    - ideally, will record cap open packets
//    - asking if x pills were taken on seqnum gap
//  - trigger low pill count notification
void packetHandlerTask(Stream<Set<PillPacket>> stream) async {
  // this should really be done using streams, but whatever lmfao
  Map<int, Map<DateTime, PillPacket>> logs = {};

  FlutterBackgroundService().onDataReceived.listen((snapshot) async {
    // add in new bottle ids for new logs
    for (int el in snapshot!['ids']) {
      if (!logs.containsKey(el)) {
        logs[el] = {};
        // attempt to populate from disk, if any
        var json = await read(el.toString());
        if (json.isNotEmpty) {
          for (String key in json.keys) {
            DateTime d = DateTime.parse(key);
            PillPacket p = PillPacket.fromJson(json[key]);
            logs[el]![d] = p;
          }
        }
      }
    }
  });

  // periodically commit logs to storage
  Timer.periodic(const Duration(minutes: 15), (timer) async {
    for (var id in logs.keys) {
      await write(id.toString(), logs[id]);
    }
  });

  var sub = stream.listen((packets) {
    for (var p in packets) {
      if (p.type == PacketType.cap) {
        // AwesomeNotifications().createNotification(
        //     content: NotificationContent(
        //         id: 10,
        //         channelKey: 'basic_channel',
        //         title: 'Simple Notification',
        //         body: 'Simple body'),
        //     actionButtons: [
        //       NotificationActionButton(
        //         key: "button_key",
        //         label: 'button_label',
        //       ),
        //       NotificationActionButton(
        //         key: "yeees",
        //         label: 'noo',
        //       )
        //     ]);
      }
    }
  });

  await sub.asFuture();
}

// Background task which queries db to see
// if there should be any notification events happening
// TODO: Add feature to add more reminders
//       if someone hasn't taken their meds,
//       do this by expecting the correct sequence number
void reminderTask() {
  //TODO: change duration to every 1-5 minutes
  const Duration d = Duration(seconds: 15);
  Timer.periodic(d, (timer) async {
    // get all the medications from the database
    List<Medication> meds = [];
    var json = await read(MEDICATIONS_DB);

    if (json.isNotEmpty) {
      meds = json['medications']
          .map<Medication>((m) => Medication.fromJson(m))
          .toList();
    }

    // iterate over all our medications to see what's up
    // this is the worst way to do this lmfao
    DateTime now = DateTime.now();
    DateTime compareTime = DateTime(1, 1, 1, now.hour, now.minute, now.second);
    for (Medication med in meds) {
      for (DateTime t in med.times) {
        if (t.difference(compareTime).abs() < d) {
          String body = 'Reminder to take ${med.name} at ${t.hour}:${t.minute}';
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 69,
                  channelKey: 'reminder_channel',
                  title: 'PillPal Reminder',
                  body: body));
        }
      }
    }
  });
}
