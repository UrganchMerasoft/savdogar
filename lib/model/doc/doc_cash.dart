class DocCash {
  late int id;
  late int typeId;
  late int payType;
  late int annul;
  late int whId;
  late String curdate;
  late String curtime;
  late int contraId;
  late int isCur;
  late int invertCur;
  late double summ;
  late double summPla;
  late double summRet;
  late double summCur;
  late double summReal;
  late double curRate;
  late String notes;
  late int zatratId;
  late String zatratName;
  late int byInvId;
  late String myUuid;
  late int userId;
  late bool forCashback;
  late double forQty;
  late int isAccepted;
  late int isRecovered;
  late String contraName;

  DocCash({
    required this.id,
    required this.typeId,
    required this.payType,
    required this.annul,
    required this.whId,
    required this.curdate,
    required this.curtime,
    required this.contraId,
    required this.isCur,
    required this.invertCur,
    required this.summ,
    required this.summPla,
    required this.summCur,
    required this.summRet,
    required this.summReal,
    required this.curRate,
    required this.notes,
    required this.zatratId,
    required this.zatratName,
    required this.byInvId,
    required this.myUuid,
    required this.userId,
    required this.forCashback,
    required this.forQty,
    required this.isAccepted,
    required this.isRecovered,
    required this.contraName,
  });

  factory DocCash.fromJson(Map<String, dynamic> json) {
    return DocCash(
      id: json['id'],
      typeId: json['type_id'],
      payType: json['pay_type'],
      annul: json['annul'],
      whId: json['wh_id'],
      curdate: json['curdate'],
      curtime: json['curtime'],
      contraId: json['contra_id'],
      isCur: json['is_cur'],
      invertCur: json['invert_cur'],
      summ: json['summ'],
      summPla: json['summ_pla'],
      summCur: json['summ_cur'],
      summRet: json['summ_ret'],
      summReal: json['summ_real'],
      curRate: json['cur_rate'],
      notes: json['notes'],
      zatratId: json['zatrat_id'],
      zatratName: json['zatrat_name'],
      byInvId: json['by_inv_id'],
      myUuid: json['my_uuid'],
      userId: json['user_id'],
      forCashback: json['for_cashback'] == 1,
      forQty: json['for_qty'],
      isAccepted: json['is_accepted'],
      isRecovered: json['is_recovered'],
      contraName: json['contra_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_id': typeId,
      'pay_type': payType,
      'annul': annul,
      'wh_id': whId,
      'curdate': curdate,
      'curtime': curtime,
      'contra_id': contraId,
      'is_cur': isCur,
      'invert_cur': invertCur,
      'summ': summ,
      'summ_pla': summPla,
      'summ_cur': summCur,
      'summ_ret': summRet,
      'summ_real': summReal,
      'cur_rate': curRate,
      'notes': notes,
      'zatrat_id': zatratId,
      'zatrat_name': zatratName,
      'by_inv_id': byInvId,
      'my_uuid': myUuid,
      'user_id': userId,
      'for_cashback': forCashback ? 1 : 0,
      'for_qty': forQty,
      'is_accepted': isAccepted,
      'is_recovered': isRecovered,
      'contra_name': contraName,
    };
  }

  DocCash.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    typeId = map['type_id'] ?? 0;
    payType = map['pay_type'] ?? 0;
    annul = map['annul'] ?? 0;
    whId = map['wh_id'] ?? 0;
    curdate = map['curdate'] ?? "";
    curtime = map['curtime'] ?? "";
    contraId = map['contra_id'] ?? 0;
    isCur = map['is_cur'] ?? 0;
    invertCur = map['invert_cur'] ?? 0;
    summ = map['summ'] ?? 0;
    summPla = map['summ_pla'] ?? 0;
    summCur = map['summ_cur'] ?? 0;
    summRet = map['summ_ret'] ?? 0;
    summReal = map['summ_real'] ?? 0;
    curRate = map['cur_rate'] ?? 0;
    notes = map['notes'] ?? "";
    zatratId = map['zatrat_id'] ?? 0;
    zatratName = map['zatrat_name'] ?? "";
    byInvId = map['by_inv_id'] ?? 0;
    myUuid = map['my_uuid'] ?? "?";
    userId = map['user_id'] ?? 0;
    forCashback = map['for_cashback'] ?? 0;
    forQty = map['for_qty'] ?? 0;
    isAccepted = map['is_accepted'] ?? 0;
    isRecovered = map['is_recovered'] ?? 0;
    contraName = map['contra_name'] ?? "?";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type_id': typeId,
      'pay_type': payType,
      'annul': annul,
      'wh_id': whId,
      'curdate': curdate,
      'curtime': curtime,
      'contra_id': contraId,
      'is_cur': isCur,
      'invert_cur': invertCur,
      'summ': summ,
      'summ_pla': summPla,
      'summ_cur': summCur,
      'summ_ret': summRet,
      'summ_real': summReal,
      'cur_rate': curRate,
      'notes': notes,
      'zatrat_id': zatratId,
      'zatrat_name': zatratName,
      'by_inv_id': byInvId,
      'my_uuid': myUuid,
      'user_id': userId,
      'for_cashback': forCashback,
      'for_qty': forQty,
      'is_accepted': isAccepted,
      'is_recovered': isRecovered,
      'contra_name': contraName,
    };
  }
}
