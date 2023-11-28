
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

Future<String> getHttpResponse({required Uri uri}) async {

  log(uri.toString());
  try {
    http.Response response = await http.get(uri);
    
    if (response.statusCode == 200) {
       return response.body;
    } else {
      throw response.statusCode.toString();
    }
  } catch (e) {
    throw e.toString();
  }
}

Set<String> getEmail(String data) {
  Set<String> result = <String>{};
  String regexString = r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@((?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)";
  RegExp regExp = RegExp(regexString);
  var matches = regExp.allMatches(data);

  log("Email Matches: ${matches.length}");       
  
  for (var m in matches) {
    if (EmailValidator.validate(m.group(0).toString())) {
      result.add(m.group(0).toString());
    }
  }
  return result;
}

Set<String> getInstagramLink(String data) {
  Set<String> result = <String>{};
  String regexString = r"instagram\.com[(?:%2F)|\/]([\w](?!.*?\.{2})[\w.]{1,28}[\w])";
  RegExp regExp = RegExp(regexString, multiLine: true);
  var matches = regExp.allMatches(data);

  log("IG Matches: ${matches.length}");       
  
  for (var m in matches) {
    result.add(m.group(1).toString());
  }
  return result;
}

String getPixnetUserInfo(String data) {
  data = data.replaceAll('\n', '');
  Set<String> result = <String>{};
  String regexString = r'<section class="profile-info__intro">.*?<\/section>';
  RegExp regExp = RegExp(regexString, multiLine:false);
  var matches = regExp.allMatches(data);

  log("Matches: ${matches.length}");       
  
  for (var m in matches) {
    log('match: ${m.group(0)}');
    result.add(m.group(0).toString());
  }
  return result.join('  ');
}

Future<Map<String, String>> getMorePixnetInfo(Uri uri) async {
  String rawData = await getHttpResponse(uri: uri);
  String data = getPixnetUserInfo(rawData);
  Set<String> email = getEmail(data);
  Set<String> ig = getInstagramLink(data);
  return {'email': email.isEmpty?'':email.elementAt(0), 'ig': ig.isEmpty?'':ig.elementAt(0)};
}

void main() async {
 
}