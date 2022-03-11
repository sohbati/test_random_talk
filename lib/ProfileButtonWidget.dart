import 'package:flutter/material.dart';

Widget ProfileButtonWidget = ShaderMask(
  shaderCallback: (rect) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.transparent],
    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
  },
  blendMode: BlendMode.softLight,
  child: Container(
    height: 130.0,
    width: 250.0,
    color: Colors.transparent,
    child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: new Center(
            child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 1.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage('assets/images/woman_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: new BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text("My Profile"),
              ),
            )
          ],
        ))),
  ),
);
