import 'package:flutter/material.dart';

class AppUrl {
  static const DEV_BASE_URL = "https://www.bankverification.in/dev/";
  static const END_POINT = "https://www.bankverification.in/";

  static const GET_RECENT_DOWNLOAD = DEV_BASE_URL + "recentdownloadlist/";
  static const DASHBOARD = DEV_BASE_URL + "dashboard/";

  static const SEND_OTP = DEV_BASE_URL + "sendotp/";

  static const BANK_MANAGER_PAN_ADD =
      DEV_BASE_URL + "getpansearchforbankmanager/";
  static const DSA_PAN_ADD = DEV_BASE_URL + "getpansearchdsa/";
  static const BANK_LIST = DEV_BASE_URL + "banklist/";

  static const SEND_LINK_SMS = DEV_BASE_URL + "sendlinkbysms/";
}
