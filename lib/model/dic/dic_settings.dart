class DicSettings {
  late int id;
  late String fio;
  late String adminPsw;
  late String emptyPsw;
  late String firmName;
  late String firmAddress;
  late String firmPhone;
  late String curdate;
  late String limitDate;
  late int  autoPrice;
  late int autoPriceProcent;
  late int mainSum;
  late int ostByParty;
  late int prodPriceFixed;
  late int prodCurrency;
  late int usePlastik;
  late int useImei;
  late int useInvCurrency;
  late int useCase;
  late int useAnnul;
  late int useScanner;
  late String sysPhotoUuid;
  late int invDocNumType;
  late int onlyClientId;
  late int imeiStrict;
  late int dontSellBelow;
  late int foydaLastPrice;
  late int qty00;
  late int useBarcode;
  late int defClientId;
  late int frontPriceIndex;
  late int autoQty;
  late int showLastprice;
  late int hotProducts;
  late int lastPriceMain;
  late int printAfterPay;
  late int frontMultiPay;
  late int frontOst;
  late int touchScreen;
  late int frontAutoPay;
  late int lookupCache;
  late int summ0;
  late int round05;
  late int smartRound;
  late int useReturnOnFront;
  late int showLastpriceIn;
  late int prixodSellPrice;
  late int rate;
  late int redDolg;
  late int useLog;
  late int useAktInv;
  late int maxPriceIndex;
  late int useCashback;
  late int showProdContraId;
  late int sebType;
  late int useRassrochka;
  late int useSquareMeters;
  late int rasxodContraId;
  late int useCashAccept;
  late int useMinOstQty;
  late int useTrash;
  late int useTrashRecovery;
  late int useFilial;
  late int useDebcredByUser;
  late int useCrm;
  late int useHr;
  late int mainFilialId;
  late int useSms;
  late int dontSelMinSeb;
  late String lastUpdateOstDate;
  late int useMark;

  DicSettings({
    required this.id,
    required this.fio,
    required this.adminPsw,
    required this.emptyPsw,
    required this.firmName,
    required this.firmAddress,
    required this.firmPhone,
    required this.curdate,
    required this.limitDate,
    required this.autoPrice,
    required this.autoPriceProcent,
    required this.mainSum,
    required this.ostByParty,
    required this.prodPriceFixed,
    required this.prodCurrency,
    required this.usePlastik,
    required this.useImei,
    required this.useInvCurrency,
    required this.useCase,
    required this.useAnnul,
    required this.useScanner,
    required this.sysPhotoUuid,
    required this.invDocNumType,
    required this.onlyClientId,
    required this.imeiStrict,
    required this.dontSellBelow,
    required this.foydaLastPrice,
    required this.qty00,
    required this.useBarcode,
    required this.defClientId,
    required this.frontPriceIndex,
    required this.autoQty,
    required this.showLastprice,
    required this.hotProducts,
    required this.lastPriceMain,
    required this.printAfterPay,
    required this.frontMultiPay,
    required this.frontOst,
    required this.touchScreen,
    required this.frontAutoPay,
    required this.lookupCache,
    required this.summ0,
    required this.round05,
    required this.smartRound,
    required this.useReturnOnFront,
    required this.showLastpriceIn,
    required this.prixodSellPrice,
    required this.rate,
    required this.redDolg,
    required this.useLog,
    required this.useAktInv,
    required this.maxPriceIndex,
    required this.useCashback,
    required this.showProdContraId,
    required this.sebType,
    required this.useRassrochka,
    required this.useSquareMeters,
    required this.rasxodContraId,
    required this.useCashAccept,
    required this.useMinOstQty,
    required this.useTrash,
    required this.useTrashRecovery,
    required this.useFilial,
    required this.useDebcredByUser,
    required this.useCrm,
    required this.useHr,
    required this.mainFilialId,
    required this.useSms,
    required this.dontSelMinSeb,
    required this.lastUpdateOstDate,
    required this.useMark,
  });

  factory DicSettings.fromJson(Map<String, dynamic> json) {
    return DicSettings(
      id: json['id'] ?? 0,
      fio: json['fio'] ?? "",
      adminPsw: json['admin_psw'] ?? "",
      emptyPsw: json['empty_psw'] ?? "",
      firmName: json['firm_name'] ?? "",
      firmAddress: json['firm_address'] ?? "",
      firmPhone: json['firm_phone'] ?? "",
      curdate: json['curdate'] ?? "",
      limitDate: json['limit_date'] ?? "",
      autoPrice: json['auto_price'] ?? 0,
      autoPriceProcent: json['auto_price_procent'] ?? 0,
      mainSum: json['main_sum'] ?? 0,
      ostByParty: json['ost_by_party'] ?? 0,
      prodPriceFixed: json['prod_price_fixed'] ?? 0,
      prodCurrency: json['prod_currency'] ?? 0,
      usePlastik: json['use_plastik'] ?? 0,
      useImei: json['use_imei'] ?? 0,
      useInvCurrency: json['use_inv_currency'] ?? 0,
      useCase: json['use_case'] ?? 0,
      useAnnul: json['use_annul'] ?? 0,
      useScanner: json['use_scanner'] ?? 0,
      sysPhotoUuid: json['sys_photo_uuid'] ?? "",
      invDocNumType: json['inv_doc_num_type'] ?? 0,
      onlyClientId: json['only_client_id'] ?? 0,
      imeiStrict: json['imei_strict'] ?? 0,
      dontSellBelow: json['dont_sell_below'] ?? 0,
      foydaLastPrice: json['foyda_last_price'] ?? 0,
      qty00: json['qty_00'] ?? 0,
      useBarcode: json['use_barcode'] ?? 0,
      defClientId: json['def_client_id'] ?? 0,
      frontPriceIndex: json['front_price_index'] ?? 0,
      autoQty: json['auto_qty'] ?? 0,
      showLastprice: json['show_lastprice'] ?? 0,
      hotProducts: json['hot_products'] ?? 0,
      lastPriceMain: json['last_price_main'] ?? 0,
      printAfterPay: json['print_after_pay'] ?? 0,
      frontMultiPay: json['front_multi_pay'] ?? 0,
      frontOst: json['front_ost'] ?? 0,
      touchScreen: json['touch_screen'] ?? 0,
      frontAutoPay: json['front_auto_pay'] ?? 0,
      lookupCache: json['lookup_cache'] ?? 0,
      summ0: json['summ_0'] ?? 0,
      round05: json['round_05'] ?? 0,
      smartRound: json['smart_round'] ?? 0,
      useReturnOnFront: json['use_return_on_front'] ?? 0,
      showLastpriceIn: json['show_lastprice_in'] ?? 0,
      prixodSellPrice: json['prixod_sell_price'] ?? 0,
      rate: json['rate'] ?? 0,
      redDolg: json['red_dolg'] ?? 0,
      useLog: json['use_log'] ?? 0,
      useAktInv: json['use_akt_inv'] ?? 0,
      maxPriceIndex: json['max_price_index'] ?? 0,
      useCashback: json['use_cashback'] ?? 0,
      showProdContraId: json['show_prod_contra_id'] ?? 0,
      sebType: json['seb_type'] ?? 0,
      useRassrochka: json['use_rassrochka'] ?? 0,
      useSquareMeters: json['use_square_meters'] ?? 0,
      rasxodContraId: json['rasxod_contra_id'] ?? 0,
      useCashAccept: json['use_cash_accept'] ?? 0,
      useMinOstQty: json['use_min_ost_qty'] ?? 0,
      useTrash: json['use_trash'] ?? 0,
      useTrashRecovery: json['use_trash_recovery'] ?? 0,
      useFilial: json['use_filial'] ?? 0,
      useDebcredByUser: json['use_debcred_by_user'] ?? 0,
      useCrm: json['use_crm'] ?? 0,
      useHr: json['use_hr'] ?? 0,
      mainFilialId: json['main_filial_id'] ?? "",
      useSms: json['use_sms'] ?? 0,
      dontSelMinSeb: json['dont_sel_min_seb'] ?? 0,
      lastUpdateOstDate: json['last_update_ost_date'] ?? 0,
      useMark: json['use_mark'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fio": fio,
        "admin_psw": adminPsw,
        "empty_psw": emptyPsw,
        "firm_name": firmName,
        "firm_address": firmAddress,
        "firm_phone": firmPhone,
        "curdate": curdate,
        "limit_date": limitDate,
        "auto_price": autoPrice,
        "auto_price_procent": autoPriceProcent,
        "main_sum": mainSum,
        "ost_by_party": ostByParty,
        "prod_price_fixed": prodPriceFixed,
        "prod_currency": prodCurrency,
        "use_plastik": usePlastik,
        "use_imei": useImei,
        "use_inv_currency": useInvCurrency,
        "use_case": useCase,
        "use_annul": useAnnul,
        "use_scanner": useScanner,
        "sys_photo_uuid": sysPhotoUuid,
        "inv_doc_num_type": invDocNumType,
        "only_client_id": onlyClientId,
        "imei_strict": imeiStrict,
        "dont_sell_below": dontSellBelow,
        "foyda_last_price": foydaLastPrice,
        "qty_00": qty00,
        "use_barcode": useBarcode,
        "def_client_id": defClientId,
        "front_price_index": frontPriceIndex,
        "auto_qty": autoQty,
        "show_lastprice": showLastprice,
        "hot_products": hotProducts,
        "last_price_main": lastPriceMain,
        "print_after_pay": printAfterPay,
        "front_multi_pay": frontMultiPay,
        "front_ost": frontOst,
        "touch_screen": touchScreen,
        "front_auto_pay": frontAutoPay,
        "lookup_cache": lookupCache,
        "summ_0": summ0,
        "round_05": round05,
        "smart_round": smartRound,
        "use_return_on_front": useReturnOnFront,
        "show_lastprice_in": showLastpriceIn,
        "prixod_sell_price": prixodSellPrice,
        "rate": rate,
        "red_dolg": redDolg,
        "use_log": useLog,
        "use_akt_inv": useAktInv,
        "max_price_index": maxPriceIndex,
        "use_cashback": useCashback,
        "show_prod_contra_id": showProdContraId,
        "seb_type": sebType,
        "use_rassrochka": useRassrochka,
        "use_square_meters": useSquareMeters,
        "rasxod_contra_id": rasxodContraId,
        "use_cash_accept": useCashAccept,
        "use_min_ost_qty": useMinOstQty,
        "use_trash": useTrash,
        "use_trash_recovery": useTrashRecovery,
        "use_filial": useFilial,
        "use_debcred_by_user": useDebcredByUser,
        "use_crm": useCrm,
        "use_hr": useHr,
        "main_filial_id": mainFilialId,
        "use_sms": useSms,
        "dont_sel_min_seb": dontSelMinSeb,
        "last_update_ost_date": lastUpdateOstDate,
        "use_mark": useMark,
      };

  DicSettings.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    fio = map['fio'] ?? "?";
    adminPsw = map['admin_psw'] ?? "";
    emptyPsw = map['empty_psw'] ?? "?";
    firmName = map['firm_name'] ?? "?";
    firmAddress = map['firm_address'] ?? "?";
    firmPhone = map['firm_phone'] ?? "?";
    curdate = map['curdate'] ?? "?";
    limitDate = map['limit_date'] ?? "?";
    autoPrice = map['auto_price'] ?? 0;
    autoPriceProcent = map['auto_price_procent'] ?? 0;
    mainSum = map['main_sum'] ?? 0;
    ostByParty = map['ost_by_party'] ?? 0;
    prodPriceFixed = map['prod_price_fixed'] ?? 0;
    prodCurrency = map['prod_currency'] ?? 0;
    usePlastik = map['use_plastik'] ?? 0;
    useImei = map['use_imei'] ?? 0;
    useInvCurrency = map['use_inv_currency'] ?? 0;
    useCase = map['use_case'] ?? 0;
    useAnnul = map['use_annul'] ?? 0;
    useScanner = map['use_scanner'] ?? 0;
    sysPhotoUuid = map['sys_photo_uuid'] ?? "";
    invDocNumType = map['inv_doc_num_type'] ?? 0;
    onlyClientId = map['only_client_id'] ?? 0;
    imeiStrict = map['imei_strict'] ?? 0;
    dontSellBelow = map['dont_sell_below'] ?? 0;
    foydaLastPrice = map['foyda_last_price'] ?? 0;
    qty00 = map['qty_00'] ?? 0;
    useBarcode = map['use_barcode'] ?? 0;
    defClientId = map['def_client_id'] ?? 0;
    frontPriceIndex = map['front_price_index'] ?? 0;
    autoQty = map['auto_qty'] ?? 0;
    showLastprice = map['show_lastprice'] ?? 0;
    hotProducts = map['hot_products'] ?? 0;
    lastPriceMain = map['last_price_main'] ?? 0;
    printAfterPay = map['print_after_pay'] ?? 0;
    frontMultiPay = map['front_multi_pay'] ?? 0;
    frontOst = map['front_ost'] ?? 0;
    touchScreen = map['touch_screen'] ?? 0;
    frontAutoPay = map['front_auto_pay'] ?? 0;
    lookupCache = map['lookup_cache'] ?? 0;
    summ0 = map['summ_0'] ?? 0;
    round05 = map['round_05'] ?? 0;
    smartRound = map['smart_round'] ?? 0;
    useReturnOnFront = map['use_return_on_front'] ?? 0;
    showLastpriceIn = map['show_lastprice_in'] ?? 0;
    prixodSellPrice = map['prixod_sell_price'] ?? 0;
    rate = map['rate'] ?? 0;
    redDolg = map['red_dolg'] ?? 0;
    useLog = map['use_log'] ?? 0;
    useAktInv = map['use_akt_inv'] ?? 0;
    maxPriceIndex = map['max_price_index'] ?? 0;
    useCashback = map['use_cashback'] ?? 0;
    showProdContraId = map['show_prod_contra_id'] ?? 0;
    sebType = map['seb_type'] ?? 0;
    useRassrochka = map['use_rassrochka'] ?? 0;
    useSquareMeters = map['use_square_meters'] ?? 0;
    rasxodContraId = map['rasxod_contra_id'] ?? 0;
    useCashAccept = map['use_cash_accept'] ?? 0;
    useMinOstQty = map['use_min_ost_qty'] ?? 0;
    useTrash = map['use_trash'] ?? 0;
    useTrashRecovery = map['use_trash_recovery'] ?? 0;
    useFilial = map['use_filial'] ?? 0;
    useDebcredByUser = map['use_debcred_by_user'] ?? 0;
    useCrm = map['use_crm'] ?? 0;
    useHr = map['use_hr'] ?? 0;
    mainFilialId = map['main_filial_id'] ?? 0;
    useSms = map['use_sms'] ?? 0;
    dontSelMinSeb = map['dont_sel_min_seb'] ?? 0;
    lastUpdateOstDate = map['last_update_ost_date'] ?? "";
    useMark = map['use_mark'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['fio'] = fio;
    map['admin_psw'] = adminPsw;
    map['empty_psw'] = emptyPsw;
    map['firm_name'] = firmName;
    map['firm_address'] = firmAddress;
    map['firm_phone'] = firmPhone;
    map['curdate'] = curdate;
    map['limit_date'] = limitDate;
    map['auto_price'] = autoPrice;
    map['auto_price_procent'] = autoPriceProcent;
    map['main_sum'] = mainSum;
    map['ost_by_party'] = ostByParty;
    map['prod_price_fixed'] = prodPriceFixed;
    map['prod_currency'] = prodCurrency;
    map['use_plastik'] = usePlastik;
    map['use_imei'] = useImei;
    map['use_inv_currency'] = useInvCurrency;
    map['use_case'] = useCase;
    map['use_annul'] = useAnnul;
    map['use_scanner'] = useScanner;
    map['sys_photo_uuid'] = sysPhotoUuid;
    map['inv_doc_num_type'] = invDocNumType;
    map['only_client_id'] = onlyClientId;
    map['imei_strict'] = imeiStrict;
    map['dont_sell_below'] = dontSellBelow;
    map['foyda_last_price'] = foydaLastPrice;
    map['qty00'] = qty00;
    map['use_barcode'] = useBarcode;
    map['def_client_id'] = defClientId;
    map['front_price_index'] = frontPriceIndex;
    map['auto_qty'] = autoQty;
    map['show_lastprice'] = showLastprice;
    map['hot_products'] = hotProducts;
    map['last_price_main'] = lastPriceMain;
    map['print_after_pay'] = printAfterPay;
    map['front_multi_pay'] = frontMultiPay;
    map['front_ost'] = frontOst;
    map['touch_screen'] = touchScreen;
    map['front_auto_pay'] = frontAutoPay;
    map['lookup_cache'] = lookupCache;
    map['summ0'] = summ0;
    map['round05'] = round05;
    map['smart_round'] = smartRound;
    map['use_return_on_front'] = useReturnOnFront;
    map['show_lastprice_in'] = showLastpriceIn;
    map['prixod_sell_price'] = prixodSellPrice;
    map['rate'] = rate;
    map['red_dolg'] = redDolg;
    map['use_log'] = useLog;
    map['use_akt_inv'] = useAktInv;
    map['max_price_index'] = maxPriceIndex;
    map['use_cashback'] = useCashback;
    map['show_prod_contra_id'] = showProdContraId;
    map['seb_type'] = sebType;
    map['use_rassrochka'] = useRassrochka;
    map['use_square_meters'] = useSquareMeters;
    map['rasxod_contra_id'] = rasxodContraId;
    map['use_cash_accept'] = useCashAccept;
    map['use_min_ost_qty'] = useMinOstQty;
    map['use_trash'] = useTrash;
    map['use_trash_recovery'] = useTrashRecovery;
    map['use_filial'] = useFilial;
    map['use_debcred_by_user'] = useDebcredByUser;
    map['use_crm'] = useCrm;
    map['use_hr'] = useHr;
    map['main_filial_id'] = mainFilialId;
    map['use_sms'] = useSms;
    map['dont_sel_min_seb'] = dontSelMinSeb;
    map['last_update_ost_date'] = lastUpdateOstDate;
    map['use_mark'] = useMark;

    return map;
  }
}
