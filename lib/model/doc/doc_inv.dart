class DocInv {
  late int id;
  late int typeId;
  late String curdate;
  late String curtime;
  late int contraId;
  late String notes;
  late double itogSumm;
  late double itogStdSumm;
  late double itogKg;
  late double itogCase;
  late double itogPc;
  late String curtime1;
  late int whId;
  late int isPrinted;
  late double xarajat;
  late String srok;
  late double skidka;
  late int priceIndex;
  late int toWhId;
  late bool hasError;
  late int reys;
  late double bnProcent;
  late String myUIID;
  late int isCur;
  late double curRate;
  late int docNum;
  late bool annul;
  late int userId;
  late int isRass;
  late String rassDate;

  DocInv({
    required this.id,
    required this.typeId,
    required this.curdate,
    required this.curtime,
    required this.contraId,
    required this.notes,
    required this.itogSumm,
    required this.itogStdSumm,
    required this.itogKg,
    required this.itogCase,
    required this.itogPc,
    required this.curtime1,
    required this.whId,
    required this.isPrinted,
    required this.xarajat,
    required this.srok,
    required this.skidka,
    required this.priceIndex,
    required this.toWhId,
    required this.hasError,
    required this.reys,
    required this.bnProcent,
    required this.myUIID,
    required this.isCur,
    required this.curRate,
    required this.docNum,
    required this.annul,
    required this.userId,
    required this.isRass,
    required this.rassDate,
  });

  factory DocInv.fromJson(Map<String, dynamic> json) {
    return DocInv(
      id: json['id'],
      typeId: json['type_id'],
      curdate: json['curdate'],
      curtime: json['curtime'],
      contraId: json['contra_id'],
      notes: json['notes'],
      itogSumm: json['itog_summ'],
      itogStdSumm: json['itog_std_summ'],
      itogKg: json['itog_kg'],
      itogCase: json['itog_case'],
      itogPc: json['itog_pc'],
      curtime1: json['curtime1'],
      whId: json['wh_id'],
      isPrinted: json['is_printed'],
      xarajat: json['xarajat'],
      srok: json['srok'],
      skidka: json['skidka'],
      priceIndex: json['price_index'],
      toWhId: json['to_wh_id'],
      hasError: json['has_error'],
      reys: json['reys'],
      bnProcent: json['bn_procent'],
      myUIID: json['my_uiid'],
      isCur: json['is_cur'],
      curRate: json['cur_rate'],
      docNum: json['doc_num'],
      annul: json['annul'],
      userId: json['user_id'],
      isRass: json['is_rass'],
      rassDate: json['rass_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_id': typeId,
      'curdate': curdate,
      'curtime': curtime,
      'contra_id': contraId,
      'notes': notes,
      'itog_summ': itogSumm,
      'itog_std_summ': itogStdSumm,
      'itog_kg': itogKg,
      'itog_case': itogCase,
      'itog_pc': itogPc,
      'curtime1': curtime1,
      'wh_id': whId,
      'is_printed': isPrinted,
      'xarajat': xarajat,
      'srok': srok,
      'skidka': skidka,
      'price_index': priceIndex,
      'to_wh_id': toWhId,
      'has_error': hasError,
      'reys': reys,
      'bn_procent': bnProcent,
      'my_uiid': myUIID,
      'is_cur': isCur,
      'cur_rate': curRate,
      'doc_num': docNum,
      'annul': annul,
      'user_id': userId,
      'is_rass': isRass,
      'rass_date': rassDate,
    };
  }

  DocInv.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    typeId = map['type_id'] ?? 0;
    curdate = map['curdate'] ?? "";
    curtime = map['curtime'] ?? "";
    contraId = map['contra_id'] ?? 0;
    notes = map['notes'] ?? "";
    itogSumm = map['itog_summ'] ?? 0;
    itogStdSumm = map['itog_std_summ'] ?? 0;
    itogKg = map['itog_kg'] ?? 0;
    itogCase = map['itog_case'] ?? 0;
    itogPc = map['itog_pc'] ?? 0;
    curtime1 = map['curtime1'] ?? "";
    whId = map['wh_id'] ?? 0;
    isPrinted = map['is_printed'] ?? 0;
    xarajat = map['xarajat'] ?? 0;
    srok = map['srok'] ?? "";
    skidka = map['skidka'] ?? 0;
    priceIndex = map['price_index'] ?? 0;
    toWhId = map['to_wh_id'] ?? 0;
    hasError = map['has_error'] ?? false;
    reys = map['reys'] ?? 0;
    bnProcent = map['bn_procent'] ?? 0;
    myUIID = map['my_uiid'] ?? "";
    isCur = map['is_cur'] ?? 0;
    curRate = map['cur_rate'] ?? 0;
    docNum = map['doc_num'] ?? 0;
    annul = map['annul'] ?? false;
    userId = map['user_id'] ?? 0;
    isRass = map['is_rass'] ?? 0;
    rassDate = map['rass_date'] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['type_id'] = typeId;
    map['curdate'] = curdate;
    map['curtime'] = curtime;
    map['contra_id'] = contraId;
    map['notes'] = notes;
    map['itog_summ'] = itogSumm;
    map['itog_std_summ'] = itogStdSumm;
    map['itog_kg'] = itogKg;
    map['itog_case'] = itogCase;
    map['itog_pc'] = itogPc;
    map['curtime1'] = curtime1;
    map['wh_id'] = whId;
    map['is_printed'] = isPrinted;
    map['xarajat'] = xarajat;
    map['srok'] = srok;
    map['skidka'] = skidka;
    map['price_index'] = priceIndex;
    map['to_wh_id'] = toWhId;
    map['has_error'] = hasError;
    map['reys'] = reys;
    map['bn_procent'] = bnProcent;
    map['my_uiid'] = myUIID;
    map['is_cur'] = isCur;
    map['cur_rate'] = curRate;
    map['doc_num'] = docNum;
    map['annul'] = annul;
    map['user_id'] = userId;
    map['is_rass'] = isRass;
    map['rass_date'] = rassDate;

    return map;
  }
}
