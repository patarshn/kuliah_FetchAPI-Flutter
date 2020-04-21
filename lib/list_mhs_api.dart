import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListMhsAPI extends StatefulWidget{
  @override
  _ListMhsAPIState createState() => _ListMhsAPIState();
}

class _ListMhsAPIState extends State<ListMhsAPI>{
  final String url = 'https://apikelvin2019.000webhostapp.com/view.php';
  List data;

  Future<String> getData() async{
    var reqHeaders = {'accept' : 'application/json'};
    var res = await http.get(Uri.encodeFull(url), headers: reqHeaders);

    setState(() {
      var content = json.decode(res.body);
      data = content['result'];
    });
    return 'success';
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Mahasiswa'),
        backgroundColor: Colors.red,
      ),

      body: Container(
        margin: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context,int index){
            return Container(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person, size: 50,),
                      title: Text(data[index]['nama'], style: TextStyle(fontSize: 20.0),),
                      subtitle: Text(data[index]['npm'],style: TextStyle(fontSize: 14.0),),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}