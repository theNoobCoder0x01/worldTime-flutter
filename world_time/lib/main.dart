import 'package:flutter/material.dart';
import 'package:worldtime/pages/home.dart';
import 'package:worldtime/pages/choose_location.dart';
import 'package:worldtime/pages/loading.dart';

void main() => runApp(MaterialApp(
    routes: {
      "/": (context) => SafeArea(child: Loading()),
      "/home": (context) => SafeArea(child: Home()),
      "/choose_location": (context) => SafeArea(child: Location()),
    },
  )
);