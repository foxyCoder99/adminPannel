class Account {
  final String? accountcode;
  final List<AccountData> accountdata;
  final List<Employer> employers;

  Account({
    required this.accountcode,
    required this.accountdata,
    required this.employers,
  });

  factory Account.fromJson(Map<String?, dynamic> json) {
    return Account(
      accountcode: json['accountcode'],
      accountdata: List<AccountData>.from(json['accountdata'].map((x) => AccountData.fromJson(x))),
      employers: List<Employer>.from(json['employers'].map((x) => Employer.fromJson(x))),
    );
  }
}

class AccountData {
  final int id;
  final String? accountcode;
  final String? accountname;
  final String? lastname;
  final String? worktitle;
  final List<RoleWithEmployer> rolewithemployer;
  final String? phonenumber;
  final String? workemail;
  final String? accountrole;
  final String? companydomainname;
  final String? naicscode;
  final String? companyname;
  final String? typeofcompany;
  final String? companycategory;
  final String? companyaddress;
  final String? companyphonenumber;
  final String? accountpaymentinfo;
  final String? fancyname;
  final bool status;

  AccountData({
    required this.id,
    required this.accountcode,
    required this.accountname,
    required this.lastname,
    required this.worktitle,
    required this.rolewithemployer,
    required this.phonenumber,
    required this.workemail,
    required this.accountrole,
    required this.companydomainname,
    required this.naicscode,
    required this.companyname,
    required this.typeofcompany,
    required this.companycategory,
    required this.companyaddress,
    required this.companyphonenumber,
    required this.accountpaymentinfo,
    required this.fancyname,
    required this.status,
  });

  factory AccountData.fromJson(Map<String?, dynamic> json) {
    return AccountData(
      id: json['id'],
      accountcode: json['accountcode'],
      accountname: json['accountname'],
      lastname: json['lastname'],
      worktitle: json['worktitle'],
      rolewithemployer: List<RoleWithEmployer>.from(json['rolewithemployer'].map((x) => RoleWithEmployer.fromJson(x))),
      phonenumber: json['phonenumber'],
      workemail: json['workemail'],
      accountrole: json['accountrole'],
      companydomainname: json['companydomainname'],
      naicscode: json['naicscode'],
      companyname: json['companyname'],
      typeofcompany: json['typeofcompany'],
      companycategory: json['companycategory'],
      companyaddress: json['companyaddress'],
      companyphonenumber: json['companyphonenumber'],
      accountpaymentinfo: json['accountpaymentinfo'],
      fancyname: json['fancyname'],
      status: json['status'],
    );
  }
}

class RoleWithEmployer {
  final String? rolecode;
  final String? rolename;
  final String? roletype;

  RoleWithEmployer({
    required this.rolecode,
    required this.rolename,
    required this.roletype,
  });

  factory RoleWithEmployer.fromJson(Map<String?, dynamic> json) {
    return RoleWithEmployer(
      rolecode: json['rolecode'],
      rolename: json['rolename'],
      roletype: json['roletype'],
    );
  }
}

class Employer {
  final String? companydomain;
  final String? companyname;
  final String? companyaddress;
  final String? companyphoneno;
  final String? companytypename;
  final String? companytype;
  final String? companycategory;
  final String? categoryname;
  final String? naicscode;
  final String? eincode;
  final List<Partner> partners;

  Employer({
    required this.companydomain,
    required this.companyname,
    required this.companyaddress,
    required this.companyphoneno,
    required this.companytypename,
    required this.companytype,
    required this.companycategory,
    required this.categoryname,
    required this.naicscode,
    required this.eincode,
    required this.partners,
  });

  factory Employer.fromJson(Map<String?, dynamic> json) {
    return Employer(
      companydomain: json['companydomain'],
      companyname: json['companyname'],
      companyaddress: json['companyaddress'],
      companyphoneno: json['companyphoneno'],
      companytypename: json['companytypename'],
      companytype: json['companytype'],
      companycategory: json['companycategory'],
      categoryname: json['categoryname'],
      naicscode: json['naicscode'],
      eincode: json['eincode'],
      partners: List<Partner>.from(json['partners'].map((x) => Partner.fromJson(x))),
    );
  }
}

class Partner {
  final PartnerData partnerdata;

  Partner({
    required this.partnerdata,
  });

  factory Partner.fromJson(Map<String?, dynamic> json) {
    return Partner(
      partnerdata: PartnerData.fromJson(json['partnerdata']),
    );
  }
}

class PartnerData {
  final String? companydomain;
  final String? companyname;
  final String? companyaddress;
  final String? companyphoneno;
  final String? companytypename;
  final String? companytype;
  final String? companycategory;
  final String? categoryname;
  final String? naicscode;
  final String? eincode;

  PartnerData({
    required this.companydomain,
    required this.companyname,
    required this.companyaddress,
    required this.companyphoneno,
    required this.companytypename,
    required this.companytype,
    required this.companycategory,
    required this.categoryname,
    required this.naicscode,
    required this.eincode,
  });

  factory PartnerData.fromJson(Map<String?, dynamic> json) {
    return PartnerData(
      companydomain: json['companydomain'],
      companyname: json['companyname'],
      companyaddress: json['companyaddress'],
      companyphoneno: json['companyphoneno'],
      companytypename: json['companytypename'],
      companytype: json['companytype'],
      companycategory: json['companycategory'],
      categoryname: json['categoryname'],
      naicscode: json['naicscode'],
      eincode: json['eincode'],
    );
  }
}
