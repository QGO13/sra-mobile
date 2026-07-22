import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/presentation/widgets/room_type_card.dart';

void main() {
  testWidgets('RoomTypeCard should display room type details', (WidgetTester tester) async {
    // Set screen size to prevent overflow & hit test failures
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    const roomType = BookingRoomType(
      id: '1',
      nom: 'Chambre Deluxe',
      prixNuit: 75000,
      capacite: 2,
      description: 'Une chambre luxueuse',
      images: [],
      equipments: [],
    );

    bool clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: RoomTypeCard(
              roomType: roomType,
              onSelect: () {
                clicked = true;
              },
            ),
          ),
        ),
      ),
    );

    // Verify name is shown
    expect(find.text('Chambre Deluxe'), findsOneWidget);
    // Verify choose button is present
    expect(find.text('CHOISIR'), findsOneWidget);

    // Tap on the button
    await tester.tap(find.text('CHOISIR'));
    await tester.pump();

    expect(clicked, isTrue);

    // Reset physical size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
