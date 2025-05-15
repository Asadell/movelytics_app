import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/terminal.dart';

class TerminalProvider extends ChangeNotifier {
  List<Terminal> _terminals = [];
  bool _isLoading = true;
  String _error = '';

  List<Terminal> get terminals => _terminals;
  bool get isLoading => _isLoading;
  String get error => _error;

  TerminalProvider() {
    loadTerminals();
  }

  Future<void> loadTerminals() async {
    try {
      _isLoading = true;
      notifyListeners();

      // For demonstration, we'll use a hardcoded JSON string
      // In a real app, you would load this from an API or asset file
      final String jsonString = '''
[
  {
    "name": "Terminal Bungurasih",
    "location": "Kedungrejo",
    "latitude": -7.3503844,
    "longitude": 112.7256786,
    "description": "Terminal Bungurasih di Kedungrejo, Indonesia.",
    "city": "Kedungrejo",
    "estimated_passengers": 8500,
    "rating": 4.5,
    "type": "Terminal Purabaya"
  },
  {
    "name": "Terminal Baru Kambang Putih",
    "location": "Tuban",
    "latitude": -6.8600058,
    "longitude": 112.0285418,
    "description": "Terminal Baru Kambang Putih di Tuban, Indonesia.",
    "city": "Tuban",
    "estimated_passengers": 3200,
    "rating": 3.8,
    "type": "Terminal Baru Kambang Putih"
  },
  {
    "name": "Terminal Minak Koncar",
    "location": "Lumajang",
    "latitude": -8.074577,
    "longitude": 113.235583,
    "description": "Terminal Minak Koncar di Lumajang, Indonesia.",
    "city": "Lumajang",
    "estimated_passengers": 2100,
    "rating": 3.5,
    "type": "Terminal Minak Koncar"
  },
  {
    "name": "Terminal Tawang Alun",
    "location": "Jember",
    "latitude": -8.1984769,
    "longitude": 113.6300681,
    "description": "Terminal Tawang Alun di Jember, Indonesia.",
    "city": "Jember",
    "estimated_passengers": 4300,
    "rating": 4.0,
    "type": "Terminal Tawang Alun"
  },
  {
    "name": "Terminal Babat",
    "location": "Bedahan",
    "latitude": -7.0986083,
    "longitude": 112.190762,
    "description": "Terminal Babat di Bedahan, Indonesia.",
    "city": "Bedahan",
    "estimated_passengers": 1800,
    "rating": 3.2,
    "type": "Terminal Babat"
  },
  {
    "name": "Terminal Rajekwesi",
    "location": "Bojonegoro",
    "latitude": -7.1660882,
    "longitude": 111.8962136,
    "description": "Terminal Rajekwesi di Bojonegoro, Indonesia.",
    "city": "Bojonegoro",
    "estimated_passengers": 2500,
    "rating": 3.7,
    "type": "Terminal Rajekwesi"
  },
  {
    "name": "Terminal Gendingan",
    "location": "Ngawi",
    "latitude": -7.375661,
    "longitude": 111.2269554,
    "description": "Terminal Gendingan di Ngawi, Indonesia.",
    "city": "Ngawi",
    "estimated_passengers": 1500,
    "rating": 3.0,
    "type": "Terminal Gendingan"
  },
  {
    "name": "Terminal Bayuangga",
    "location": "Kota Probolinggo",
    "latitude": -7.7656867,
    "longitude": 113.175531,
    "description": "Terminal Bayuangga di Kota Probolinggo, Indonesia.",
    "city": "Kota Probolinggo",
    "estimated_passengers": 3800,
    "rating": 3.9,
    "type": "Terminal Bayuangga"
  },
  {
    "name": "Terminal Tipe B Kepuhsari",
    "location": "Jombang",
    "latitude": -7.533184,
    "longitude": 112.2606544,
    "description": "Terminal Tipe B Kepuhsari di Jombang, Indonesia.",
    "city": "Jombang",
    "estimated_passengers": 2800,
    "rating": 3.6,
    "type": "Terminal Tipe B Kepuhsari"
  },
  {
    "name": "Terminal Kertajaya",
    "location": "Kota Mojokerto",
    "latitude": -7.4905548,
    "longitude": 112.4485985,
    "description": "Terminal Kertajaya di Kota Mojokerto, Indonesia.",
    "city": "Kota Mojokerto",
    "estimated_passengers": 3100,
    "rating": 3.8,
    "type": "Terminal Kertajaya"
  },
  {
    "name": "Terminal Kertonegoro",
    "location": "Ngawi",
    "latitude": -7.4060287,
    "longitude": 111.4177864,
    "description": "Terminal Kertonegoro di Ngawi, Indonesia.",
    "city": "Ngawi",
    "estimated_passengers": 1700,
    "rating": 3.3,
    "type": "Terminal Kertonegoro"
  },
  {
    "name": "Terminal Tamanan",
    "location": "Kota Kediri",
    "latitude": -7.8284354,
    "longitude": 111.983848,
    "description": "Terminal Tamanan di Kota Kediri, Indonesia.",
    "city": "Kota Kediri",
    "estimated_passengers": 4100,
    "rating": 4.0,
    "type": "Terminal Tamanan"
  },
  {
    "name": "Terminal Hamid Rusdi",
    "location": "Kota Malang",
    "latitude": -8.0255663,
    "longitude": 112.6429881,
    "description": "Terminal Hamid Rusdi di Kota Malang, Indonesia.",
    "city": "Kota Malang",
    "estimated_passengers": 5200,
    "rating": 4.2,
    "type": "Terminal Hamid Rusdi"
  },
  {
    "name": "Terminal Landungsari",
    "location": "Kota Malang",
    "latitude": -7.9240658,
    "longitude": 112.5988543,
    "description": "Terminal Landungsari di Kota Malang, Indonesia.",
    "city": "Kota Malang",
    "estimated_passengers": 4800,
    "rating": 4.1,
    "type": "Terminal Landungsari"
  },
  {
    "name": "Terminal Osowilangun",
    "location": "Surabaya",
    "latitude": -7.2183207,
    "longitude": 112.6515133,
    "description": "Terminal Osowilangun di Surabaya, Indonesia.",
    "city": "Surabaya",
    "estimated_passengers": 6200,
    "rating": 4.3,
    "type": "Terminal Tambak Osowilangon"
  }
]
      ''';

      final List<dynamic> jsonData = json.decode(jsonString);
      _terminals = jsonData.map((item) => Terminal.fromJson(item)).toList();
      _isLoading = false;
      _error = '';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load terminals: $e';
      notifyListeners();
    }
  }

  // Get terminals by density
  List<Terminal> getTerminalsByDensity(String density) {
    return _terminals.where((terminal) => terminal.density == density).toList();
  }

  // Get terminals by city
  List<Terminal> getTerminalsByCity(String city) {
    return _terminals.where((terminal) => terminal.city == city).toList();
  }
}
