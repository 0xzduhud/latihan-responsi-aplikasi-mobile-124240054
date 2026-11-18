import 'package:flutter/material.dart';

import '../models/show_model.dart';
import '../services/api_service.dart';
import '../widgets/show_card.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ShowModel>> _showsFuture;

  @override
  void initState() {
    super.initState();
    _showsFuture = ApiService.fetchShows();
  }

  Future<void> _refresh() async {
    final future = ApiService.fetchShows();
    setState(() => _showsFuture = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NontonSkuy!',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<List<ShowModel>>(
        future: _showsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF44336)),
            );
          }
          if (snapshot.hasError) {
            return _ErrorView(
                message: snapshot.error.toString(), onRetry: _refresh);
          }
          final shows = snapshot.data ?? [];
          if (shows.isEmpty) {
            return const Center(child: Text('Belum ada show.'));
          }
          return RefreshIndicator(
            color: const Color(0xFFF44336),
            onRefresh: _refresh,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              itemCount: shows.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.59,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => ShowCard(
                show: shows[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(showId: shows[index].id),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.white54),
            const SizedBox(height: 12),
            const Text('Tidak dapat memuat data TVMaze.',
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
