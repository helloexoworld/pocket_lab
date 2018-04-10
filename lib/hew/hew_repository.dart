import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pocket_lab/hew/models/gts.dart';

class HewRepository {
  static const String HEW_URL = "https://warp.pierrezemb.org/api/v0/exec";

  Future<List<Gts>> findAll() {
    return http.post(HEW_URL, body: '''
                @HELLOEXOWORLD/GETREADTOKEN 'token' STORE 
                [ \$token '~.*' {} ] FIND
                ''').then((response) {
      List content = json.decode(response.body)[0];
      return content.map((item) => Gts.fromMap(item)).toList() as List<Gts>;
    });
  }

  Future<Gts> fetch(String keplerId) {
    return http.post(HEW_URL, body: '''
        @HELLOEXOWORLD/GETREADTOKEN 'token' STORE 
        [
        \$token                         // Application authentication
        'sap.flux'                      // selector for classname
            { 'KEPLERID' '$keplerId' }  // Selector for labels
        '2009-05-02T00:56:10.000000Z'   // Start date
        '2013-05-11T12:02:06.000000Z'   // End date
        ] FETCH
        0 GET
        ''').then((response) {
      Map content = json.decode(response.body)[0];
      return Gts.fromMap(content);
    });
  }
}
