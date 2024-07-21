import 'dart:html' as html;
import 'package:flutter/material.dart';

void initializeService() {
  initializeWebWorker();
}

void initializeWebWorker() {
  final worker = html.Worker('worker.js');

  worker.onMessage.listen((event) {
    debugPrint('Web Worker message: ${event.data}');
  });

  worker.postMessage('start');
}