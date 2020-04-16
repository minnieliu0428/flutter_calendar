import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/HomePage.dart';

import '../common/Constants.dart';
import '../models/User.dart';
import '../models/UserList.dart';
import '../services/UserService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _accountFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  UserList _users = new UserList();
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    _users.users = new List();
    _getRecords();

    _accountController.addListener(() {});
    _passwordController.addListener(() {});
  }

  void _getRecords() async {
    UserList userList = await UserService().loadRecords();
    setState(() {
      for (User service in userList.users) {
        this._users.users.add(service);
      }
    });
  }

  bool _checkLoginData() {
    User user = _users.users.firstWhere(
        (user) =>
            user.account.toLowerCase() == _accountController.text.toLowerCase(),
        orElse: () => null);
    bool result = user != null
        ? (user.password.compareTo(_passwordController.text) == 0
            ? true
            : false)
        : false;
    print("CheckLoginData: $result");
    return result;
  }

  String _getUserName() {
    User user = _users.users.firstWhere(
        (user) =>
            user.account.toLowerCase() == _accountController.text.toLowerCase(),
        orElse: () => null);
    print("UserName: ${user != null ? user.name : null}");
    return user != null ? user.name : null;
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {

    showErrorAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text(
          "OK",
          style: new TextStyle(
            color: appYellowColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text(
          "登入失敗",
          style: new TextStyle(
              color: appBlackGrayColor, fontWeight: FontWeight.bold),
        ),
        content:
            Text("帳號或密碼輸入錯誤", style: new TextStyle(color: appBlackGrayColor)),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    final logo = CircleAvatar(
      backgroundColor: appYellowColor,
      radius: bigRadius,
      child: appLogo,
    );

    final account_text = TextFormField(
      controller: _accountController,
      keyboardType: TextInputType.text,
      //鍵盤動作(一般在右下角，默認是完成)
      textInputAction: TextInputAction.next,
      focusNode: _accountFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _accountFocus, _passwordFocus);
      },
      maxLines: 1,
      maxLength: 16,
      //配合maxLength一起使用，在達到最大長度時是否阻止輸入
      maxLengthEnforced: true,
      autofocus: false,
      decoration: InputDecoration(
        labelText: accountText,
        labelStyle: TextStyle(
          color: appBlackGrayColor,
          fontSize: titleTextSize,
        ),
        prefixIcon: Icon(Icons.perm_identity),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
            color: appBlackGrayColor,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
            color: appBlackGrayColor,
            width: 3,
          ),
        ),
      ),
      style: TextStyle(
        color: appBlackGrayColor,
        fontSize: titleTextSize,
      ),
    );

    final password_text = TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocus,
      onFieldSubmitted: (term) {
        _checkLoginData()
            ? Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    HomePage(userName: _getUserName()))).then((value) {
          //清除輸入框
          _accountController.clear();
          _passwordController.clear();
        })
            : showErrorAlertDialog(context);
      },
      //是否隱藏輸入的文字
      obscureText: _isHidden,
      maxLines: 1,
      maxLength: 16,
      maxLengthEnforced: true,
      autofocus: false,
      decoration: InputDecoration(
        labelText: passwordText,
        labelStyle: TextStyle(
          color: appBlackGrayColor,
          fontSize: titleTextSize,
        ),
        //輸入框前方
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
            color: appBlackGrayColor,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(
            color: appBlackGrayColor,
            width: 3,
          ),
        ),
      ),
      style: TextStyle(
        color: appBlackGrayColor,
        fontSize: titleTextSize,
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _checkLoginData()
              ? Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          HomePage(userName: _getUserName()))).then((value) {
                  //清除輸入框
                  _accountController.clear();
                  _passwordController.clear();
                })
              : showErrorAlertDialog(context);
        },
        padding: EdgeInsets.all(12),
        color: appYellowColor,
        child:
            Text(loginButtonText, style: TextStyle(color: appBlackGrayColor)),
      ),
    );

    return Scaffold(
      backgroundColor: appPinkGrayColor,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: bigRadius),
            account_text,
            SizedBox(height: spaceHeight),
            password_text,
            SizedBox(height: buttonHeight),
            loginButton
          ],
        ),
      ),
    );
  }
}
