library notification_state;
import 'package:flutter/material.dart';

bool shouldNavigateToCameraScreen = false;

void handleNotificationResponse(String? payload, BuildContext context) {
  if (payload == 'camera_screen') {
    shouldNavigateToCameraScreen = true;
  }
}
