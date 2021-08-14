class BankDetail {
  String? name;
  String? createDate;

  BankDetail({this.createDate, this.name});

  factory BankDetail.fromjson(Map<String, dynamic> json) {
    return BankDetail(
      name: json['bankname1'],
      createDate: json['createddate'],
    );
  }
}
