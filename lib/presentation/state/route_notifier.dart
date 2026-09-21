import 'package:flutter/foundation.dart';
import '../../application/usecases/search_routes_usecase.dart';
import '../../domain/entities/route_entity.dart';

class RouteNotifier extends ChangeNotifier {
  final SearchRoutesUseCase _searchRoutesUseCase;

  RouteNotifier(this._searchRoutesUseCase);

  String _from = '';
  String _to = '';
  String _transport = 'Автобус';
  List<RouteEntity> _results = [];
  bool _isSearched = false;

  String get from => _from;
  String get to => _to;
  String get transport => _transport;
  List<RouteEntity> get results => List.unmodifiable(_results);
  bool get isSearched => _isSearched;

  void setFrom(String value) {
    _from = value;
    notifyListeners();
  }

  void setTo(String value) {
    _to = value;
    notifyListeners();
  }

  void setTransport(String value) {
    _transport = value;
    notifyListeners();
  }

  Future<bool> search() async {
    if (_from.trim().isEmpty || _to.trim().isEmpty) return false;
    try {
      _results = await _searchRoutesUseCase.execute(
        from: _from,
        to: _to,
        transportType: _transport,
      );
      _isSearched = true;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void reset() {
    _from = '';
    _to = '';
    _transport = 'Автобус';
    _results = [];
    _isSearched = false;
    notifyListeners();
  }
}