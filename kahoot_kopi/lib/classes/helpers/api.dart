import '../webservice/objects/product_object.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  // Send the soap request
  Future<http.Response> requestSoap(String envelope, String soapAction) async {
    // Production
    String url = 'https://webservice.tarp.dk/gBizz.svc?wsdl';
    // if (!kReleaseMode) {
    //   // Test
    //   url = 'https://webservicetest.tarp.dk/gbizz.svc';
    // }
    String host = url.substring(8, url.lastIndexOf('/'));  //'webservice.tarp.dk' or 'webservicetest.tarp.dk'

    // Create header with action
    final header = {
      'Accept-Encoding': 'gzip,deflate',
      'Content-Type': 'text/xml;charset=UTF-8',
      'SOAPAction': 'https://webservice.tarp.dk/IgBizz/$soapAction',
      'Host': host,
      'Connection': 'Keep-Alive',
      'User-Agent': 'Apache-HttpClient/4.5.5 (Java/16.0.1)',
    };
    // Post the soap request
    var temp = http.post(
      Uri.parse(url),
      headers: header,
      body: utf8.encode(envelope),
    );
    return temp;
  }

  // Wrap envelope with body and envelope tags
  String wrapEnvelope(String envelope, String soapAction) {
    return '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="https://webservice.tarp.dk" xmlns:tar="http://schemas.datacontract.org/2004/07/TarpWebservice" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
        <soapenv:Body>
          <web:$soapAction>
            $envelope
          </web:$soapAction>
        </soapenv:Body>
      </soapenv:Envelope>''';
  }

  // Get user login for the webservice
  String getEnvelopeLogin() {
    return '''<web:login>
                <tar:Password>od73hd5wh4</tar:Password>
                <tar:User>gbizz_handheld</tar:User>
                <tar:UserId>0</tar:UserId>
              </web:login>''';
  }
  // Creating, sending and returning a soap request, returns response
  Future<http.Response> sendRequest(Map<String, dynamic> items, String soapAction, bool isRequest) {
    final envelope = wrapEnvelope(makeEnvelope(items, isRequest), soapAction);
    return API().requestSoap(envelope, soapAction);
  }
}
