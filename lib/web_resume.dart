import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Name - Full Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF161616),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 28, // Slightly larger for better hierarchy
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _resumeKey = GlobalKey();
  final GlobalKey _blogKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFF161616),
      end: const Color(0xFF2D2D2D),
    ).animate(_animationController);
  }

  void _scrollTo(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the maximum width for the centered content to maintain a clean, readable layout on large screens.
    final double maxContentWidth = 800;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Background fluid animation container
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
          Center( // Center the entire content column
            child: ConstrainedBox( // Constrain the width of the content
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _buildHeroSection(context, _homeKey),
                    _buildAboutSection(context, _aboutKey),
                    _buildServicesSection(context, _servicesKey),
                    _buildPortfolioSection(context, _portfolioKey),
                    _buildResumeSection(context, _resumeKey),
                    _buildBlogSection(context, _blogKey),
                    _buildContactSection(context, _contactKey),
                    const SizedBox(height: 50), // Add padding at the bottom
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Gerold.',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        _buildNavItem('Home', () => _scrollTo(_homeKey)),
        _buildNavItem('About', () => _scrollTo(_aboutKey)),
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

  Widget _buildHeroSection(BuildContext context, GlobalKey key) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.deepPurple.shade700,
            child: const Icon(Icons.person, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Name Here',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Mobile & Animation Developer',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'I\'m a passionate developer based in Abuja, Nigeria, currently focused on learning mobile development with Flutter and 3D animation with Blender. I am also interested in gaming and am on a journey to learn Spanish.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content
        children: [
          Text(
            'About Me',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'I am a self-taught developer from Abuja, Nigeria, with a keen interest in creating beautiful and functional digital experiences. My current focus is on mastering Flutter for cross-platform mobile development and leveraging Blender for 3D animation and design. My journey is driven by a passion for technology and a constant desire to learn, whether it\'s a new programming language or the complexities of Spanish.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context, GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'My Services',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Using Wrap for a flexible, centered grid-like layout
          Wrap(
            alignment: WrapAlignment.center, // Center the items
            spacing: 16, // Horizontal spacing
            runSpacing: 16, // Vertical spacing
            children: [
              _buildServiceCard(context, 'Mobile App Development', 'Crafting responsive and dynamic mobile applications for iOS and Android using Flutter.', 300),
              _buildServiceCard(context, '3D Animation', 'Creating captivating 3D animations and models with Blender for various digital media projects.', 300),
              _buildServiceCard(context, 'UI/UX Design', 'Designing intuitive and user-friendly interfaces with a focus on seamless user experience.', 300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String description, double width) {
    return SizedBox(
      width: width, // Fixed width for a uniform look
      child: Card(
        color: Colors.deepPurple.shade900.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioSection(BuildContext context, GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Portfolio',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildPortfolioCard(
                context,
                'Flutter E-commerce App',
                'A mobile e-commerce application built with Flutter and Firebase.',
                Icons.shopping_cart,
                300
              ),
              _buildPortfolioCard(
                context,
                'Blender 3D Character Rig',
                'A rigged 3D character model created in Blender.',
                Icons.person_pin_circle,
                300
              ),
              _buildPortfolioCard(
                context,
                'Educational Spanish App',
                'An app for learning Spanish vocabulary and grammar, built with Flutter.',
                Icons.school,
                300
              ),
              _buildPortfolioCard(
                context,
                'Gaming Dashboard',
                'A responsive dashboard for tracking game stats and achievements.',
                Icons.videogame_asset,
                300
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard(
      BuildContext context, String title, String description, IconData icon, double width) {
    return SizedBox(
      width: width,
      child: Card(
        color: Colors.deepPurple.shade900.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 40, color: Colors.deepPurple),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumeSection(BuildContext context, GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Resume',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildResumeCard('Education', [
            _buildResumeEntry(
                'Self-Taught', 'Mobile & 3D Animation Development', '2023 - Present'),
          ]),
          const SizedBox(height: 24),
          _buildResumeCard('Experience', [
            _buildResumeEntry(
                'Freelance Developer', 'Mobile & Animation Projects', '2024 - Present'),
          ]),
        ],
      ),
    );
  }

  Widget _buildResumeCard(String title, List<Widget> entries) {
    return Card(
      color: Colors.deepPurple.shade900.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...entries,
          ],
        ),
      ),
    );
  }

  Widget _buildResumeEntry(String title, String subtitle, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogSection(BuildContext context, GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Blog',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildBlogCard(context, 'My First Flutter App', 'A step-by-step guide to building my first mobile application.', '2024-09-01'),
          _buildBlogCard(context, 'Exploring 3D Art in Blender', 'My journey into the world of 3D modeling and animation.', '2024-08-15'),
        ],
      ),
    );
  }

  Widget _buildBlogCard(BuildContext context, String title, String description, String date) {
    return Card(
      color: Colors.deepPurple.shade900.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Published: $date',
                style: const TextStyle(fontSize: 14, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Contact',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'If you have a project or a collaboration in mind, feel free to reach out!',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildSocialLink('GitHub', Icons.code),
          _buildSocialLink('LinkedIn', Icons.work),
          _buildSocialLink('Email: your.email@example.com', Icons.email),
        ],
      ),
    );
  }

  Widget _buildSocialLink(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
                fontSize: 16, color: Colors.white, decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
