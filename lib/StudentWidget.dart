import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Model/Student.dart';




class Appdata extends StatefulWidget {
  const Appdata({super.key});

  @override
  State<Appdata> createState() => _AppdataState();
}

class _AppdataState extends State<Appdata> {
  List<Student> aptData = [];
  bool xoa = false;
  Future<List<Student>> _getData() async {
    final response = await http.get(Uri.parse("https://heavenlyspa.vn/ws/api.php?action=getall"));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result;
      return list.map((e) => Student.fromJson(e)).toList();
    } else {
      throw Exception("Fail to load");
    }
  }

  void _getAll() async {
    final c = await _getData();
    setState(() {
      aptData = c;
    });
  }



  Future<bool> _delete(Student sinhVien) async {
    final response = await http.get(
      Uri.parse(
          "https://heavenlyspa.vn/ws/api.php?action=delete&masv=${sinhVien.maSV}"),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Fail to load");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_getData());
  }

  @override
  Widget build(BuildContext context) {
    xoa = false;
    _getAll();

    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý sinh viên")),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.blue,
              ],
            )),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: aptData.length,
                itemBuilder: (context, index) {
                  final sinhVien = aptData[index];
                  return ListTile(
                    title: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(

                              height: 100,
                              width: 100,
                              child: ClipRRect(

                                child: Container(
                                    color: Colors.lightBlue,
                                    child: const Icon(Icons.person_outline)),
                                borderRadius: BorderRadius.all(Radius.circular(180)),

                              )
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mã sinh viên: ${sinhVien.maSV}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Tên: ${sinhVien.tenSV}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _delete(sinhVien);
                              setState(() {
                                xoa = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            child: const Text("Xoá"),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoSV(
                                sinhVien: sinhVien,
                              )),
                        );
                      },

                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoSV extends StatelessWidget {
  InfoSV({super.key, required this.sinhVien});
  final Student sinhVien;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Sinh Viên ${sinhVien!.tenSV.toString()}"),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.white,
              ],
            )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Spacer(),
              SizedBox(

                  height: 200,
                  width: 200,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(180)),
                      child: Container(
                          color: Colors.grey,
                          child: const Icon(Icons.person_outline))

                  )
              ),
              Spacer(),
              Text(
                "Mã sinh viên: ${sinhVien.maSV}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black,fontSize: 40),
              ),
              Spacer(),
              Text(
                "Tên: ${sinhVien.tenSV}",
                style: const TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black,fontSize: 35),
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
