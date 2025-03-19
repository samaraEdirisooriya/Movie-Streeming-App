class Moviezditail {
  String guid ="";
  String title ="";
  String lastName ="";



  Moviezditail(this.guid, this.title, );

  Moviezditail.fromJson(Map<String, dynamic> json) {
    guid = json['id'];
    title =   json['title'] != null ? json['title'] as String : 'Unknown Title';
    lastName = json['last_name'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = guid;
    data['first_name'] = title;
    data['last_name'] = lastName;
   
    return data;
  }
}