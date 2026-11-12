import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexvia/widgets/contador_card.dart';

void main() {
  testWidgets('ContadorCard mostra quantas pessoas ainda faltam', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ContadorCard(faltam: 3, total: 5)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
    expect(find.text('2 de 5 em segurança'), findsOneWidget);
  });

  testWidgets('ContadorCard comemora quando todos estão seguros', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ContadorCard(faltam: 0, total: 4)),
      ),
    );

    expect(find.text('Todos em segurança'), findsOneWidget);
  });
}
