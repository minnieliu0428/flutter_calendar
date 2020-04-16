import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/CalendarPage.dart';

import '../common/Constants.dart';
import '../common/ValueUtil.dart';
import '../models/Service.dart';
import '../models/ServiceList.dart';
import '../services/ServiceService.dart';

class HomePage extends StatefulWidget {
  final String userName;

  HomePage({Key key, this.userName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(userName);
}

class _HomePageState extends State<HomePage> {
  final String userName;

  _HomePageState(this.userName);

  ServiceList _records = new ServiceList();
  Widget _appBarTitle = new Text(homepageTitle);

  int costMoney = 0;
  int costHours = 0;
  int costMinutes = 0;
  String chooses = "";
  bool _isNextButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _records.services = new List();
    _getRecords();
  }

  void _chooseChange() {
    setState(() {
      chooses = "";
      costHours = 0;
      costMinutes = 0;
      costMoney = 0;

      for (Service p in _records.services) {
        if (p.isCheck) {
          if (chooses == "") {
            chooses += "目前選擇項目：${p.title}";
          } else {
            chooses += ", ${p.title}";
          }
          costHours += p.hour;
          costMinutes += p.minute;
          costMoney += p.cost;
        }
      }

      if (chooses == "") {
        _isNextButtonDisabled = true;
      } else {
        _isNextButtonDisabled = false;
      }
    });
  }

  void _getRecords() async {
    ServiceList records = await ServiceService().loadRecords();
    setState(() {
      for (Service service in records.services) {
        this._records.services.add(service);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildBar(BuildContext context) {
      return new AppBar(
          elevation: 0.1,
          backgroundColor: appYellowColor,
          centerTitle: true,
          title: _appBarTitle);
    }

    final serviceList = new Expanded(
        child: new ListView(
      children: _records.services.map((Service product) {
        return new ServiceItemList(product);
      }).toList(),
    ));

    var chooseServices = new Text(
      chooses,
      style: TextStyle(color: appBlackGrayColor, fontSize: bodyTextSize),
    );

    var totalCost = new Text(
      (ValueUtil.intIsNullOrZero(costMoney)
          ? ""
          : "總消費金額：$costMoney元"),
      style: TextStyle(color: appBlackGrayColor, fontSize: bodyTextSize),
    );

    var totalTime = new Text(
      (ValueUtil.intIsNullOrZero(costHours) &&
          ValueUtil.intIsNullOrZero(costMinutes)
          ? ""
          : "預估時長：$costHours小時$costMinutes分鐘"),
      style: TextStyle(color: appBlackGrayColor, fontSize: bodyTextSize),
    );

    var showBtn = new RaisedButton(
      onPressed: () {
         _chooseChange();
      },
      color: appYellowColor,
      child: new Text(
        '計算詳細',
        style: TextStyle(color: Colors.white, fontSize: buttonTextSize),
      ),
    );

    var nextBtn = new RaisedButton(
      onPressed: () {
        _chooseChange();
        _isNextButtonDisabled ? null : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CalendarPage(
                    money: costMoney,
                    hours: costHours,
                    minutes: costMinutes,
                    userName: userName,
                )));
      },
      color: _isNextButtonDisabled ? Colors.grey : appYellowColor,
      child: new Text(
        '下一步',
        style: TextStyle(color: Colors.white, fontSize: buttonTextSize),
      ),
    );

    final buttons = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[showBtn, nextBtn],
      ),
    );

    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: appPinkGrayColor,
      body: new Container(
        margin: new EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            serviceList,
            SizedBox(height: bigRadius),
            chooseServices,
            totalCost,
            totalTime,
            buttons
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

class ServiceItemList extends StatefulWidget {
  final Service product;

  ServiceItemList(Service product)
      : product = product,
        super(key: new ObjectKey(product));

  @override
  ServiceItemState createState() {
    return new ServiceItemState(product);
  }
}

class ServiceItemState extends State<ServiceItemList> {
  final Service product;

  ServiceItemState(this.product);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        onTap: null,
        title: new Row(
          children: <Widget>[
            new Expanded(
                child: new Text(
              product.title,
              style: TextStyle(
                  color: appBlackGrayColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )),
            new Expanded(
                child: new Text(
                  "${product.cost}元, " +
                  (ValueUtil.intIsNullOrZero(product.hour)
                      ? ""
                      : "${product.hour}小時") +
                  (ValueUtil.intIsNullOrZero(product.minute)
                      ? ""
                      : "${product.minute}分鐘"),
              style: TextStyle(color: appBlackGrayColor, fontSize: bodyTextSize),
            )),
            new Checkbox(
                value: product.isCheck,
                checkColor: Colors.white,
                activeColor: appYellowColor,
                hoverColor: Colors.white,
                focusColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    product.isCheck = value;
                  });
                })
          ],
        ));
  }
}
