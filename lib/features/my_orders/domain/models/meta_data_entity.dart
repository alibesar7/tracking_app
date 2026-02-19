class MetadataEntity {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;

  const MetadataEntity({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
  });
}
