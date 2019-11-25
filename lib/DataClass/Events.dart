

//File generated using https://javiercbk.github.io/

class Events {
  Id _id;
  String _title;
  String _description;
  String _place;
  int _fromDate;
  int _toDate;

  Events(
      {Id id,
      String title,
      String description,
      String place,
      int fromDate,
      int toDate}) {
    this._id = id;
    this._title = title;
    this._description = description;
    this._place = place;
    this._fromDate = fromDate;
    this._toDate = toDate;
  }

  Id get id => _id;

  set id(Id id) => _id = id;

  String get title => _title;

  set title(String title) => _title = title;

  String get description => _description;

  set description(String description) => _description = description;

  String get place => _place;

  set place(String place) => _place = place;

  int get fromDate => _fromDate;

  set fromDate(int fromDate) => _fromDate = fromDate;

  int get toDate => _toDate;

  set toDate(int toDate) => _toDate = toDate;

  Events.fromJson(Map<String, dynamic> json) {
    _id = json['id'] != null ? new Id.fromJson(json['id']) : null;
    _title = json['title'];
    _description = json['description'];
    _place = json['place'];
    _fromDate = json['fromDate'];
    _toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._id != null) {
      data['id'] = this._id.toJson();
    }
    data['title'] = this._title;
    data['description'] = this._description;
    data['place'] = this._place;
    data['fromDate'] = this._fromDate;
    data['toDate'] = this._toDate;
    return data;
  }
}

class Id {
  int _timestamp;
  int _machineIdentifier;
  int _processIdentifier;
  int _counter;
  int _time;
  String _date;
  int _timeSecond;

  Id(
      {int timestamp,
      int machineIdentifier,
      int processIdentifier,
      int counter,
      int time,
      String date,
      int timeSecond}) {
    this._timestamp = timestamp;
    this._machineIdentifier = machineIdentifier;
    this._processIdentifier = processIdentifier;
    this._counter = counter;
    this._time = time;
    this._date = date;
    this._timeSecond = timeSecond;
  }

  int get timestamp => _timestamp;

  set timestamp(int timestamp) => _timestamp = timestamp;

  int get machineIdentifier => _machineIdentifier;

  set machineIdentifier(int machineIdentifier) =>
      _machineIdentifier = machineIdentifier;

  int get processIdentifier => _processIdentifier;

  set processIdentifier(int processIdentifier) =>
      _processIdentifier = processIdentifier;

  int get counter => _counter;

  set counter(int counter) => _counter = counter;

  int get time => _time;

  set time(int time) => _time = time;

  String get date => _date;

  set date(String date) => _date = date;

  int get timeSecond => _timeSecond;

  set timeSecond(int timeSecond) => _timeSecond = timeSecond;

  Id.fromJson(Map<String, dynamic> json) {
    _timestamp = json['timestamp'];
    _machineIdentifier = json['machineIdentifier'];
    _processIdentifier = json['processIdentifier'];
    _counter = json['counter'];
    _time = json['time'];
    _date = json['date'];
    _timeSecond = json['timeSecond'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this._timestamp;
    data['machineIdentifier'] = this._machineIdentifier;
    data['processIdentifier'] = this._processIdentifier;
    data['counter'] = this._counter;
    data['time'] = this._time;
    data['date'] = this._date;
    data['timeSecond'] = this._timeSecond;
    return data;
  }
}
