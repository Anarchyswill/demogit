import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// --- Custom Color Palette (Dark & Orange Aesthetic) ---
const Color primaryDark = Color.fromARGB(255, 0, 0, 0);
const Color accentOrange = Color.fromARGB(255, 58, 255, 180); // Vibrant orange accent
const Color cardBackground = Color.fromARGB(255, 167, 167, 167);
const Color secondaryDark = Color.fromARGB(255, 56, 56, 56);
const Color backgroundLight = Color.fromARGB(255, 130, 130, 130); // Used for skill bar background

// --- WIDGET 1: Skill Bar with Percentage ---
class SkillBar extends StatelessWidget {
  final String title;
  final double percentage; // Value between 0.0 and 1.0

  const SkillBar({super.key, required this.title, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: accentOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 12,
            backgroundColor: backgroundLight,
            valueColor: const AlwaysStoppedAnimation<Color>(accentOrange),
          ),
        ),
      ],
    );
  }
}

// --- WIDGET 2: Interactive Hover Animation Card ---
class HoverAnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double cardWidth;

  const HoverAnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.cardWidth = 350,
  });

  @override
  State<HoverAnimatedCard> createState() => _HoverAnimatedCardState();
}

class _HoverAnimatedCardState extends State<HoverAnimatedCard> {
  bool _isHovering = false;

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scale and elevation for the dynamic hover effect
    final double scale = _isHovering ? 1.03 : 1.0;
    final double blurRadius = _isHovering ? 15.0 : 0.0;

    const Duration duration = Duration(milliseconds: 200);

    return MouseRegion(
      onEnter: (event) => _onHover(true),
      onExit: (event) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: scale,
        duration: duration,
        curve: Curves.easeOut,
        child: SizedBox(
          width: widget.cardWidth,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // Orange glow on hover
                  color: accentOrange.withOpacity(_isHovering ? 0.25 : 0.0),
                  blurRadius: blurRadius,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(20),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

// --- MAIN APPLICATION SETUP ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final ColorScheme _colorScheme = ColorScheme.dark(
    primary: accentOrange,
    onPrimary: Colors.white,
    secondary: secondaryDark,
    background: primaryDark,
    surface: cardBackground,
    onBackground: Colors.white70,
    onSurface: Colors.white,
  );

  static final ThemeData customTheme =
      ThemeData.from(
        colorScheme: _colorScheme,
        textTheme: const TextTheme(
          // Ensure 'Inter' font is used for specific styles
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: accentOrange,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ).copyWith(
        // Global font application for the entire theme
        textTheme: ThemeData().textTheme.apply(fontFamily: 'Inter'),

        // Aesthetic overrides for the clean, flat look
        scaffoldBackgroundColor: primaryDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
      );
  // FIX: Explicitly use the CardTheme class. This syntax IS correct, but
  // sometimes IDEs show this error due to versioning issues. We ensure
  // the structure is pristine.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Williams Favour - Digital Portfolio',
      theme: customTheme,
      home: const PortfolioPage(),
    );
  }
}

