import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Statistics.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newscrypto_wallet/screens/ConfirmSend/ConfirmSend.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/PrimaryButton.dart';
import 'package:newscrypto_wallet/widgets/SecondaryButton.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Send extends StatefulWidget {
  final Statistics statistic;
  final UserBalance balance;

  const Send({Key key, this.statistic, this.balance}) : super(key: key);

  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> with TickerProviderStateMixin {
  String copyText = "Tap to copy";
  Color copyTextColor = Colors.white;
  TextEditingController _textController;
  AnimationController _controller;
  Animation<double> _animation;
  String nwcAddress = "Tap to paste address!";
  String nwcMemo = "";
  bool nwcAddressPasted = false;
  bool nwcMemoPasted = false;
  bool qrReader = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;
  bool invalidAddress = false;
  double sendNWCAmount = 0;
  double sendUSDAmount = 0;

  @override
  void initState() {
    print(widget.statistic.last);
    _textController = new TextEditingController(text: "$sendNWCAmount");
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = _controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Send"),
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
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            BackgroundStack(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new AnimatedBuilder(
                                  animation: _animation,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Text(
                                      _animation.value.toStringAsFixed(2) +
                                          " USD",
                                      textAlign: TextAlign.right,
                                    );
                                  },
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: _textController,
                                        textAlign: TextAlign.right,
                                        onChanged: (value) {
                                          setState(() {
                                            sendNWCAmount = double.parse(value);
                                            sendUSDAmount =
                                                double.parse(value) *
                                                    widget.statistic.last;
                                            _animation = new Tween<double>(
                                              begin: _animation.value,
                                              end: double.parse(value) *
                                                  widget.statistic.last,
                                            ).animate(new CurvedAnimation(
                                              curve: Curves.fastOutSlowIn,
                                              parent: _controller,
                                            ));
                                            _controller.forward(from: 0.0);
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      " NWC",
                                      textAlign: TextAlign.right,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    PrimaryButton(
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(top: 10),
                      title: "All",
                      fontsize: 18,
                      padding: EdgeInsets.all(10),
                      function: () {
                        _textController.text = widget.balance.nwc.toString();
                        sendNWCAmount =
                            double.parse(widget.balance.nwc.toString());
                        sendUSDAmount =
                            double.parse(widget.balance.nwc.toString()) *
                                widget.statistic.last;
                        _animation = new Tween<double>(
                                begin: _animation.value, end: sendUSDAmount)
                            .animate(new CurvedAnimation(
                          curve: Curves.fastOutSlowIn,
                          parent: _controller,
                        ));
                        _controller.forward(from: 0.0);
                      },
                    ),
                    Container(
                      child: Text("Address:"),
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              ClipboardData clipboard =
                                  await Clipboard.getData(Clipboard.kTextPlain);
                              bool validAddress =
                                  await  AccountApi().checkAddress(clipboard.text);
                              print(validAddress);
                              if (validAddress) {
                                setState(() {
                                  nwcAddress = clipboard.text;
                                  nwcAddressPasted = true;
                                  invalidAddress = false;
                                });
                              } else
                                setState(() {
                                  invalidAddress = true;
                                });
                            },
                            child: nwcAddressPasted
                                ? Text.rich(
                                    TextSpan(
                                      text: nwcAddress.substring(0, 7),
                                      // default text style
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '...',
                                        ),
                                        TextSpan(
                                          text: nwcAddress
                                              .substring(nwcAddress.length - 7),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(nwcAddress),
                          ),
                          IconButton(
                              icon:
                                  new Icon(MdiIcons.fromString('qrcode-scan')),
                              onPressed: () {
                                setState(() {
                                  qrReader = true;
                                });
                              })
                        ],
                      ),
                    ),
                    if (invalidAddress)
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text("Pasted address does not support NWC!"),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        "Memo:",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 30),
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  nwcMemo = value;
                                });
                              },
                            ),
                          ],
                        )),
                    SecondaryButton(
                      title: "Next",
                      width: MediaQuery.of(context).size.width * 0.8,
                      fontsize: 20,
                      margin: EdgeInsets.only(top: 5, bottom: 20),
                      color: Palette.primaryButtonDefault,
                      function: () {
                        if (nwcAddressPasted)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmSend(
                                      sendAmountNWC: sendNWCAmount,
                                      sendAmountUSD: sendUSDAmount,
                                      sendToAddress: nwcAddress,
                                      sendToMemo: nwcMemo,
                                    )),
                          );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (qrReader)
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            setState(() {
                              qrReader = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        nwcAddress = scanData;
        qrReader = false;
        nwcAddressPasted = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    controller?.dispose();
    super.dispose();
  }
}
