import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/screens/SecretKeyPage.dart';
import 'package:newscrypto_wallet/screens/changePin/ChnagePin.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/BackgroundSecondary.dart';
import 'package:newscrypto_wallet/widgets/get_toggle.dart';
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
    String secret = await AccountApi().getAccountSecret();
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
        BackgroundSecondaryStack(),
        Container(
            margin: EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      "PIN lock".toUpperCase(),
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  ZAnimatedToggle(
                    onToggleCallback: (value) {
                      setState(() {
                        pinBalanceSwitch = !pinBalanceSwitch;
                      });
                      setPinSetting(pinBalanceSwitch);
                    },
                    values: ["OFF", "ON"],
                    value: !pinBalanceSwitch,
                  ),
                  _getButton(
                    "Change PIN".toUpperCase(),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePinCodeScreen()),
                      );
                    },
                  ),
                  _getButton(
                    "Show secret key".toUpperCase(),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecretKeyPage(backButton: true,)),
                      );
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
            ))
      ]),
    );
  }

  Widget _getButton(String text, onPress) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Palette.input,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: MaterialButton(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPress,
      ),
    );
  }
}
