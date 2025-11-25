import 'package:flutter/material.dart';

class AppInfo {
  final String name;
  final String packageName;
  final IconData icon; // Using IconData for simulation, in real app this would be Uint8List?
  final Color color; // For simulation background

  AppInfo(this.name, this.packageName, this.icon, this.color);
}

class AppSelectionScreen extends StatefulWidget {
  final String title;
  final List<AppInfo> allApps;
  final List<AppInfo> selectedApps;

  const AppSelectionScreen({
    super.key,
    required this.title,
    required this.allApps,
    required this.selectedApps,
  });

  @override
  State<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  late List<AppInfo> _selectedApps;
  late List<AppInfo> _allApps;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedApps = List.from(widget.selectedApps);
    _allApps = widget.allApps;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? const Color(0xFF1A1625) : const Color(0xFFFAFAFC);

    final filteredApps = _allApps.where((app) {
      return app.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(widget.title, style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context, _selectedApps),
        ),
      ),
      body: Column(
        children: [
          if (_selectedApps.isNotEmpty) ...[
             Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected (${_selectedApps.length})',
                    style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedApps.clear();
                      });
                    },
                    child: const Text('Clear All', style: TextStyle(color: Colors.deepPurple)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _selectedApps.length,
                itemBuilder: (context, index) {
                  final app = _selectedApps[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: app.color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(app.icon, color: Colors.white, size: 28),
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedApps.remove(app);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 60,
                          child: Text(
                            app.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.grey.withOpacity(0.2)),
          ],

          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Applications',
                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredApps.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final app = filteredApps[index];
                final isSelected = _selectedApps.any((element) => element.packageName == app.packageName);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: app.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(app.icon, color: Colors.white, size: 20),
                  ),
                  title: Text(app.name, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
                  trailing: Checkbox(
                    value: isSelected,
                    activeColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedApps.add(app);
                        } else {
                          _selectedApps.removeWhere((element) => element.packageName == app.packageName);
                        }
                      });
                    },
                  ),
                  onTap: () {
                     setState(() {
                        if (!isSelected) {
                          _selectedApps.add(app);
                        } else {
                          _selectedApps.removeWhere((element) => element.packageName == app.packageName);
                        }
                      });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

