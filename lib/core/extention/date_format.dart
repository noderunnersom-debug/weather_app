import 'package:intl/intl.dart';

extension WheatherDateFormat on DateTime {
  String get formattedDate => DateFormat('d MMM', 'ru').format(this);
}
