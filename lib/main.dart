import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:praktikum2api/list_mhs_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(),
  ));
}

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus{notSignIn,signIn}
LoginStatus _loginStatus = LoginStatus.notSignIn;
String username, password;
final _key = new GlobalKey<FormState>();
bool _secureText = true;



class _LoginState extends State<Login>{

  showHide(){
  setState((){
    _secureText = !_secureText;
    });
  }

check(){
  final form = _key.currentState;
  if(form.validate()){
    form.save();
    login();
  }
}

login() async{
  final response = await http.post("http://apikelvin2019.000webhostapp.com/login.php",
  body: {
    "username" : username,
    "password" : password,
    }
  );

  final data = jsonDecode(response.body);
  int value = data['value'];
  String message = data['message'];
  String user = data['username'];
  String nama = data['nama'];
  String id = data['id'];


  if(value == 1){
    setState((){
      _loginStatus = LoginStatus.signIn;
      savePref(value, user, nama, id);
    });
    print(message);
  }
  else{
    print(message);
  }

}

savePref(int value, String username, String nama, String id) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState((){
    preferences.setInt("value", value);
    preferences.setString("nama", nama);
    preferences.setString("username", username);
    preferences.setString("id", id);
    preferences.commit();
  });
}

var value;
getPref() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState((){
    value = preferences.getInt("value");
    
    _loginStatus = value == 1? LoginStatus.signIn : LoginStatus.notSignIn;
  });
}

signOut() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState((){
    preferences.setInt("value", null);
    preferences.commit();
    _loginStatus = LoginStatus.notSignIn;
  });
}

@override
void initState(){
  super.initState();
  getPref();
}

  @override
  Widget build(BuildContext context){
    switch (_loginStatus){
      case LoginStatus.notSignIn:
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e){
                if(e.isEmpty){
                  return "Isi username terlebih dahulu";
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(
                labelText: "username",
              ),
            ),
            TextFormField(
              validator: (e){
                if(e.isEmpty){
                  return "Isi password terlebih dahulu";
                }
              },
              obscureText: _secureText,
              onSaved: (e) => password = e,
              decoration:  InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(_secureText?
                  Icons.visibility_off : Icons.visibility
                  )))),
            new Padding(padding: EdgeInsets.only(top: 8.0)),
            RaisedButton(
              onPressed: (){
                check();
              } ,
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("Logeeeein"),
              ),
          ],
        ),
      ),
    );
    break;
    case LoginStatus.signIn:
      return Dashboard(signOut);
      break;
    }
  }
}


class Dashboard extends StatefulWidget{
  final VoidCallback signOut;
  Dashboard(this.signOut);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>{

  signOut(){
    setState(() {
      widget.signOut();
    });
  }

  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      
    });
  }

  @override
  void initState(){
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), leading: Icon(Icons.home)),
      body: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Halo dashboard",style: new TextStyle(fontSize:20.0)),
            
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: new Container(
                margin: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ListMhsAPI();
                    }));
                  } ,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Daftar Mahasiswa")),
              )
            ),
            
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: new Container(
                margin: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  onPressed: (){
                    signOut();
                  } ,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Logout")),
              )
            ),

          ],
        ),
      ),
    );
  }
}