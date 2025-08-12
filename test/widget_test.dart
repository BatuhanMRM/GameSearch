import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_reviews_2/main.dart';

void main() {
  testWidgets('Kategori ekranı başlangıçta gösteriliyor', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(GameApp());

    // Varsayılan ekran Kategoriler olmalı
    expect(find.text('Aksiyon'), findsOneWidget); // dummy'deki kategori başlığı
  });

  testWidgets('Favoriler sekmesine geçiş yapılıyor mu', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(GameApp());

    // Favoriler sekmesine tıkla (index: 1)
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle(); // animasyonlar vs. biter

    // Favoriler başlığını kontrol et
    expect(find.text('Favori Oyunlar'), findsOneWidget);
  });
}
