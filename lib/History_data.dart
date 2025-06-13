// history_entry.dart
class HistoryEntry {
  final DateTime timestamp;
  final double speed;
  final int cadence;
  final String gaitStatus;

  HistoryEntry({
    required this.timestamp,
    required this.speed,
    required this.cadence,
    required this.gaitStatus,
  });
}
// sample_data.dart

final List<HistoryEntry> sampleHistoryEntries = [
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    speed: 3.5,
    cadence: 80,
    gaitStatus: 'Normal',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    speed: 4.0,
    cadence: 85,
    gaitStatus: 'exellent',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    speed: 2.8,
    cadence: 75,
    gaitStatus: 'poor',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    speed: 3.5,
    cadence: 80,
    gaitStatus: 'Normal',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    speed: 4.0,
    cadence: 85,
    gaitStatus: 'exellent',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    speed: 2.8,
    cadence: 75,
    gaitStatus: 'poor',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    speed: 3.5,
    cadence: 80,
    gaitStatus: 'Normal',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    speed: 4.0,
    cadence: 85,
    gaitStatus: 'exellent',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    speed: 2.8,
    cadence: 75,
    gaitStatus: 'poor',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    speed: 3.5,
    cadence: 80,
    gaitStatus: 'Normal',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    speed: 4.0,
    cadence: 85,
    gaitStatus: 'exellent',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    speed: 2.8,
    cadence: 75,
    gaitStatus: 'poor',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    speed: 3.5,
    cadence: 80,
    gaitStatus: 'Normal',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    speed: 4.0,
    cadence: 85,
    gaitStatus: 'exellent',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    speed: 2.8,
    cadence: 75,
    gaitStatus: 'poor',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    speed: 3.5,
    cadence: 80,
    gaitStatus: 'Normal',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    speed: 4.0,
    cadence: 85,
    gaitStatus: 'exellent',
  ),
  HistoryEntry(
    timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    speed: 2.8,
    cadence: 75,
    gaitStatus: 'poor',
  ),
];
