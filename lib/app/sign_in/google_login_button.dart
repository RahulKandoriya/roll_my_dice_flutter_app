import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      onPressed: () {
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Tap to Enter',
                style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold, height: 1.3),
              ),
            )
          ],
        ),
      ),
    );
  }
}