import 'package:flutter/material.dart';

import '../models/show_model.dart';

class ShowCard extends StatelessWidget {
  final ShowModel show;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const ShowCard({
    super.key,
    required this.show,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (show.image != null)
                    Image.network(
                      show.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  else
                    _placeholder(),
                  if (onFavoriteTap != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Material(
                        color: Colors.black.withOpacity(0.72),
                        shape: const CircleBorder(),
                        child: IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: onFavoriteTap,
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: const Color(0xFFF44336),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        show.rating?.toStringAsFixed(1) ?? 'N/A',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF252525),
        child: const Center(
          child: Icon(Icons.live_tv, size: 48, color: Colors.white38),
        ),
      );
}
