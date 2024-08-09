import 'package:flutter/foundation.dart';
import 'package:myweatherapp/model/weatherModel.dart';
import 'package:myweatherapp/services/RemoteServices.dart';

class weatherProvider with ChangeNotifier {
  late List<WhetherDetails>? WhetherItems;
  bool isLoading = false;
  Remoteservices services = Remoteservices();

  double? currentTemperature;
  double? currentwind;
  int? currentHumidit;
  int? currentPressure;
  String? Corrrectweather;
  String? weatherDescription;

   getweatherData(context) async {
     isLoading = true;
     WhetherItems = await services.getWhetherDetails(context);
     isLoading = false;
     notifyListeners();
   }

  Future getWhetherDetails(context) async {
    isLoading = true;
    WhetherItems = await Remoteservices().getWhetherDetails(context);
    final now = DateTime.now();
    final today =
        DateTime(now.year, now.month, now.day); //current date in today

    var currentDayData = WhetherItems?.where((details) {
      final date = details.dtTxt;
      if (date != null) {
        
        final dataDate = DateTime(date.year, date.month,
            date.day); //data um data de date um oronn ayi verum ivede
        return dataDate == today;
      }
      return false;
    }).toList();

    if (currentDayData!.isNotEmpty) {
      currentTemperature = (currentDayData[0].main?.temp ?? 0.0) - 273.15;
      currentwind = currentDayData[0].wind?.speed;
      currentHumidit = currentDayData[0].main?.humidity;
      currentPressure = currentDayData[0].main?.pressure;
      Corrrectweather = currentDayData[0].weather?.first.main;
      weatherDescription = currentDayData[0].weather?.first.description;
     
    }
    isLoading = false;
    notifyListeners();
  }
}
