import 'package:han4you/han-api/xedule/xedule-auth.dart';

class XeduleClient {
  String apiUrl;
  XeduleAuth auth;

  XeduleClient({this.apiUrl, this.auth});
  
  bool get authenticated => auth != null;
}
