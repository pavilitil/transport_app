import '../entities/route_entity.dart';

abstract class ITransportRepository {
  Future<List<RouteEntity>> getRoutes({
    required String from,
    required String to,
    required String transportType,
  });
}