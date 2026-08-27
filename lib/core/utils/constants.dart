import 'package:flutter_dotenv/flutter_dotenv.dart';
abstract class Constants {
    static String get apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';
}