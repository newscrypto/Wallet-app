import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newscrypto_wallet/models/Trnsaction.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';

import 'package:url_launcher/url_launcher.dart';

class TransactionDetails {
  final String key;
  final String value;

  TransactionDetails(this.key, this.value);
}

class TransactionHistoryContainer extends StatelessWidget {
  final WalletTransaction transaction;

  TransactionHistoryContainer({
    Key key,
    this.transaction,
  }) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomTransactionExpansionTile(
        title: "${transaction.amount} NWC",
        subtitle: '${transaction.addressFormat}',
        icon: transaction.icon,
        content: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async => await canLaunch(transaction.url)
                ? await launch(transaction.url)
                : throw 'Could not launch ${transaction.url}',
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                buildRow(
                    'Date: ', DateFormat.Hm().format(transaction.dateTime)),
                buildRow('Type: ', transaction.type),
                buildRow('ID: ', transaction.hashFormat),
              ]),
            )));
  }

  Padding buildRow(title, value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            value,
            textAlign: TextAlign.start,
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class CustomTransactionExpansionTile extends StatelessWidget {
  const CustomTransactionExpansionTile({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.content,
    @required this.icon,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget content;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.input,
        borderRadius: BorderRadius.circular(8.0),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 8),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Image.asset(
                    "assets/images/$icon.png",
                    color: Colors.white,
                    height: 28,
                    width: 28,
                  ),
                )
              : null,
          tilePadding: EdgeInsets.only(left: icon != null ? 0 : 16),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.more_horiz,
                size: 42, color: Palette.input.withOpacity(0.4)),
          ),
          childrenPadding: EdgeInsets.all(0),
          title: Container(
            transform: Matrix4.translationValues(0.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 8),
                ),
              ],
            ),
          ),
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Color(0xFF262626),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    )),
                child: content)
          ],
        ),
      ),
    );
  }
}
