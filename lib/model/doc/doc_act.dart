class DocAct {
  late int id;
  late String curdate;
  late String curtime;
  late int docNum;
  late int whId;
  late int contraId;
  late String notes;
  late bool isPrinted;
  late String myUUID;

  DocAct({
    required this.id,
    required this.curdate,
    required this.curtime,
    required this.docNum,
    required this.whId,
    required this.contraId,
    required this.notes,
    required this.isPrinted,
    required this.myUUID,
  });

  factory DocAct.fromJson(Map<String, dynamic> json) {
    return DocAct(
      id: json['id'],
      curdate: json['curdate'],
      curtime: json['curtime'],
      docNum: json['doc_num'],
      whId: json['wh_id'],
      contraId: json['contra_id'],
      notes: json['notes'],
      isPrinted: json['is_printed'],
      myUUID: json['my_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "curdate": curdate,
        "curtime": curtime,
        "doc_num": docNum,
        "wh_id": whId,
        "contra_id": contraId,
        "notes": notes,
        "is_printed": isPrinted,
        "my_uuid": myUUID,
      };

  DocAct.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    curdate = map['curdate'] ?? "";
    curtime = map['curtime'] ?? "";
    docNum = map['doc_num'] ?? 0;
    whId = map['wh_id'] ?? 0;
    contraId = map['contra_id'] ?? 0;
    notes = map['notes'] ?? "";
    isPrinted = map['is_printed'] ?? false;
    myUUID = map['my_uuid'] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['curdate'] = curdate;
    map['curtime'] = curtime;
    map['doc_num'] = docNum;
    map['wh_id'] = whId;
    map['contra_id'] = contraId;
    map['notes'] = notes;
    map['is_printed'] = isPrinted;
    map['my_uuid'] = myUUID;

    return map;
  }
}
