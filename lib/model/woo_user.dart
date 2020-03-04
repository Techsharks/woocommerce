class WooUser {
  int user_id;
  String user_login;
  String user_pass;
  String user_nicename;
  String first_name;
  String user_email;
  String user_url;
  String user_status;
  String display_name;
  Billing billing;
  Shipping shipping;
  String status;
  
  WooUser({this.user_id: null, this.first_name,this.user_login: null, this.user_pass: null, this.user_nicename: null, this.user_email: null, this.user_url: null, this.user_status: null, this.display_name: null, this.billing, this.shipping, this.status});

  factory WooUser.fromJson(Map<String, dynamic> _user, {Billing mBilling, Shipping mShipping}) {
    return WooUser(
      user_id: (_user['user_id'] != null) ? _user['user_id'] : 0,
      user_login: (_user['user_login'] != null) ? _user['user_login'] : null,
      user_pass: (_user['user_pass'] != null) ? _user['user_pass'] : null,
      user_nicename: (_user['user_nicename'] != null) ? _user['user_nicename'] : null,
      user_email: (_user['user_email'] != null) ? _user['user_email'] : null,
      user_url: (_user['user_url'] != null) ? _user['user_url'] : null,
      user_status: (_user['user_status'] != null) ? _user['user_status'] : null,
      display_name: (_user['display_name'] != null) ? _user['display_name'] : null,
      status: (_user['status'] != null) ? _user['status'] : null,
      billing: (mBilling != null) ? mBilling : Billing(),
      shipping: (mShipping != null) ? mShipping : Shipping(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': user_id,
      'user_login': user_login,
      'user_pass': user_pass,
      'user_nicename': user_nicename,
      'user_email': user_email,
      'user_url': user_url,
      'user_status': user_status,
      'display_name': display_name,
      'status':status,
    };
  }
}

// ---------------- Billing ----------------
class Billing {
  String first_name;
  String last_name;
  String company;
  String address_1;
  String address_2;
  String city;
  String state;
  String postcode;
  String country;
  String email;
  String phone;

  Billing({this.first_name, this.last_name, this.company, this.address_1, this.address_2, this.city, this.state, this.postcode, this.country, this.email, this.phone});

  factory Billing.fromJson(Map<String, dynamic> _billing) {
    return Billing(
      first_name: (_billing['first_name'] != null) ? _billing['first_name'] : null,
      last_name: (_billing['last_name'] != null) ? _billing['last_name'] : null,
      company: (_billing['company'] != null) ? _billing['company'] : null,
      address_1: (_billing['address_1'] != null) ? _billing['address_1'] : null,
      address_2: (_billing['address_2'] != null) ? _billing['address_2'] : null,
      city: (_billing['city'] != null) ? _billing['city'] : null,
      state: (_billing['state'] != null) ? _billing['state'] : null,
      postcode: (_billing['postcode'] != null) ? _billing['postcode'] : null,
      country: (_billing['country'] != null) ? _billing['country'] : null,
      email: (_billing['email'] != null) ? _billing['email'] : null,
      phone: (_billing['phone'] != null) ? _billing['phone'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_nam': this.first_name,
      'last_nam': this.last_name,
      'compan': this.company,
      'address_': this.address_1,
      'address_': this.address_2,
      'cit': this.city,
      'stat': this.state,
      'postcod': this.postcode,
      'countr': this.country,
      'emai': this.email,
      'phone': this.phone,
    };
  }
}

// ---------------- Shipping ----------------
class Shipping {
  String first_name;
  String last_name;
  String company;
  String address_1;
  String address_2;
  String city;
  String state;
  String postcode;
  String country;

  Shipping({this.first_name, this.last_name, this.company, this.address_1, this.address_2, this.city, this.state, this.postcode, this.country});

  factory Shipping.fromJson(Map<String, dynamic> _shipping) {
    return Shipping(
      first_name: (_shipping['first_name'] != null) ? _shipping['first_name'] : null,
      last_name: (_shipping['last_name'] != null) ? _shipping['last_name'] : null,
      company: (_shipping['company'] != null) ? _shipping['company'] : null,
      address_1: (_shipping['address_1'] != null) ? _shipping['address_1'] : null,
      address_2: (_shipping['address_2'] != null) ? _shipping['address_2'] : null,
      city: (_shipping['city'] != null) ? _shipping['city'] : null,
      state: (_shipping['state'] != null) ? _shipping['state'] : null,
      postcode: (_shipping['postcode'] != null) ? _shipping['postcode'] : null,
      country: (_shipping['country'] != null) ? _shipping['country'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_nam': this.first_name,
      'last_nam': this.last_name,
      'compan': this.company,
      'address_': this.address_1,
      'address_': this.address_2,
      'cit': this.city,
      'stat': this.state,
      'postcod': this.postcode,
      'country': this.country,
    };
  }
}
