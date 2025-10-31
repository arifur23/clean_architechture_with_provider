

import 'package:data_connection_checker_tv/data_connection_checker.dart';

abstract class NetworkConnection {
  Future<bool>? get isNetworkConnected;
}

class NetworkConnectionImpl implements NetworkConnection{
  final DataConnectionChecker connectionChecker;

  NetworkConnectionImpl( this.connectionChecker);

  @override
  // TODO: implement isNetworkConnected
  Future<bool>? get isNetworkConnected => connectionChecker.hasConnection;

}