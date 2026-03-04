class MetadataEntity {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;
  final int cancelledCount;
  final int completedCount;

  const MetadataEntity({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
    this.cancelledCount = 0,
    this.completedCount = 0,
  });
}
