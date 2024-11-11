import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_settings.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';

class SettingsData {
  static DicSettings? settingsData;

  static Future<void> getAllSettings(MySettings settings, BuildContext context) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_settings/get", settings);
    var data = json.decode(res);
    settingsData = DicSettings.fromMapObject(data);
    settings.saveAndNotify();
    // print(settingsData?.toJson());
  }

  static Future<void> updateData(BuildContext context, MySettings settings) async {
    String body = jsonEncode({
      "fio": settingsData?.fio,
      "admin_psw": settingsData?.adminPsw,
      "empty_psw": settingsData?.emptyPsw,
      "firm_name": settingsData?.firmName,
      "firm_address": settingsData?.firmAddress,
      "firm_phone": settingsData?.firmPhone,
      "curdate": Utils.myDateFormatFromStr1(Utils.formatYYYYMMdd, settingsData!.curdate),
      "limit_date": Utils.myDateFormatFromStr1(Utils.formatYYYYMMdd,settingsData!.limitDate),
      "auto_price": settingsData?.autoPrice,
      "auto_price_procent": settingsData?.autoPriceProcent,
      "main_sum": settingsData?.mainSum,
      "ost_by_party":settingsData?.ostByParty,
      "prod_price_fixed":settingsData?.prodPriceFixed,
      "prod_currency": settingsData?.prodCurrency,
      "use_plastik": settingsData?.usePlastik,
      "use_imei": settingsData?.useImei,
      "use_inv_currency": settingsData?.useInvCurrency,
      "use_case": settingsData?.useCase,
      "use_annul": settingsData?.useAnnul,
      "use_scanner": settingsData?.useScanner,
      "sys_photo_uuid": settingsData?.sysPhotoUuid,
      "inv_doc_num_type": settingsData?.invDocNumType,
      "only_client_id": settingsData?.onlyClientId,
      "imei_strict": settingsData?.imeiStrict,
      "dont_sell_below": settingsData?.dontSellBelow,
      "foyda_last_price": settingsData?.foydaLastPrice,
      "qty_00": settingsData?.qty00,
      "use_barcode": settingsData?.useBarcode,
      "def_client_id": settingsData?.defClientId,
      "front_price_index": settingsData?.frontPriceIndex,
      "auto_qty": settingsData?.autoQty,
      "show_lastprice": settingsData?.showLastprice,
      "hot_products": settingsData?.hotProducts,
      "last_price_main": settingsData?.lastPriceMain,
      "print_after_pay": settingsData?.printAfterPay,
      "front_multi_pay": settingsData?.frontMultiPay,
      "front_ost": settingsData?.frontOst,
      "touch_screen": settingsData?.touchScreen,
      "front_auto_pay": settingsData?.frontAutoPay,
      "lookup_cache": settingsData?.lookupCache,
      "summ_0": settingsData?.summ0,
      "round_05": settingsData?.round05,
      "smart_round": settingsData?.smartRound,
      "use_return_on_front": settingsData?.useReturnOnFront,
      "show_lastprice_in": settingsData?.showLastpriceIn,
      "prixod_sell_price": settingsData?.prixodSellPrice,
      "rate": settingsData?.rate,
      "red_dolg": settingsData?.redDolg,
      "use_log": settingsData?.useLog,
      "use_akt_inv": settingsData?.useAktInv,
      "max_price_index": settingsData?.maxPriceIndex,
      "use_cashback": settingsData?.useCashback,
      "show_prod_contra_id": settingsData?.showProdContraId,
      "seb_type": settingsData?.sebType,
      "use_rassrochka": settingsData?.useRassrochka,
      "use_square_meters": settingsData?.useSquareMeters,
      "rasxod_contra_id": settingsData?.rasxodContraId,
      "use_cash_accept": settingsData?.useCashAccept,
      "use_min_ost_qty": settingsData?.useMinOstQty,
      "use_trash": settingsData?.useTrash,
      "use_trash_recovery": settingsData?.useTrashRecovery,
      "use_filial": settingsData?.useFilial,
      "use_debcred_by_user": settingsData?.useDebcredByUser,
      "use_crm": settingsData?.useCrm,
      "use_hr": settingsData?.useHr,
      "main_filial_id": settingsData?.mainFilialId,
      "use_sms": settingsData?.useSms,
      "use_mark": settingsData?.useMark
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_settings/update", body, settings);
    print(res);
    settings.saveAndNotify();
  }
}
