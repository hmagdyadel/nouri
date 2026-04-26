import 'dart:convert';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugPanel extends StatefulWidget {
  const DebugPanel({super.key});

  @override
  State<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends State<DebugPanel> {
  LogType? _selectedFilter;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          _buildFilterBar(),
          _buildSearchBar(),
          Expanded(child: _buildLogList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text(
                '🐛 Debug Logs',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 16),
              _NetworkStatusBanner(),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => AppLogger.clear(),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white),
                onPressed: () {
                  final String text = AppLogger.logs.map((LogEntry e) => '[${e.type.name.toUpperCase()}] ${e.message}').join('\n');
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logs copied!')));
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<LogEntry>>(
            stream: AppLogger.stream,
            initialData: AppLogger.logs,
            builder: (BuildContext context, AsyncSnapshot<List<LogEntry>> snapshot) {
              final List<LogEntry> logs = snapshot.data ?? <LogEntry>[];
              int api = 0, success = 0, error = 0, warning = 0, hive = 0, firebase = 0;
              for (final LogEntry e in logs) {
                switch (e.type) {
                  case LogType.api: api++; break;
                  case LogType.success: success++; break;
                  case LogType.error: error++; break;
                  case LogType.warning: warning++; break;
                  case LogType.hive: hive++; break;
                  case LogType.firebase: firebase++; break;
                  default: break;
                }
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _StatChip('API', api, Colors.blue),
                    _StatChip('✅', success, Colors.green),
                    _StatChip('❌', error, Colors.red),
                    _StatChip('⚠️', warning, Colors.orange),
                    _StatChip('Hive', hive, Colors.purple),
                    _StatChip('FB', firebase, Colors.yellow),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          _FilterChip(
            label: 'All',
            color: Colors.white,
            isSelected: _selectedFilter == null,
            onTap: () => setState(() => _selectedFilter = null),
          ),
          ...LogType.values.map((LogType type) {
            return _FilterChip(
              label: type.name.toUpperCase(),
              color: _LogColors.fg(type),
              isSelected: _selectedFilter == type,
              onTap: () => setState(() => _selectedFilter = type),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search logs...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (String value) => setState(() => _searchQuery = value.toLowerCase()),
      ),
    );
  }

  Widget _buildLogList() {
    return StreamBuilder<List<LogEntry>>(
      stream: AppLogger.stream,
      initialData: AppLogger.logs,
      builder: (BuildContext context, AsyncSnapshot<List<LogEntry>> snapshot) {
        final List<LogEntry> logs = snapshot.data ?? <LogEntry>[];
        final List<LogEntry> filtered = logs.where((LogEntry e) {
          if (_selectedFilter != null && e.type != _selectedFilter) return false;
          if (_searchQuery.isEmpty) return true;
          final String searchable = '${e.message} ${e.url ?? ""} ${e.data ?? ""} ${e.error ?? ""} ${e.responseBody ?? ""}'.toLowerCase();
          return searchable.contains(_searchQuery);
        }).toList();

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (BuildContext context, int index) => _LogTile(entry: filtered[index]),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(this.label, this.count, this.color);
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: <Widget>[
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.color, required this.isSelected, required this.onTap});
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _NetworkStatusBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (BuildContext context, AsyncSnapshot<List<ConnectivityResult>> snapshot) {
        final bool isOnline = snapshot.data?.any((ConnectivityResult r) => r != ConnectivityResult.none) ?? false;
        return Row(
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              isOnline ? 'ONLINE' : 'OFFLINE',
              style: TextStyle(color: isOnline ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}

class _LogTile extends StatefulWidget {
  const _LogTile({required this.entry});
  final LogEntry entry;

  @override
  State<_LogTile> createState() => _LogTileState();
}

class _LogTileState extends State<_LogTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final LogEntry e = widget.entry;
    final Color fg = _LogColors.fg(e.type);
    final Color bg = _LogColors.bg(e.type);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: fg, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: fg, borderRadius: BorderRadius.circular(4)),
                  child: Text(e.type.name.toUpperCase(), style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.message,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: _expanded ? null : 1,
                    overflow: _expanded ? null : TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${e.timestamp.hour}:${e.timestamp.minute.toString().padLeft(2, '0')}:${e.timestamp.second.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
            if (_expanded) ...<Widget>[
              const SizedBox(height: 8),
              if (e.url != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: <Widget>[
                      if (e.method != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(color: _LogColors.method(e.method!), borderRadius: BorderRadius.circular(4)),
                          child: Text(e.method!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      const SizedBox(width: 8),
                      Expanded(child: SelectableText(e.url!, style: const TextStyle(color: Colors.grey, fontSize: 11))),
                    ],
                  ),
                ),
              if (e.statusCode != null)
                Text('Status: ${e.statusCode}', style: TextStyle(color: _LogColors.status(e.statusCode!), fontSize: 11, fontWeight: FontWeight.bold)),
              if (e.duration != null)
                Text('Duration: ${e.duration!.inMilliseconds}ms', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              if (e.requestBody != null)
                _buildSection('Request:', e.requestBody!, Colors.cyan),
              if (e.responseBody != null)
                _buildSection('Response:', _prettyJson(e.responseBody!), Colors.green),
              if (e.data != null)
                _buildSection('Data:', _prettyJson(e.data!), Colors.blue),
              if (e.error != null)
                _buildSection('Error:', e.error!, Colors.red),
              if (e.stackTrace != null)
                _buildSection('Stack:', e.stackTrace!, Colors.orange),
              if (e.hiveBox != null)
                Text('Box: ${e.hiveBox}  Key: ${e.hiveKey}', style: const TextStyle(color: Colors.purpleAccent, fontSize: 10)),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _formatFullEntry(e)));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry copied!')));
                  },
                  child: const Text('Copy', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
            child: SelectableText(
              content,
              style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  String _prettyJson(String raw) {
    try {
      final dynamic decoded = jsonDecode(raw);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return raw;
    }
  }

  String _formatFullEntry(LogEntry e) {
    final StringBuffer b = StringBuffer();
    b.writeln('[${e.type.name.toUpperCase()}] ${e.timestamp.toIso8601String()}');
    b.writeln(e.message);
    if (e.url != null) b.writeln('URL: ${e.method} ${e.url}');
    if (e.statusCode != null) b.writeln('Status: ${e.statusCode} (${e.duration?.inMilliseconds}ms)');
    if (e.requestBody != null) b.writeln('Request: ${e.requestBody}');
    if (e.responseBody != null) b.writeln('Response: ${e.responseBody}');
    if (e.data != null) b.writeln('Data: ${e.data}');
    if (e.error != null) b.writeln('Error: ${e.error}');
    if (e.stackTrace != null) b.writeln('Stack: ${e.stackTrace}');
    return b.toString();
  }
}

class _LogColors {
  static Color fg(LogType type) {
    switch (type) {
      case LogType.api: return const Color(0xFF2196F3);
      case LogType.success: return const Color(0xFF4CAF50);
      case LogType.error: return const Color(0xFFF44336);
      case LogType.warning: return const Color(0xFFFF9800);
      case LogType.info: return const Color(0xFFFFFFFF);
      case LogType.hive: return const Color(0xFF9C27B0);
      case LogType.firebase: return const Color(0xFFFFC107);
      case LogType.navigation: return const Color(0xFF00BCD4);
      case LogType.cubit: return const Color(0xFF009688);
    }
  }

  static Color bg(LogType type) {
    switch (type) {
      case LogType.api: return const Color(0xFF0A1929);
      case LogType.success: return const Color(0xFF0A1F0A);
      case LogType.error: return const Color(0xFF1F0A0A);
      case LogType.warning: return const Color(0xFF1F1400);
      case LogType.info: return const Color(0xFF1A1A1A);
      case LogType.hive: return const Color(0xFF150A1F);
      case LogType.firebase: return const Color(0xFF1F1A00);
      case LogType.navigation: return const Color(0xFF001F24);
      case LogType.cubit: return const Color(0xFF001F1E);
    }
  }

  static Color method(String m) {
    switch (m.toUpperCase()) {
      case 'GET': return Colors.green;
      case 'POST': return Colors.blue;
      case 'PUT': return Colors.orange;
      case 'DELETE': return Colors.red;
      default: return Colors.grey;
    }
  }

  static Color status(int code) {
    if (code >= 200 && code < 300) return Colors.green;
    if (code >= 400 && code < 500) return Colors.orange;
    if (code >= 500) return Colors.red;
    return Colors.grey;
  }
}
