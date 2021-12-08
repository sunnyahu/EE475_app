import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pill_pal/blue/data/packets.dart';
import 'package:pill_pal/contact/data/contact.dart';
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
            channelKey: 'low_channel',
            channelName: 'Low Pill Notifications',
            channelGroupKey: 'reminders',
            channelDescription: 'Notification channel for basic tests'),
        NotificationChannel(
            channelKey: 'reset_channel',
            channelName: 'Bottle Reset Notifications',
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

  // handleNotifTaps();
}

// Handles logic on what to do when user taps on notifications
// void handleNotifTaps() {
//   AwesomeNotifications().actionStream.listen((ReceivedAction event) async {
//     // TODO: Switch on event.buttonKeyPressed
//     print(event.buttonKeyPressed);
//     print(event.toMap().toString());
//   });
// }

// Handles background logic for cap open and beacon packets
// interacts directly with the database
//  - record medication events
//    - ideally, will record cap open packets
//    - asking if x pills were taken on seqnum gap
//  - trigger low pill count notification
// This should really be formed into an instance of a service,
// but I don't feel like changing it right now lol
void packetHandlerTask(Stream<Set<PillPacket>> stream) async {
  // this should really be done using streams, but whatever lmfao
  Map<int, List<DateTime>> logs = {};
  Map<int, Medication> meds = {};
  Map<int, DateTime> medLastSeen = {};
  Map<int, DateTime> medNextExpect = {};

  // ==============================
  // Logs
  // ==============================
  // update which bottles we're keeping track of
  FlutterBackgroundService().onDataReceived.listen((snapshot) async {
    if (snapshot!.containsKey('ids') && snapshot['ids'].isNotEmpty) {
      // add in new bottle ids for new logs
      for (int el in snapshot['ids']) {
        if (!logs.containsKey(el)) {
          logs[el] = [];
          // attempt to populate from disk, if possible
          var json = await read(el.toString());
          if (json.isNotEmpty) {
            var data = json['data'];
            for (String time in data) {
              DateTime d = DateTime.parse(time);
              logs[el]!.add(d);
            }
          }
        }
      }
    }
  });

  // periodically commit logs to storage
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    for (var id in logs.keys) {
      await write(id.toString(),
          {'data': logs[id]!.map((d) => d.toIso8601String()).toList()});
    }
  });

  // ==============================
  // Medication State Tracking
  // ==============================
  // read in medications from a file once
  var json = await read(MEDICATIONS_DB);
  if (json.isNotEmpty) {
    var medList = json['medications']
        .map<Medication>((m) => Medication.fromJson(m))
        .toList();
    for (Medication m in medList) {
      meds[m.id] = m;
      medLastSeen[m.id] = DateTime.now();
      medNextExpect[m.id] = findNextExpectedTime(m.times);
    }
  }

  // set up a listener for changes to medications
  FlutterBackgroundService().onDataReceived.listen((snapshot) {
    if (snapshot!.containsKey('updated_med')) {
      Medication m = Medication.fromJson(snapshot['updated_med']);
      if (meds.containsKey(m.id)) {
        meds[m.id]!.name = m.name;
        meds[m.id]!.push = m.push;
        meds[m.id]!.leftBehind = m.leftBehind;
        meds[m.id]!.dosage = m.dosage;
        meds[m.id]!.nPills = m.nPills;
        meds[m.id]!.contacts = m.contacts;
        meds[m.id]!.times = m.times;
        medNextExpect[m.id] = findNextExpectedTime(m.times);
      } else {
        meds[m.id] = m;
      }
    }
  });

  // ==============================
  // Reminder Service
  // ==============================
  const Duration d = Duration(seconds: 15);
  const Duration d1 = Duration(minutes: 1);

  // Time-based medication reminder
  // const Duration d1 = Duration(hours: );
  Timer.periodic(d, (timer) async {
    DateTime now = DateTime.now();
    for (int id in meds.keys) {
      print(id.toString());
      print(medNextExpect[id]!);
      // send a notification if the user is late on dosage
      if (now.difference(medNextExpect[id]!) > const Duration(seconds: 10)) {
        String dispMinute = medNextExpect[id]!.minute < 10
            ? "0" + medNextExpect[id]!.minute.toString()
            : medNextExpect[id]!.minute.toString();
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: id >> 32,
                channelKey: 'reminder_channel',
                title: 'PillPal Reminder',
                body:
                    "Did you forget to take ${meds[id]!.name} at ${medNextExpect[id]!.hour}:$dispMinute?",
                notificationLayout: NotificationLayout.BigText));
        for (Contact c in meds[id]!.contacts) {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: (id >> 32) + 1,
                  channelKey: 'reminder_channel',
                  title: 'PillPal Reminder',
                  body:
                      "Sending a text to ${c.name} to remind you to take ${meds[id]!.name}",
                  notificationLayout: NotificationLayout.BigText));
        }
      }
      // send a notification for an upcoming dosage
      for (DateTime t in meds[id]!.times) {
        if (t.difference(
                DateTime(t.year, t.month, t.day, now.hour, now.minute)) <
            d1) {
          if (meds[id]!.push) {
            String displayMinute =
                t.minute < 10 ? "0" + t.minute.toString() : t.minute.toString();
            String body =
                'Reminder to take ${meds[id]!.name} at ${t.hour}:$displayMinute';
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: id >> 32,
                    channelKey: 'reminder_channel',
                    title: 'PillPal Reminder',
                    body: body));
          }
        }
      }
    }
  });

  // You-left-your-bottle-behind reminder
  Timer.periodic(d, (timer) async {
    for (int key in meds.keys) {
      if (meds[key]!.leftBehind &&
          medLastSeen[key] != null &&
          DateTime.now().difference(medLastSeen[key]!) >
              const Duration(seconds: 40)) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: (key >> 32) - 1,
                channelKey: 'leave_channel',
                title: 'PillPal Lost Contact with Bottle',
                body:
                    'PillPal cannot detect ${meds[key]!.name}, check if it is around!',
                notificationLayout: NotificationLayout.BigText));
      }
    }
  });

  // ==============================
  // Incoming BLE Packet handler
  // ==============================
  var sub = stream.listen((packets) {
    for (var p in packets) {
      // only process a registered bottle's packets
      if (meds.containsKey(p.id) && p.type == PacketType.beacon) {
        Medication m = meds[p.id]!;
        medLastSeen[p.id] = p.timestamp;

        // TODO: 'smarter' management of sequence numbers
        int nDoses = p.seqNum - m.seqNum;
        if (nDoses < 0) {
          m.seqNum = 0;
          // bottle was probably reset, send a notif
          // with an alert to check contents of bottle
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: (p.id >> 32) + 2,
                  channelKey: 'low_channel',
                  title: 'Low on Medication',
                  body:
                      "${m.name}'s bottle might've been reset. Double check how many pills are in there!"));
          FlutterBackgroundService().sendData({'updated_med_state': m});
        }

        if (nDoses > 0) {
          m.nPills -= nDoses * m.dosage;
          m.seqNum = p.seqNum;
          medNextExpect[m.id] = findNextExpectedTime(m.times);
          // consider adding in a "you took your meds too early lol" here
          if (m.nPills < 10) {
            // notify user that they probalby have
            // less than 10 pills left
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: (p.id >> 32) + 2,
                    channelKey: 'low_channel',
                    title: 'Low on Medication',
                    body: "${m.name} only has ${m.nPills} pills left!"));
            FlutterBackgroundService().sendData({'updated_med_state': m});
          }
          // log this event nDoses times
          for (int i = 0; i < nDoses; i++) {
            logs[m.id]!.add(p.timestamp);
          }
        }
      }
    }
  });

  await sub.asFuture();
}

