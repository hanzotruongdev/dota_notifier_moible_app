import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CInputField extends StatelessWidget {
  final IconData icon;
  final Widget centerWidget;
  final Widget switchButton;
  CInputField({this.icon, this.centerWidget, this.switchButton});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30,10,30,5),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Color(0xffeef0f3)))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Icon(icon, color: Color(0xff008ff4),size: 21,)
          ),
          SizedBox(width: 10),
          Expanded(
            child: centerWidget
          ),
          switchButton ?? Text('')
        ],
      ),
    );
  }
}


class MButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  MButton({@required this.text, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        elevation: 0.0,
        padding: EdgeInsets.symmetric(vertical: 17),
        child: Text(this.text ,style: TextStyle(fontSize: 16,color:  Colors.white),),
        color: Color(0xff008ff4),
        onPressed: callback,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
      ),
    );
  }
}

