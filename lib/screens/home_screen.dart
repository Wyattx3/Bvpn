import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'settings_screen.dart';
import 'location_selection_screen.dart';
import 'rewards_screen.dart';
import '../user_manager.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConnected = false;
  bool isConnecting = false;
  String currentLocation = 'US - San Jose';
  String currentFlag = '🇺🇸';
  
  final UserManager _userManager = UserManager();

  @override
  void initState() {
    super.initState();
    _userManager.onTimeExpired = () {
      if (mounted && isConnected) {
        setState(() {
          isConnected = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Time expired! Watch ads to reconnect.')),
        );
      }
    };
  }

  @override
  void dispose() {
    _userManager.stopTimer();
    super.dispose();
  }

  void _toggleConnection() {
    if (isConnecting) return;

    if (isConnected) {
      _userManager.stopTimer();
      setState(() {
        isConnected = false;
      });
    } else {
      if (_userManager.remainingSeconds.value > 0) {
        _simulateConnection();
      } else {
        _showAdDialog();
      }
    }
  }

  void _simulateConnection() {
    setState(() {
      isConnecting = true;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isConnecting = false;
          isConnected = true;
        });
        _userManager.startTimer();
      }
    });
  }

  void _showAdDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_off, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'Out of Time!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Watch a short ad to get 2 hours of VPN time and earn 30 MMK.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _simulateAdWatch();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Watch Ad'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _simulateAdWatch() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Watching Ad...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
        _userManager.watchAdReward();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Success! +2 Hours Added, +30 MMK Earned')),
        );

        _simulateConnection();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isConnecting ? 'Connecting...' : (isConnected ? 'Connected' : 'Not Connected'),
          style: TextStyle(
            color: isConnecting ? Colors.orange : (isConnected ? Colors.green : textColor),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.deepPurple),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RewardsScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.settings, color: textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive calculations
          final double screenHeight = constraints.maxHeight;
          final double buttonSize = screenHeight * 0.25; // Button is 25% of screen height
          final double innerButtonSize = buttonSize * 0.75; 
          final double bottomPadding = screenHeight * 0.05; // 5% padding at bottom

          return ValueListenableBuilder<int>(
            valueListenable: _userManager.remainingSeconds,
            builder: (context, remainingSeconds, child) {
              return Column(
                children: [
                  // Top Section: Timer (Flexible space)
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: remainingSeconds > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: isDark ? Border.all(color: Colors.deepPurple.withOpacity(0.3)) : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.timer, size: 16, color: Colors.deepPurple),
                                const SizedBox(width: 8),
                                Text(
                                  _userManager.formattedTime,
                                  style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFeatures: [FontFeature.tabularFigures()],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(), 
                    ),
                  ),

                  // Middle Section: Power Button & Text (Largest Space)
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Power Button
                        GestureDetector(
                          onTap: _toggleConnection,
                          child: Container(
                            width: buttonSize,
                            height: buttonSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isConnected 
                                  ? Colors.green.withOpacity(0.1) 
                                  : (isConnecting ? Colors.orange.withOpacity(0.1) : (isDark ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.1))),
                              boxShadow: [
                                BoxShadow(
                                  color: isConnected 
                                      ? Colors.green.withOpacity(0.2) 
                                      : (isConnecting ? Colors.orange.withOpacity(0.2) : (isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2))),
                                  blurRadius: 20,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: innerButtonSize,
                                height: innerButtonSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: isConnecting 
                                    ? const Padding(
                                        padding: EdgeInsets.all(30.0),
                                        child: CircularProgressIndicator(strokeWidth: 3, color: Colors.orange),
                                      )
                                    : Icon(
                                        CupertinoIcons.power,
                                        size: innerButtonSize * 0.4,
                                        color: isConnected ? Colors.green : (isDark ? Colors.grey.shade400 : Colors.grey),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.04), // Dynamic spacing

                        // Status Text
                        Text(
                          isConnecting 
                              ? 'Establishing Connection...' 
                              : (isConnected ? 'VPN is On' : 'Tap to Connect'),
                          style: TextStyle(
                            color: isConnecting ? Colors.orange : (isConnected ? Colors.green : subTextColor),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Section: Location Selector
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(
                        left: 20, 
                        right: 20, 
                        bottom: bottomPadding
                      ),
                      child: GestureDetector(
                        onTap: isConnected ? null : () async {
                          if (isConnected) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please disconnect to change location')),
                            );
                            return;
                          }
                          
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocationSelectionScreen()),
                          );

                          if (result != null && result is Map) {
                            setState(() {
                              currentLocation = result['location'];
                              currentFlag = result['flag'] ?? '🏳️';
                            });
                          }
                        },
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: isConnected ? (isDark ? Colors.black26 : Colors.grey.shade100) : cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              if (!isConnected)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? Colors.grey.withOpacity(0.1) : Colors.grey.shade100,
                                ),
                                child: Text(currentFlag, style: const TextStyle(fontSize: 20)),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected Location',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: subTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentLocation,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.signal_cellular_alt, color: isConnected ? Colors.green : Colors.grey),
                              const SizedBox(width: 10),
                              if (!isConnected)
                                Icon(Icons.arrow_forward_ios, size: 16, color: subTextColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          );
        },
      ),
    );
  }
}
