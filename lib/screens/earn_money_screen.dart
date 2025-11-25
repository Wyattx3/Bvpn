import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../user_manager.dart';

class EarnMoneyScreen extends StatefulWidget {
  const EarnMoneyScreen({super.key});

  @override
  State<EarnMoneyScreen> createState() => _EarnMoneyScreenState();
}

class _EarnMoneyScreenState extends State<EarnMoneyScreen> {
  final UserManager _userManager = UserManager();
  bool _isWatchingAd = false;
  int _todayEarnings = 0;
  int _adsWatchedToday = 0;
  final int _maxAdsPerDay = 100;

  String _formatNumber(int number) {
    String numStr = number.toString();
    String result = '';
    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      result = numStr[i] + result;
      if (count % 3 == 0 && i != 0) {
        result = ',$result';
      }
    }
    return result;
  }

  void _watchAd() {
    if (_isWatchingAd) return;
    if (_adsWatchedToday >= _maxAdsPerDay) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have reached the daily limit of 50 ads!')),
      );
      return;
    }

    setState(() {
      _isWatchingAd = true;
    });

    // Simulate watching ad
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _userManager.addBalance(30); // Add 30 MMK per ad
        setState(() {
          _isWatchingAd = false;
          _todayEarnings += 30;
          _adsWatchedToday++;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('+30 MMK earned!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A1625) : const Color(0xFFFAFAFC);
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final primaryPurple = isDark ? const Color(0xFFB388FF) : const Color(0xFF7E57C2);
    final surfaceColor = isDark ? const Color(0xFF2D2640) : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text('Earn Money', style: TextStyle(color: textColor)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Total Balance Section
                ValueListenableBuilder<int>(
                  valueListenable: _userManager.balanceMMK,
                  builder: (context, balance, child) {
                    final usdValue = balance / 4500;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark 
                            ? [const Color(0xFF7C4DFF), const Color(0xFFB388FF)]
                            : [const Color(0xFF7E57C2), const Color(0xFFB39DDB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_formatNumber(balance)} MMK',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '≈ \$${usdValue.toStringAsFixed(2)} USD',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Today: +${_formatNumber(_todayEarnings)} MMK',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: isDark ? Border.all(color: Colors.purple.withOpacity(0.2)) : null,
                          boxShadow: isDark ? null : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.play_circle_outline, color: primaryPurple, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              '$_adsWatchedToday / $_maxAdsPerDay',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ads Today',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: isDark ? Border.all(color: Colors.purple.withOpacity(0.2)) : null,
                          boxShadow: isDark ? null : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.monetization_on_outlined, color: Colors.amber, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              '30 MMK',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Per Ad',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Progress Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: isDark ? Border.all(color: Colors.purple.withOpacity(0.2)) : null,
                    boxShadow: isDark ? null : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily Progress',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            '${(_adsWatchedToday / _maxAdsPerDay * 100).toInt()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _adsWatchedToday / _maxAdsPerDay,
                          minHeight: 10,
                          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Max earnings today: ${_formatNumber(_maxAdsPerDay * 30)} MMK',
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Watch Ad Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _adsWatchedToday >= _maxAdsPerDay ? null : _watchAd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isWatchingAd
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Watching Ad...',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_circle_filled, size: 28),
                              const SizedBox(width: 12),
                              Text(
                                _adsWatchedToday >= _maxAdsPerDay 
                                    ? 'Daily Limit Reached' 
                                    : 'Watch Ad & Earn 30 MMK',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Info Text
                Text(
                  'Watch short video ads to earn money.\nYou can watch up to $_maxAdsPerDay ads per day.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

