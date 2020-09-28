import 'package:enum_to_string/enum_to_string.dart';
import 'package:gupshop/video_call/models/twilio/twilio_enums.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class TwilioListRoomRequest {
  final DateTime dateCreatedAfter;
  final DateTime dateCreatedBefore;
  final int limit;
  final TwilioRoomStatus status;
  final String uniqueName;

  TwilioListRoomRequest({
    this.dateCreatedAfter,
    this.dateCreatedBefore,
    this.limit,
    this.status,
    this.uniqueName,
  });

  factory TwilioListRoomRequest.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    return TwilioListRoomRequest(
      dateCreatedAfter: DateTime.tryParse(data['dateCreatedAfter'] ?? ''),
      dateCreatedBefore: DateTime.tryParse(data['dateCreatedBefore'] ?? ''),
      limit: data['limit'],
      status: EnumToString.fromString(TwilioRoomStatus.values, data['status'].toString().camelCase),
      uniqueName: data['uniqueName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateCreatedAfter': DateFormat('yyyy-MM-dd').format(dateCreatedAfter),
      'dateCreatedBefore': DateFormat('yyyy-MM-dd').format(dateCreatedBefore),
      'limit': limit,
      'status': status != null ? EnumToString.parse(status).paramCase : null,
      'uniqueName': uniqueName,
    };
  }
}
