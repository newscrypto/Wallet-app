import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool pinBalanceSwitch = false;
  SharedPreferences prefs;
  String pinSettingKey = "balancePin";
  String secretKey = "";
  bool isSecretVisible = false;

  @override
  void initState() {
    loadPinSetting();
    loadSecretKey();
    super.initState();
  }

  void loadPinSetting() async {
    bool pinSetting = false;
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(pinSettingKey)) {
      pinSetting = prefs.getBool(pinSettingKey);
    } else {
      pinSetting = false;
      setPinSetting(pinSetting);
    }
    setState(() {
      pinBalanceSwitch = pinSetting;
    });
  }

  void loadSecretKey() async {
    String secret = await getAccountSecret();
    setState(() {
      secretKey = secret;
    });
  }

  void setPinSetting(bool pinSetting) async {
    prefs.setBool(pinSettingKey, pinSetting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Confirm"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.transparent, Colors.black26])),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(children: [
        BackgroundStack(),
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("PIN lock"),
                  Switch(
                    value: pinBalanceSwitch,
                    onChanged: (value) {
                      setPinSetting(value);
                      setState(() {
                        pinBalanceSwitch = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
              const Divider(
                color: Colors.black54,
                height: 20,
                thickness: 1,
              ),
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "Change PIN",
                ),
              ),
              const Divider(
                color: Colors.black54,
                height: 20,
                thickness: 1,
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "Show secret key",
                  ),
                ),
                onTap: () {
                  setState(() {
                    isSecretVisible = !isSecretVisible;
                  });
                },
              ),
              Visibility(
                visible: isSecretVisible,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    secretKey,
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
