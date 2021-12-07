import 'dart:collection';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pill_pal/blue/data/packets.dart';

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
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white),
        NotificationChannel(
            channelKey: 'button_key',
            channelName: 'button_confirm_channel',
            channelDescription: 'channel for confirmations')
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
        print("notifying");
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

// Background task which loops over db to see
// if there should be any notification events happening
void reminderTask() {}
