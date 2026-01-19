// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab_exam/main.dart';

void main() {
  testWidgets('Onboarding shows first page and can navigate', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TodoApp());

    // Verify that first page is displayed
    expect(find.text('Manage Tasks'), findsOneWidget);
    expect(find.text('ถัดไป'), findsOneWidget);
    expect(find.text('ก่อนหน้า'), findsNothing); // No previous button on first page

    // Tap next button
    await tester.tap(find.text('ถัดไป'));
    await tester.pump();

    // Verify second page is displayed
    expect(find.text('Swipe to Action'), findsOneWidget);
    expect(find.text('ก่อนหน้า'), findsOneWidget);
    expect(find.text('ถัดไป'), findsOneWidget);

    // Tap next again
    await tester.tap(find.text('ถัดไป'));
    await tester.pump();

    // Verify third page is displayed
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('เข้าสู่หน้าหลัก'), findsOneWidget);
  });
}
