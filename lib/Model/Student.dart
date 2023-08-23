class Student{
  final String maSV;
  final String tenSV;

  Student({this.maSV = '', this.tenSV = ''});

  factory Student.fromJson(Map<String, dynamic> json){
    return Student(
        maSV: json["masv"],
        tenSV: json["tensv"]);
  }
}