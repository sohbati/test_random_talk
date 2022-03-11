import 'package:flutter/material.dart';

import 'calling/OnThePhoneWidget.dart';

class ConnectNowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.blue],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.softLight,
      child: Container(
        height: 50.0,
        width: 250.0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(0.0))),
          child: InkWell(
            child: new Center(
              child: Row(
                children: <Widget>[
                  Expanded(
                    //flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/man_on_the_phone.png'),
                          // fit: BoxFit.fill,
                        ),
                        borderRadius: new BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Connect Now"),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnThePhoneWidget(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
