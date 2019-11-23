class Infos {
  Id id;
  String title;
  String description;
  int createdAt;

  Infos({this.id, this.title, this.description, this.createdAt});

  Infos.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? new Id.fromJson(json['id']) : null;
    title = json['title'];
    description = json['description'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id.toJson();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Id {
  int timestamp;
  int machineIdentifier;
  int processIdentifier;
  int counter;
  int time;
  String date;
  int timeSecond;

  Id(
      {this.timestamp,
        this.machineIdentifier,
        this.processIdentifier,
        this.counter,
        this.time,
        this.date,
        this.timeSecond});

  Id.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    machineIdentifier = json['machineIdentifier'];
    processIdentifier = json['processIdentifier'];
    counter = json['counter'];
    time = json['time'];
    date = json['date'];
    timeSecond = json['timeSecond'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['machineIdentifier'] = this.machineIdentifier;
    data['processIdentifier'] = this.processIdentifier;
    data['counter'] = this.counter;
    data['time'] = this.time;
    data['date'] = this.date;
    data['timeSecond'] = this.timeSecond;
    return data;
  }
}
