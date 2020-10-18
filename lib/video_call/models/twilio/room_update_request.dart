class RoomUpdateRequest {
  final String name;
  final String token;
  final String identity;
  final String caller;
  final String inviteePhoneNumber;
  final bool active;

  RoomUpdateRequest({
    this.name,
    this.token,
    this.identity,
    this.caller,
    this.inviteePhoneNumber,
    this.active = true
  });

  factory RoomUpdateRequest.fromMap(Map<String, dynamic> data) {
    if(data == null) return null;

    return RoomUpdateRequest(
      name: data['name'],
      token: data['token'],
      identity: data['identity'],
      caller: data['caller'],
      inviteePhoneNumber: data['inviteePhoneNumber'],
      active: data['active']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'token': token,
      'identity': identity,
      'caller': caller,
      'inviteePhoneNumber': inviteePhoneNumber,
      'active': active
    };
  }
}