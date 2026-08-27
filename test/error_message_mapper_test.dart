import 'package:flutter_test/flutter_test.dart';
import 'package:weather/core/utils/error_message_mapper.dart';

void main() {
  group('friendlyErrorMessage', () {
    test('распознаёт выключенную геолокацию', () {
      final result = friendlyErrorMessage('Location services are disabled.');

      expect(result, contains('Геолокация выключена'));
    });

    test('распознаёт постоянный отказ в доступе к геолокации', () {
      final result = friendlyErrorMessage(
        'Location permissions are permanently denied, we cannot request permissions.',
      );

      expect(result, contains('запрещён навсегда'));
    });

    test('распознаёт обычный отказ в доступе к геолокации', () {
      final result = friendlyErrorMessage('Location permissions are denied');

      expect(result, contains('доступ к геолокации'));
    });

    test('распознаёт сетевые ошибки (таймаут, обрыв соединения)', () {
      expect(
        friendlyErrorMessage('DioException: Connection timeout'),
        contains('интернет'),
      );
      expect(
        friendlyErrorMessage('SocketException: Failed host lookup'),
        contains('интернет'),
      );
    });

    test('для нераспознанной ошибки возвращает общий текст, а не exception', () {
      final result = friendlyErrorMessage(
        'FormatException: Unexpected character at offset 42',
      );

      expect(result, isNot(contains('FormatException')));
      expect(result, isNot(contains('offset 42')));
      expect(result, contains('Попробуйте ещё раз'));
    });

    test('маппинг не зависит от регистра исходного сообщения', () {
      final lower = friendlyErrorMessage('location services are disabled.');
      final upper = friendlyErrorMessage('LOCATION SERVICES ARE DISABLED.');

      expect(lower, equals(upper));
    });
  });
}