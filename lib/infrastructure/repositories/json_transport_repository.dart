import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/i_transport_repository.dart';

class JsonTransportRepository implements ITransportRepository {
  @override
  Future<List<RouteEntity>> getRoutes({
    required String from,
    required String to,
    required String transportType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      RouteEntity(
        title: 'Прямий маршрут ($transportType)',
        duration: '25 хв',
        price: '15 грн',
        transportType: transportType,
      ),
      RouteEntity(
        title: 'Альтернативний маршрут',
        duration: '35 хв',
        price: '12 грн',
        transportType: transportType,
      ),
    ];
  }
}