// --- PORTFOLIO PAGE IMPLEMENTATION ---
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  // Keys for Section Navigation
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey(); // New Key for Skills
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _resumeKey = GlobalKey();
  final GlobalKey _blogKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Animation controllers for subtle movement and entrance effects
  late AnimationController _bgAnimationController;
  late Animation<Color?> _colorAnimation;

  late AnimationController _heroEntranceController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Both controllers now use 'this' (the TickerProviderStateMixin)
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 65, 64, 64),
      end: const Color.fromARGB(255, 135, 135, 135),
    ).animate(_bgAnimationController);

    _heroEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroEntranceController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _heroEntranceController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
          ),
        );

    // Start the hero animation after a brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _heroEntranceController.forward();
      }
    });
  }

  void _scrollTo(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bgAnimationController.dispose();
    _heroEntranceController.dispose();
    super.dispose();
  }

  // Generic wrapper for all sections
  Widget _buildContentWrapper(
    GlobalKey key,
    String title,
    Widget child, {
    bool isHero = false,
  }) {
    return Container(
      key: key,
      padding: EdgeInsets.symmetric(
        vertical: isHero ? 100 : 80,
        horizontal: 24,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isHero)
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          if (!isHero) const SizedBox(height: 40),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // 1. Fluid Animated Background Layer
          AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _colorAnimation.value!,
                      _colorAnimation.value!.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          // 2. Centered Content Layer
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(context, _homeKey),
                _buildAboutSection(context, _aboutKey),
                _buildSkillsSection(
                  context,
                  _skillsKey,
                ), // New Skills Section with bars
                _buildServicesSection(context, _servicesKey),
                _buildPortfolioSection(context, _portfolioKey),
                _buildResumeSection(context, _resumeKey),
                _buildBlogSection(context, _blogKey),
                _buildContactSection(context, _contactKey),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Williams Favour',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        _buildNavItem('Home', () => _scrollTo(_homeKey)),
        _buildNavItem('About', () => _scrollTo(_aboutKey)),
        _buildNavItem(
          'Skills',
          () => _scrollTo(_skillsKey),
        ), // Nav link for Skills
        _buildNavItem('Services', () => _scrollTo(_servicesKey)),
        _buildNavItem('Portfolio', () => _scrollTo(_portfolioKey)),
        _buildNavItem('Resume', () => _scrollTo(_resumeKey)),
        _buildNavItem('Blog', () => _scrollTo(_blogKey)),
        _buildNavItem('Contact', () => _scrollTo(_contactKey)),
      ],
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- SECTION 1: HERO ---
  Widget _buildHeroSection(BuildContext context, GlobalKey key) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: _buildContentWrapper(
          key,
          '',
          Column(
            children: [
              // User Avatar Placeholder
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentOrange,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(Icons.person, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 32),
              Text(
                'WILLIAMS FAVOUR',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Cross-Platform Engineer | Flutter & Blender Specialist',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Call to action button
              ElevatedButton.icon(
                onPressed: () => _scrollTo(_contactKey),
                icon: const Icon(Icons.send),
                label: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Hire Me',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
          isHero: true,
        ),
      ),
    );
  }

  // --- SECTION 2: ABOUT ME ---
  Widget _buildAboutSection(BuildContext context, GlobalKey key) {
    // Enhanced About Me text
    const String aboutText =
        'I am Williams Favour, a Cross-Platform Engineer dedicated to merging robust software architecture with compelling visual design. As a proud graduate of the **University of Nigeria**, my deep-seated passion for technology drives me to build seamless digital experiences. My core expertise lies in **Flutter mobile development**—creating natively compiled applications across platforms—complemented by a distinct specialization in **3D digital artistry (Blender)**. I approach every challenge with precision, focusing on creating solutions that are both technically sophisticated and aesthetically striking.';

    return _buildContentWrapper(
      key,
      'About Me',
      Card(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: SelectableText(
            // Use SelectableText for easy copy/paste
            aboutText,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.5),
          ),
        ),
      ),
    );
  }

  // --- SECTION 3: SKILLS (with Progress Bars) ---
  Widget _buildSkillsSection(BuildContext context, GlobalKey key) {
    return _buildContentWrapper(
      key,
      'My Work Skills',
      GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
        crossAxisSpacing: 40,
        mainAxisSpacing: 30,
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Important for nested scrolling
        childAspectRatio: 5, // Taller aspect ratio for progress bars
        children: const [
          // Mock percentages used for visualization, easily adjustable by user
          SkillBar(title: 'Flutter Mobile Development', percentage: 0.90),
          SkillBar(title: 'Full-Stack Engineering', percentage: 0.80),
          SkillBar(title: '3D Animation (Blender)', percentage: 0.85),
          SkillBar(title: 'SEO Analysis & Optimization', percentage: 0.75),
          SkillBar(
            title: 'Mobile App Development',
            percentage: 0.90,
          ), // Redundant but kept for comprehensive list
          SkillBar(title: 'Data Analysis Fundamentals', percentage: 0.70),
        ],
      ),
    );
  }

  // --- SECTION 4: SERVICES (with Hover Cards) ---
  Widget _buildServicesSection(BuildContext context, GlobalKey key) {
    return _buildContentWrapper(
      key,
      'Core Services',
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 30,
        runSpacing: 30,
        children: [
          _buildServiceCard(
            context,
            'Cross-Platform Mobile Apps',
            'Building responsive, natively compiled applications for iOS, Android, and Web from a single, optimized Flutter codebase.',
            Icons.mobile_friendly,
          ),
          _buildServiceCard(
            context,
            'Full-Stack Architecture',
            'Designing and implementing end-to-end solutions, bridging robust backend logic with clean, modern frontends (Full-stack Development).',
            Icons.storage,
          ),
          _buildServiceCard(
            context,
            'Digital Art & 3D Visualization',
            'Creating professional, photorealistic or stylized 3D assets, rendering, and animations using Blender.',
            Icons.brush,
          ),
          _buildServiceCard(
            context,
            'Performance & SEO Optimization',
            'Analyzing web performance and implementing advanced SEO practices to ensure high search visibility and fast load times.',
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return HoverAnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 40),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  // --- SECTION 5: PORTFOLIO / PROJECTS ---
  Widget _buildPortfolioSection(BuildContext context, GlobalKey key) {
    return _buildContentWrapper(
      key,
      'Current Projects',
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 30,
        runSpacing: 30,
        children: [
          _buildPortfolioCard(
            context,
            'Sentinel Time Tracker',
            'A productivity application built with Flutter focusing on detailed screen time analysis and promoting digital well-being.',
            Icons.watch_later,
            'Flutter App',
          ),
          _buildPortfolioCard(
            context,
            'Aethos AI Assistant (Concept)',
            'A priority-tracking AI assistant designed to intelligently manage tasks, optimize workflows, and integrate with backend data services.',
            Icons.auto_awesome,
            'AI / Full-Stack',
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    String tag,
  ) {
    return HoverAnimatedCard(
      cardWidth: 400, // Make portfolio cards slightly wider for detail
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: accentOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Icon(icon, size: 48, color: accentOrange),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  // --- SECTION 6: RESUME / EXPERIENCE ---
  Widget _buildResumeSection(BuildContext context, GlobalKey key) {
    return _buildContentWrapper(
      key,
      'Career Highlights',
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResumeTitle('Professional Experience'),
                const Divider(color: secondaryDark, height: 30, thickness: 1),
                _buildResumeEntry(
                  'SEO Analyst & Frontend Developer (Remote)',
                  'Hybrid Valeting Services',
                  '2024 - Present',
                  'Optimized site performance and search visibility while contributing to key frontend development tasks, focusing on fast, responsive user interfaces.',
                ),
                const SizedBox(height: 30),
                _buildResumeTitle('Education & Projects'),
                const Divider(color: secondaryDark, height: 30, thickness: 1),
                _buildResumeEntry(
                  'Student Web Portal Initiative',
                  'University of Nigeria, Nsukka',
                  '2020 - 2021',
                  'Developed a functional student web portal solution to enhance campus services and internal data management during academic studies.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumeTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: accentOrange,
      ),
    );
  }

  Widget _buildResumeEntry(
    String title,
    String subtitle,
    String date,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: accentOrange.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 15, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // --- SECTION 7: BLOG ---
  Widget _buildBlogSection(BuildContext context, GlobalKey key) {
    return _buildContentWrapper(
      key,
      'Thought Leadership',
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 30,
        runSpacing: 30,
        children: [
          _buildBlogCard(
            context,
            'The Trap of Endless Preparation',
            'An honest look at overcoming perfectionism and the challenges of starting a project before feeling "100% ready" or getting it right on the first try.',
            '2024-09-01',
          ),
          _buildBlogCard(
            context,
            'The Filtering of Noise: Debugging Your Lifestyle',
            'Applying software development principles, like debugging and refactoring, to personal habits and life choices to optimize focus and clarity.',
            '2024-08-15',
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(
    BuildContext context,
    String title,
    String description,
    String date,
  ) {
    return HoverAnimatedCard(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: accentOrange,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text(
              'Read on Medium • $date',
              style: const TextStyle(fontSize: 14, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  // --- SECTION 8: CONTACT ---
  Widget _buildContactSection(BuildContext context, GlobalKey key) {
    return _buildContentWrapper(
      key,
      'Get In Touch',
      Card(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'I am currently open to new remote opportunities, collaborations, and contract work. If you have a project in mind or want to discuss Flutter or Blender, feel free to reach out directly.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 30,
                runSpacing: 20,
                children: [
                  _buildSocialLink(
                    'LinkedIn',
                    Icons.work,
                    'https://www.linkedin.com/in/williams-favour-435475269/',
                  ),
                  _buildSocialLink(
                    'GitHub',
                    Icons.code,
                    'https://github.com/Anarchyswill',
                  ),
                  _buildSocialLink(
                    'Medium',
                    Icons.article,
                    'https://medium.com/@williamfavour1998',
                  ),
                  _buildSocialLink(
                    'Email',
                    Icons.email,
                    'mailto:williamfavour1998@gmail.com',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLink(String text, IconData icon, String url) {
    return TextButton.icon(
      onPressed: () {
        // In a real app, you would use url_launcher here: launchUrl(Uri.parse(url));
        print('Attempting to open link: $url');
      },
      icon: Icon(icon, color: accentOrange, size: 20),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- FOOTER ---
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      color: secondaryDark,
      width: double.infinity,
      child: const Text(
        '© 2025 Williams Favour. Built with Flutter.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white54, fontSize: 14),
      ),
    );
  }
}

