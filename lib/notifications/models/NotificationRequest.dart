
class NotificationRequest {
  _RequestHeader requestHeader;
  _NotificationHeader notificationHeader;
  _NotificationData notificationData;

  NotificationRequest(
      {this.requestHeader, this.notificationHeader, this.notificationData});
}

class NotificationRequestBuilder {
  _RequestHeader _requestHeader;
  _NotificationHeader _notificationHeader;
  _NotificationData _notificationData;

  NotificationRequestBuilder setRequestHeader(_RequestHeader _requestHeader) {
    this._requestHeader = _requestHeader;
    return this;
  }

  NotificationRequestBuilder setNotificationHeader(
      _NotificationHeader _notificationHeader) {
    this._notificationHeader = _notificationHeader;
    return this;
  }

  NotificationRequestBuilder setNotificationData(
      _NotificationData _notificationData) {
    this._notificationData = _notificationData;
    return this;
  }

  NotificationRequest build() {
    return new NotificationRequest(
        requestHeader: this._requestHeader,
        notificationHeader: this._notificationHeader,
        notificationData: this._notificationData);
  }
}

class _NotificationData {
  Map<String, dynamic> _dataMap;

  _NotificationData(Map<String, dynamic> map) {
    this._dataMap = map;
  }

  void set(String key, dynamic value) {
    _dataMap[key] = value;
  }

  Map<String, dynamic> serialize() {
    return _dataMap;
  }
}

class NotificationDataBuilder {
  Map<String, dynamic> _dataMap = new Map<String, dynamic>();

  NotificationDataBuilder setData(String key, dynamic value) {
    _dataMap[key] = value;
    return this;
  }

  _NotificationData build() {
    return new _NotificationData(this._dataMap);
  }
}

class _NotificationHeader {
  final String title;
  final String body;

  _NotificationHeader({this.title, this.body});

  Map<String, dynamic> serialize() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map['body'] = body;
    map['title'] = title;
    return map;
  }
}

class NotificationHeaderBuilder {
  String _title;
  String _body;

  NotificationHeaderBuilder setTitle(String title) {
    this._title = title;
    return this;
  }

  NotificationHeaderBuilder setBody(String body) {
    this._body = body;
    return this;
  }

  _NotificationHeader build() {
    return new _NotificationHeader(title: this._title, body: this._body);
  }
}

class _RequestHeader {
  String _contentType;
  String _authorization;

  _RequestHeader(String contentType) {
    this._contentType = contentType;
  }

  void setAuthorization(String auth) {
    this._authorization = auth;
  }

  Map<String, String> serialize() {
    Map<String, String> map = new Map<String, String>();
    map['Content-Type'] = _contentType;
    map['Authorization'] = _authorization;
    return map;
  }
}

class RequestHeaderBuilder {
  String _contentType;


  RequestHeaderBuilder setContentType(String contentType) {
    this._contentType = contentType;
    return this;
  }

  _RequestHeader build() {
    return new _RequestHeader(
        _contentType);
  }
}
