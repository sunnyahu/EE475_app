import 'dart:async';
import 'dart:collection';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pill_pal/blue/data/packets.dart';
import 'package:pill_pal/db/database.dart';
import 'package:pill_pal/med/data/medication.dart';

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
      debug: true);

  handleNotifTaps();
}

// Handles background logic for cap open and beacon packets
// interacts directly with the database
//  - record medication events
//    - ideally, will record cap open packets
//    - asking if x pills were taken on seqnum gap
//  - trigger low pill count notification
void packetHandlerTask(Stream<Set<PillPacket>> stream) async {
  var sub = stream.listen((packets) {
    for (var p in packets) {
      if (p.type == PacketType.cap || p.type == PacketType.beacon) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: 'Simple Notification',
                body: 'Simple body'),
            actionButtons: [
              NotificationActionButton(
                key: "button_key",
                label: 'button_label',
              ),
              NotificationActionButton(
                key: "yeees",
                label: 'noo',
              )
            ]);
      }
    }
  });

  await sub.asFuture();
}

// Handles logic on what to do when user taps on notifications
void handleNotifTaps() {
  AwesomeNotifications().actionStream.listen((ReceivedAction event) {
    // TODO: Switch on event.buttonKeyPressed
    print(event.buttonKeyPressed);
    print(event.toMap().toString());
  });
}

// Background task which queries db to see
// if there should be any notification events happening
void reminderTask() {
  //TODO: change duration to every 1-5 minutes
  const Duration d = Duration(seconds: 15);
  Timer.periodic(d, (timer) {
    // get all the medications from the database
    List<Medication> meds = [];
    read(MEDICATIONS_DB).then((json) {
      if (json.isNotEmpty) {
        meds = json['medications']
            .map<Medication>((m) => Medication.fromJson(m))
            .toList();
      }
    });

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
                  channelKey: 'basic_channel',
                  title: 'PillPal Reminder',
                  body: body));
        }
      }
    }
  });
}
