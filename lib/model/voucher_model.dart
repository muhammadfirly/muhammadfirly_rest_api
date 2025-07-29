class Voucher {
  final String id;
  final String title;
  final String description;
  final String discountAmount;
  final String expiryDate;
  final String imageUrl;
  bool isClaimed;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.discountAmount,
    required this.expiryDate,
    required this.imageUrl,
    this.isClaimed = false,
  });
}