// Helper function to identify the next expected time
DateTime findNextExpectedTime(List<DateTime> times) {
  DateTime now = DateTime.now();
  List<DateTime> adjustedTime = [];
  for (DateTime t in times) {
    adjustedTime.add(DateTime(now.year, now.month, now.day, t.hour, t.minute));
  }
  adjustedTime.sort();
  DateTime ret = now;
  bool changed = false;
  for (int i = 0; i < adjustedTime.length; i++) {
    DateTime t = adjustedTime[i];
    if (t.isAfter(now.subtract(const Duration(minutes: 3)))) {
      ret = adjustedTime[i];
      changed = true;
      break;
    }
  }

  if (!changed) {
    ret = adjustedTime[0].add(const Duration(days: 1));
  }
  return ret;
}

// Background task which queries db to see
// if there should be any notification events happening
// TODO: Add feature to send more reminders
//       if someone hasn't taken their meds,
//       do this by expecting the correct sequence number
// void reminderTask() async {
//   // load up all the medications
//   List<Medication> meds = [];
//   var json = await read(MEDICATIONS_DB);
//   if (json.isNotEmpty) {
//     meds = json['medications']
//         .map<Medication>((m) => Medication.fromJson(m))
//         .toList();
//   }

//   // set up a listener for changes to medications
//   FlutterBackgroundService().onDataReceived.listen((snapshot) {
//     if (snapshot!.containsKey('updated_med')) {
//       Medication m = Medication.fromJson(snapshot['updated_med']);
//       int i = 0;
//       for (i; i < meds.length; i++) {
//         if (meds[i].id == m.id) {
//           meds[i].name = m.name;
//           meds[i].times = m.times;
//           meds[i].push = m.push;
//           break;
//         }
//       }
//       if (i == meds.length) {
//         meds.add(m);
//       }
//     }
//   });

//   //TODO: change duration to every 1-5 minutes
//   const Duration d = Duration(seconds: 15);
//   Timer.periodic(d, (timer) async {
//     // iterate over all our medications to see what's up
//     // this is the worst way to do this lmfao
//     DateTime now = DateTime.now();
//     DateTime compareTime = DateTime(1, 1, 1, now.hour, now.minute, now.second);
//     for (Medication med in meds) {
//       for (DateTime t in med.times) {
//         if (med.push && t.difference(compareTime).abs() < d) {
//           String body = 'Reminder to take ${med.name} at ${t.hour}:${t.minute}';
//           AwesomeNotifications().createNotification(
//               content: NotificationContent(
//                   id: 69,
//                   channelKey: 'reminder_channel',
//                   title: 'PillPal Reminder',
//                   body: body));
//         }
//       }
//     }
//   });
// }
