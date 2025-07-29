import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muhammadfirly_rest_api/controller/feed_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedPage extends StatelessWidget {
  FeedPage({super.key});

  final FeedController feedController = Get.put(FeedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Iklan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (feedController.advertisements.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada iklan terbaru saat ini.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: feedController.advertisements.length,
          itemBuilder: (context, index) {
            final ad = feedController.advertisements[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: ad.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      placeholder:
                          (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                      errorWidget:
                          (context, url, error) =>
                              const Icon(Icons.error, size: 50),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ad.title,
                          style: Get.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ad.description,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'Lihat Iklan',
                                'Anda tertarik dengan iklan ini!',
                                backgroundColor: Colors.black87,
                                colorText: Colors.white,
                              );
                            },
                            child: const Text(
                              'Lihat Selengkapnya',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}