import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../widgets/onboarding/intro_background.dart';
import '../widgets/onboarding/app_logo.dart';
import '../widgets/onboarding/welcome_card.dart';
import '../widgets/onboarding/get_started_button.dart';
import '../widgets/onboarding/footer_credits.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late AnimationController _pageController;
  late AnimationController _cardController;
  late AnimationController _textController;

  late Animation<double> _pageFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _logoFade;
  
  late Animation<Offset> _cardSlide;
  
  late Animation<double> _titleFade;
  late Animation<double> _descFade;
  late Animation<double> _buttonScale;
  late Animation<double> _buttonFade;
  late Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();
    
    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _pageFade = CurvedAnimation(parent: _pageController, curve: Curves.easeIn);
    
    _logoFade = CurvedAnimation(parent: _pageController, curve: Curves.easeIn);
    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic));
        
    _cardSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic));

    _titleFade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );
    _descFade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
    );
    _buttonScale = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutBack),
    );
    _buttonFade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
    );
    _footerFade = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _pageController.forward();
    await _cardController.forward();
    _textController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cardController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _pageFade,
        child: Stack(
          children: [
            const IntroBackground(),
            
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'URBAN HEAT ISLAND VISUALIZER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SlideTransition(
                    position: _logoSlide,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: const AppLogo(),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  SlideTransition(
                    position: _cardSlide,
                    child: WelcomeCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeTransition(
                            opacity: _titleFade,
                            child: Column(
                              children: [
                                Text(
                                  'WELCOME',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'To',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Urban Heat Island Visualizer',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          FadeTransition(
                            opacity: _descFade,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Explore how cities are changing through satellite temperature insights.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xFF6B7280),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          FadeTransition(
                            opacity: _buttonFade,
                            child: ScaleTransition(
                              scale: _buttonScale,
                              child: GetStartedButton(
                                onTap: _onGetStarted,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          FadeTransition(
                            opacity: _footerFade,
                            child: const FooterCredits(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
