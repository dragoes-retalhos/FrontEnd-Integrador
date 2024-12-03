class LaboratoryItem {
  final int id;
  final String nameItem;
  final String brand;
  final String model;
  final String serialNumber;
  final String invoiceNumber;
  final List<int> entryDate;
  final List<int> nextCalibration;
  final String? status;

  LaboratoryItem({
    required this.id,
    required this.nameItem,
    required this.brand,
    required this.model,
    required this.serialNumber,
    required this.invoiceNumber,
    required this.entryDate,
    required this.nextCalibration,
    this.status,
  });

  factory LaboratoryItem.fromJson(Map<String, dynamic> json) {
    return LaboratoryItem(
      id: json['id'],
      nameItem: json['nameItem'],
      brand: json['brand'],
      model: json['model'],
      serialNumber: json['serialNumber'],
      invoiceNumber: json['invoiceNumber'],
      entryDate: List<int>.from(json['entryDate']),
      nextCalibration: List<int>.from(json['nextCalibration']),
      status: json['status'],
    );
  }
}