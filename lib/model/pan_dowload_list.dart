// To parse this JSON data, do
//
//     final panDownloadList = panDownloadListFromJson(jsonString);

import 'dart:convert';

PanDownloadModel panDownloadListFromJson(String str) =>
    PanDownloadModel.fromJson(json.decode(str));

String panDownloadListToJson(PanDownloadModel data) =>
    json.encode(data.toJson());

class PanDownloadModel {
  PanDownloadModel({
    this.id,
    this.userid,
    this.panorgstn,
    this.contact,
    this.status,
    this.submitdate,
    this.reportreadydate,
    this.assessmentyear,
    this.username,
    this.email,
    this.bankname,
    this.state,
    this.mailstatus,
    this.clientname,
    this.mailid,
    this.returntype,
    this.pass,
    this.month,
    this.totalstatuscount,
    this.ifsc,
    this.itrpdfreport,
    this.accounttype,
    this.systemusername,
    this.branch,
  });

  int? id;
  int? userid;
  String? panorgstn;
  String? contact;
  String? status;
  int? submitdate;
  dynamic reportreadydate;
  String? assessmentyear;
  dynamic username;
  dynamic email;
  String? bankname;
  dynamic state;
  dynamic mailstatus;
  dynamic clientname;
  dynamic mailid;
  String? returntype;
  dynamic pass;
  dynamic month;
  dynamic totalstatuscount;
  String? ifsc;
  String? itrpdfreport;
  dynamic accounttype;
  String? systemusername;
  dynamic branch;

  factory PanDownloadModel.fromJson(Map<String, dynamic> json) =>
      PanDownloadModel(
        id: json["id"],
        userid: json["userid"],
        panorgstn: json["panorgstn"],
        contact: json["contact"],
        status: json["status"],
        submitdate: json["submitdate"],
        reportreadydate: json["reportreadydate"],
        assessmentyear: json["assessmentyear"],
        username: json["username"],
        email: json["email"],
        bankname: json["bankname"],
        state: json["state"],
        mailstatus: json["mailstatus"],
        clientname: json["clientname"],
        mailid: json["mailid"],
        returntype: json["returntype"],
        pass: json["pass"],
        month: json["month"],
        totalstatuscount: json["totalstatuscount"],
        ifsc: json["ifsc"],
        itrpdfreport: json["itrpdfreport"],
        accounttype: json["accounttype"],
        systemusername: json["systemusername"],
        branch: json["branch"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "panorgstn": panorgstn,
        "contact": contact,
        "status": status,
        "submitdate": submitdate,
        "reportreadydate": reportreadydate,
        "assessmentyear": assessmentyear,
        "username": username,
        "email": email,
        "bankname": bankname,
        "state": state,
        "mailstatus": mailstatus,
        "clientname": clientname,
        "mailid": mailid,
        "returntype": returntype,
        "pass": pass,
        "month": month,
        "totalstatuscount": totalstatuscount,
        "ifsc": ifsc,
        "itrpdfreport": itrpdfreport,
        "accounttype": accounttype,
        "systemusername": systemusername,
        "branch": branch,
      };
}
