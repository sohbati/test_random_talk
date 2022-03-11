import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

class OnThePhoneWidget extends StatefulWidget {
  OnThePhoneWidget({Key? key}) : super(key: key);
  // final String title;
  @override
  _OnThePhoneWidget createState() => _OnThePhoneWidget();
}

class _OnThePhoneWidget extends State<OnThePhoneWidget> {
  // _OnThePhoneWidget({Key? key}) : super(key: key);

  bool _offer = false;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  final _localRenderer = new RTCVideoRenderer();
  final _remoteRenderer = new RTCVideoRenderer();
  final sdbControler = TextEditingController();

  @override
  dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    sdbControler.dispose();
    super.dispose();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  _getUserMedia() async {
    var mediaConstraints = // {'audio': true, 'video': true};
        {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = stream;
    // _localRenderer.mirror = true;
    return stream;
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServer": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    Map<String, dynamic> offerSdpConstraints = {
      "mandetory": {
        "offerToRecieveAudio": true,
        "offerToRecieveVideo": true,
      },
      "optional": []
    };
    _localStream = await _getUserMedia();
    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);
    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(
          json.encode(
            {
              'candidate': e.candidate.toString(),
              'sdpMid': e.sdpMid.toString(),
              'sdpMLineIndex': e.sdpMLineIndex.toString(),
            },
          ),
        );
      }
    };
    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream:' + stream.id);
      _remoteRenderer.srcObject = stream;
    };
    return pc;
  }

  @override
  void initState() {
    initRenderers();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
    super.initState();
  }

  // initState();

  void _createOffer() async {
    RTCSessionDescription description = (await _peerConnection!
        .createOffer({'offerToReceiveVideo': 1})) as RTCSessionDescription;
    var session = parse(description.sdp.toString());
    print(json.encode(session));
    _offer = true;
  }

  //----------------------
  @override
  Widget build(BuildContext context) {
    SizedBox videoRenderers() => SizedBox(
          height: 210,
          child: Row(
            children: [
              Flexible(
                child: Container(
                  key: Key('local'),
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  decoration: BoxDecoration(color: Colors.black),
                  child: RTCVideoView(_localRenderer),
                ),
              ),
              Flexible(
                child: Container(
                  key: Key('remote'),
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  decoration: BoxDecoration(color: Colors.black),
                  child: RTCVideoView(_remoteRenderer),
                ),
              ),
            ],
          ),
        );

    Row offerAndAnswerButtons() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: _createOffer,
              child: Text('offer'),
              color: Colors.amber,
            ),
            RaisedButton(
              onPressed: null, //_createAnswer)
              child: Text('answer'),
              color: Colors.amber,
            ),
          ],
        );

    Padding sdbCandidateTF() => Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: sdbControler,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            maxLength: TextField.noMaxLength,
          ),
        );

    Row sdbCandidateButtons() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: null, // _setRemoteDescription,
              child: Text('set remote description'),
              color: Colors.amber,
            ),
            RaisedButton(
              onPressed: null, //_setCandidate,
              child: Text('set candidate'),
              color: Colors.amber,
            ),
          ],
        );
    //------------------------
    return Scaffold(
      appBar: AppBar(
        title: Text('video'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          border: Border.all(
            color: Colors.black,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            videoRenderers(),
            offerAndAnswerButtons(),
            sdbCandidateTF(),
            sdbCandidateButtons(),
          ],
        ),
      ),
    );
  }
}
