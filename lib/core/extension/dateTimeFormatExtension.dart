import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum DateTimeFormat { date, time }

String timeFormat(DateTime timestamp) {
  var outputFormat = DateFormat('h:mm a');
  var outputDate = outputFormat.format(timestamp);
  return outputDate;
}

extension DateTimeFormatExtension on DateTimeFormat {
  String get datePickerFormat {
    switch (this) {
      case DateTimeFormat.date:
        return 'yyyy-MMMM-dd';
      case DateTimeFormat.time:
        return "HH:mm";
    }
  }

  static String displayChatTimeFromTimestamp(DateTime timestamp) {
    var v = DateTime.now().difference(timestamp);
    if (v.inHours < 24) {
      return "${"today".tr} ${timeFormat(timestamp)}";
    } else {
      var outputFormat = DateFormat('MM-dd-yyyy');
      var outputDate = outputFormat.format(timestamp);
      return outputDate;
    }
  }

  static String displayMSGTimeFromTimestamp(DateTime timestamp) {
    var v = DateTime.now().difference(timestamp);
    if (v.inHours < 24) {
      return "${timeFormat(timestamp)}";
    } else {
      var outputFormat = DateFormat('MM-dd-yyyy');
      var outputDate = outputFormat.format(timestamp);
      return outputDate;
    }
  }

  static String displayTimeFromTimestampForPost(DateTime timestamp) {
    var v = DateTime.now().difference(timestamp);
    if (v.inHours < 24) {
      if (v.inMinutes < 60) {
        if (v.inMinutes == 0) {
          return "just_now".tr;
        }
        return "${v.inMinutes}min";
      } else {
        return "${v.inHours}hr";
      }
    } else {
      var outputFormat = DateFormat('MM-dd-yyyy');
      //   var outputFormat = DateFormat('MMM dd, yyyy');
      var outputDate = outputFormat.format(timestamp);
      return outputDate;
    }
  }

  String get availabilityDateTimeFormat {
    switch (this) {
      case DateTimeFormat.date:
        return 'yyyy-MM-ddTHH:mm:ss';
      case DateTimeFormat.time:
        return "h:mm a";
    }
  }

  String get availabilityDBDateTimeFormat {
    switch (this) {
      case DateTimeFormat.date:
        return 'yyyy-MM-ddTHH:mm:ss';
      case DateTimeFormat.time:
        Duration duration = DateTime.now().timeZoneOffset;
        return "yyyy-MM-dd'T'HH:mm:ss${durationToString(duration.inMinutes)}";
    }
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    var firstWord;
    if (parts[0].contains("-")) {
      var p = parts[0].split("-");

      firstWord = "-${p[1].padLeft(2, "0")}";
    } else {
      firstWord = "+${parts[0].padLeft(2, "0")}";
    }
    return '$firstWord${parts[1].padLeft(2, '0')}';
  }
}

String appTimeFunDB(TimeOfDay timeOfDay) {
  final dt = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, timeOfDay.hour, timeOfDay.minute);
  var outputFormat =
      DateFormat(DateTimeFormat.time.availabilityDBDateTimeFormat);
  var outputDate = outputFormat.format(dt);

  return outputDate;
}

String appTimeFun(String time) {
  final dateTime = DateTime.parse(time);

  var outputFormat = DateFormat(DateTimeFormat.time.availabilityDateTimeFormat);
  var outputDate = outputFormat.format(dateTime);

  return outputDate;
}
