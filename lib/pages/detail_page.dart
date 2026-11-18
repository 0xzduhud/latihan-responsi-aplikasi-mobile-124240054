import 'package:flutter/material.dart';

import '../models/show_model.dart';
import '../services/api_service.dart';
import '../storage/favorite_service.dart';

class DetailPage extends StatefulWidget {
  final int showId;
  const DetailPage({super.key, required this.showId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<ShowModel> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = ApiService.fetchShowDetail(widget.showId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail'),
      ),
      body: FutureBuilder<ShowModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF44336)),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                  'Gagal memuat detail: ${snapshot.error ?? 'Data tidak tersedia'}'),
            );
          }
          final show = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: show.image != null
                    ? Image.network(
                        show.image!,
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
              const SizedBox(height: 18),
              Text(
                show.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text(show.rating?.toStringAsFixed(1) ?? 'Belum ada rating',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 18),
              // Tombol Tonton hanya elemen tampilan, karena tugas tidak meminta
              // integrasi pemutar video atau tautan streaming.
              SizedBox(
                height: 46,
                child: FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Tonton'),
                  style: FilledButton.styleFrom(
                    disabledBackgroundColor: const Color(0xFFF44336),
                    disabledForegroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text('Genre',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: show.genres.isEmpty
                    ? [const Chip(label: Text('Tidak tersedia'))]
                    : show.genres
                        .map((genre) => Chip(
                              label: Text(genre),
                              backgroundColor: const Color(0xFF252525),
                              side: BorderSide.none,
                            ))
                        .toList(),
              ),
              const SizedBox(height: 18),
              Text('Overview',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                show.summary.isEmpty
                    ? 'No summary available.'
                    : show.summary,
                style: const TextStyle(
                    height: 1.55, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder(
                valueListenable: FavoriteService.listenable(),
                builder: (context, box, _) {
                  final favorite = box.containsKey(show.id);
                  return OutlinedButton.icon(
                    onPressed: () async {
                      await FavoriteService.toggle(show);
                    },
                    icon: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFFF44336),
                    ),
                    label: Text(favorite
                        ? 'Hapus dari Favorit'
                        : 'Tambah ke Favorit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFF44336)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        height: 280,
        color: const Color(0xFF252525),
        child: const Center(
          child: Icon(Icons.live_tv, size: 72, color: Colors.white38),
        ),
      );
}
