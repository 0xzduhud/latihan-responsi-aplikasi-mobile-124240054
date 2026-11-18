
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../storage/favorite_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Favorit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: FavoriteService.listenable(),
        builder: (context, box, _) {
          final shows = FavoriteService.getAll();

          if (shows.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 60,
                    color: Colors.white38,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada TV Show favorit.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Tambahkan show dari halaman detail.',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            itemCount: shows.length,
            itemBuilder: (context, index) {
              final show = shows[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFF202020),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          showId: show.id,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Poster serial
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 58,
                            height: 68,
                            child: show.image != null
                                ? Image.network(
                                    show.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return _imagePlaceholder();
                                    },
                                  )
                                : _imagePlaceholder(),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Judul dan rating
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                show.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    show.rating?.toStringAsFixed(1) ??
                                        'N/A',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Tombol hapus
                        IconButton(
                          tooltip: 'Hapus favorit',
                          onPressed: () async {
                            await FavoriteService.toggle(show);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${show.name} dihapus dari favorit.',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor:
                                      const Color(0xFF303030),
                                ),
                              );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Color(0xFFF44336),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFF303030),
      child: const Center(
        child: Icon(
          Icons.live_tv,
          color: Colors.white38,
          size: 26,
        ),
      ),
    );
  }
}
