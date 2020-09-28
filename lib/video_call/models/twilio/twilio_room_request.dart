import 'package:enum_to_string/enum_to_string.dart';
import 'package:gupshop/video_call/models/twilio/region.dart';
import 'package:gupshop/video_call/models/twilio/twilio_enums.dart';
import 'package:recase/recase.dart';


class TwilioRoomRequest {
  final TwilioRoomType type;
  final bool enableTurn;
  final String uniqueName;
  final int maxParticipants;
  final TwilioStatusCallbackMethod statusCallbackMethod;
  final String statusCallback;
  final bool recordParticipantsOnConnect;
  final List<TwilioVideoCodec> videoCodecs;
  final Region mediaRegion;

  TwilioRoomRequest({
    this.type,
    this.enableTurn,
    this.uniqueName,
    this.maxParticipants,
    this.statusCallbackMethod,
    this.statusCallback,
    this.recordParticipantsOnConnect,
    this.videoCodecs,
    this.mediaRegion,
  });

  factory TwilioRoomRequest.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    return TwilioRoomRequest(
      enableTurn: data['enableTurn'],
      maxParticipants: data['maxParticipants'],
      mediaRegion: EnumToString.fromString(Region.values, data['mediaRegion']),
      recordParticipantsOnConnect: data['recordParticipantsOnConnect'],
      statusCallback: data['statusCallback'],
      statusCallbackMethod: EnumToString.fromString(TwilioStatusCallbackMethod.values, data['statusCallbackMethod']),
      type: EnumToString.fromString(TwilioRoomType.values, data['type'].toString().camelCase),
      uniqueName: data['uniqueName'],
      videoCodecs: (data['videoCodecs'] as List<String>)
          .map(
            (String videoCodec) => EnumToString.fromString(TwilioVideoCodec.values, videoCodec),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enableTurn': enableTurn,
      'maxParticipants': maxParticipants,
      'mediaRegion': EnumToString.parse(mediaRegion),
      'recordParticipantsOnConnect': recordParticipantsOnConnect,
      'statusCallback': statusCallback,
      'statusCallbackMethod': EnumToString.parse(statusCallbackMethod),
      'type': type != null ? EnumToString.parse(type).paramCase : null,
      'uniqueName': uniqueName,
      'videoCodecs': videoCodecs?.map((TwilioVideoCodec videoCodec) => EnumToString.parse(videoCodec))?.toList()
    };
  }
}
