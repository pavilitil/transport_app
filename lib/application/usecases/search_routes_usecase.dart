import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/i_transport_repository.dart';

class SearchRoutesUseCase {
  final ITransportRepository _repository;

  SearchRoutesUseCase(this._repository);

  Future<List<RouteEntity>> execute({
    required String from,
    required String to,
    required String transportType,
  }) async {
    if (from.trim().isEmpty || to.trim().isEmpty) {
      throw ArgumentError('Пункти відправлення та призначення обов\'язкові');
    }
    return await _repository.getRoutes(
      from: from,
      to: to,
      transportType: transportType,
    );
  }
}