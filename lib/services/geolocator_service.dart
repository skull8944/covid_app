import 'dart:async';
import 'package:geolocator/geolocator.dart';

class GeolocatorService {

  Stream<Position> getCurrentLocation() {
    return Geolocator.getPositionStream();
  }

  Future<Position> getInitialLocation() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  

  // ignore: cancel_subscriptions
  StreamSubscription<Position> positionStream = Geolocator.getPositionStream().listen((Position position) {
    print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
  });

  // ignore: cancel_subscriptions
  StreamSubscription<ServiceStatus> serviceStatusStream = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
    print(status);
  });

  //算距離：每兩個點算加上去，for(var i = 0; i < n -1; i++) { a[i] + a[i+1] }

    
}