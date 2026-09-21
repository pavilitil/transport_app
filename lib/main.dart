import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'application/usecases/search_routes_usecase.dart';
import 'domain/repositories/i_transport_repository.dart';
import 'infrastructure/repositories/json_transport_repository.dart';
import 'presentation/state/route_notifier.dart';

void main() {
  final ITransportRepository repository = JsonTransportRepository();
  final searchRoutesUseCase = SearchRoutesUseCase(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RouteNotifier(searchRoutesUseCase),
        ),
      ],
      child: const TransportApp(),
    ),
  );
}

class TransportApp extends StatelessWidget {
  const TransportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Транспортний навігатор',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Транспортний навігатор'),
        actions: [
          Consumer<RouteNotifier>(
            builder: (context, notifier, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Badge(
                    label: Text(notifier.isSearched ? '${notifier.results.length}' : '0'),
                    child: const Icon(Icons.directions_bus),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            StatusHeaderWidget(),
            SizedBox(height: 16),
            InputFormWidget(),
            SizedBox(height: 16),
            RouteResultsWidget(),
          ],
        ),
      ),
    );
  }
}

class StatusHeaderWidget extends StatelessWidget {
  const StatusHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final routeNotifier = context.watch<RouteNotifier>();
    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Поточний запит:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Звідки: ${routeNotifier.from.isEmpty ? "—" : routeNotifier.from}'),
            Text('Куди: ${routeNotifier.to.isEmpty ? "—" : routeNotifier.to}'),
            Text('Транспорт: ${routeNotifier.transport}'),
          ],
        ),
      ),
    );
  }
}

class InputFormWidget extends StatefulWidget {
  const InputFormWidget({super.key});

  @override
  State<InputFormWidget> createState() => _InputFormWidgetState();
}

class _InputFormWidgetState extends State<InputFormWidget> {
  late final TextEditingController _fromCtrl;
  late final TextEditingController _toCtrl;

  @override
  void initState() {
    super.initState();
    final notifier = context.read<RouteNotifier>();
    _fromCtrl = TextEditingController(text: notifier.from);
    _toCtrl = TextEditingController(text: notifier.to);
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTransport = context.watch<RouteNotifier>().transport;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fromCtrl,
              decoration: const InputDecoration(labelText: 'Пункт відправлення'),
              onChanged: (val) => context.read<RouteNotifier>().setFrom(val),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _toCtrl,
              decoration: const InputDecoration(labelText: 'Пункт призначення'),
              onChanged: (val) => context.read<RouteNotifier>().setTo(val),
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Автобус', label: Text('Автобус')),
                ButtonSegment(value: 'Трамвай', label: Text('Трамвай')),
                ButtonSegment(value: 'Метро', label: Text('Метро')),
              ],
              selected: {currentTransport},
              onSelectionChanged: (selection) {
                context.read<RouteNotifier>().setTransport(selection.first);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final success = await context.read<RouteNotifier>().search();
                if (!success) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Заповніть усі поля!')),
                  );
                }
              },
              child: const Text('Знайти маршрут'),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteResultsWidget extends StatelessWidget {
  const RouteResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RouteNotifier, bool>(
      selector: (_, notifier) => notifier.isSearched,
      builder: (context, isSearched, child) {
        if (!isSearched) {
          return const Center(child: Text('Введіть пункти для пошуку'));
        }
        final results = context.read<RouteNotifier>().results;
        return Column(
          children: results.map((route) {
            return Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.route, color: Colors.green),
                title: Text(route.title),
                subtitle: Text('Час у дорозі: ${route.duration}'),
                trailing: Text(route.price, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}