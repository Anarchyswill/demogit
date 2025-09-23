// Imports the necessary material library for Flutter widgets.
import 'package:flutter/material.dart';

void main() {
  // The runApp function takes a widget and makes it the root of the widget tree.
  runApp(const PortfolioApp());
}

// This is a StatelessWidget, which means it doesn't have a mutable state.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The MaterialApp widget sets up the basic visual structure for a Material Design app.
    // We define a dark theme to match the user's design.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Williams Favour - Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
 
        primarySwatch: const MaterialColor(
          _yellowPrimary,
          <int, Color>{
            50: Color(0xFFFFFDE7),
            100: Color(0xFFFFF9C4),
            200: Color(0xFFFFF59D),
            300: Color(0xFFFFF176),
            400: Color(0xFFFFEE58),
            500: Color(_yellowPrimary),
            600: Color(0xFFFDD835),
            700: Color(0xFFFBC02D),
            800: Color(0xFFF9A825),
            900: Color(0xFFF57F17),
          },
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 48),
          displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
          bodyLarge: TextStyle(color: Color(0xFFBDBDBD)),
          bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
        ),
      ),
      home: const PortfolioPage(),
    );
  }
}

const int _yellowPrimary = 0xFFFFEB3B;

// This is a StatefulWidget because we need to manage mutable state,
// specifically the selected filter for the portfolio items.
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  // A ScrollController to manage scrolling to different sections.
  final ScrollController _scrollController = ScrollController();
  
  // A map of GlobalKeys to identify each section of the portfolio.
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'resume': GlobalKey(),
    'portfolio': GlobalKey(),
    'testimonials': GlobalKey(),
    'contact': GlobalKey(),
  };

  String _selectedFilter = 'all';

  // Mock data for the portfolio items.
  final List<Map<String, dynamic>> _portfolioItems = [
    {'category': 'graphic_design', 'image_url': 'https://placehold.co/400x300/FBC02D/white?text=Graphic+1', 'title': 'Graphic Design'},
    {'category': 'web_design', 'image_url': 'https://placehold.co/400x300/FBC02D/white?text=Web+1', 'title': 'Web Design'},
    {'category': 'photography', 'image_url': 'https://placehold.co/400x300/FBC02D/white?text=Photo+1', 'title': 'Photography'},
    {'category': 'graphic_design', 'image_url': 'https://placehold.co/400x300/FBC02D/white?text=Graphic+2', 'title': 'Graphic Design'},
    {'category': 'web_design', 'image_url': 'https://placehold.co/400x300/FBC02D/white?text=Web+2', 'title': 'Web Design'},
  ];

  // Mock data for resume entries.
  final List<Map<String, String>> _resumeEntries = [
    {'title': 'Experience 1', 'subtitle': 'Company, 2019-2021', 'description': 'Lorem ipsum dolor sit amet...'},
    {'title': 'Experience 2', 'subtitle': 'Company, 2017-2019', 'description': 'Lorem ipsum dolor sit amet...'},
  ];
  
  // Mock data for testimonials.
  final List<Map<String, String>> _testimonials = [
    {'name': 'John Doe', 'text': 'Excellent work!', 'rating': '★★★★★'},
    {'name': 'Jane Smith', 'text': 'Highly recommend.', 'rating': '★★★★★'},
    {'name': 'Peter Jones', 'text': 'Amazing attention to detail.', 'rating': '★★★★★'},
  ];

  @override
  Widget build(BuildContext context) {
    // A LayoutBuilder is used to get the screen size and create a responsive layout.
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the screen width is less than 900, we use a mobile layout.
        if (constraints.maxWidth < 1600) {
          return _buildMobileLayout();
        } else {
          // Otherwise, we use the desktop layout with a sidebar.
          return _buildDesktopLayout();
        }
      },
    );
  }
  
 // This method builds the desktop layout with a fixed sidebar.
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Williams Favour', style: TextStyle(color: Color(0xFFFBC02D))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          // The background image.
          Positioned.fill(
            child: Image.asset(
              'lib/img/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // A Row to hold the sidebar and the main content.
          Row(
            children: <Widget>[
              // The Sidebar widget.
              _buildSidebar(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: <Widget>[
                      _buildHeroSection(),
                      _buildAboutMeSection(),
                      _buildResumeSection(),
                      _buildPortfolioSection(),
                      _buildTestimonialsSection(),
                      _buildContactSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // This method builds the mobile layout with a top-aligned sidebar in a Drawer.
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Williams Favour', style: TextStyle(color: Color(0xFFFBC02D))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: _buildSidebar(isMobile: true),
      ),
      body: Stack(
        children: <Widget>[
          // The background image.
          Positioned.fill(
            child: Image.asset(
              'lib/img/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // The main content of the portfolio, which is scrollable.
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                _buildHeroSection(),
                _buildAboutMeSection(),
                _buildResumeSection(),
                _buildPortfolioSection(),
                _buildTestimonialsSection(),
                _buildContactSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // A reusable method to build the sidebar for both desktop and mobile.
  Widget _buildSidebar({bool isMobile = false}) {
    return Container(
      width: isMobile ? double.infinity : 250,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Profile section at the top of the sidebar.
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            color: const Color(0xFF2C2C2E),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromARGB(255, 77, 77, 77),
                  child: Icon(Icons.person, size: 60, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  'Williams Favour',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Text('Data Analyst / Mobile Developer', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              ],
            ),
          ),
          // Navigation links in the sidebar.
          _buildSidebarItem('HOME', 'home'),
          _buildSidebarItem('ABOUT ME', 'about'),
          _buildSidebarItem('RESUME', 'resume'),
          _buildSidebarItem('PORTFOLIO', 'portfolio'),
          _buildSidebarItem('CERTIFICATIONS', 'Certifications'),
          _buildSidebarItem('CONTACT', 'contact'),
        ],
      ),
    );
  }

  // A reusable method to build a single navigation item in the sidebar.
  Widget _buildSidebarItem(String title, String key) {
    return InkWell(
      onTap: () {
        // Scrolls to the selected section on tap.
        _scrollController.animateTo(
          (_sectionKeys[key]!.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Text(
          title,
          style: const TextStyle(color: Color.fromARGB(255, 178, 178, 178), fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  // A reusable method to build a header for each section.
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  // Method to build the Hero (intro) section.
  Widget _buildHeroSection() {
    return Card(
      elevation: 8.0,
      key: _sectionKeys['home'],
      margin: const EdgeInsets.all(40),
      color: const Color(0xFF2C2C2E),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HI THERE!', style: Theme.of(context).textTheme.displayMedium),
          Text(
            "I'M WILLIAMS",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(color: const Color.fromARGB(255, 255, 255, 255)),
          ),
          const Text(
            'DATA ANALYST / MOBILE DEVELOPMENT',
            style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 30),
          ),
          const SizedBox(height: 20),
          const Text(
            "A proactive mobile developer and SEO analyst with a passion for continuous learning. My journey is defined by a data-driven approach and a keen interest in AI/ML.",
            style: TextStyle(color: Color(0xFFBDBDBD)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 173, 173, 173),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: const Text('MORE ABOUT ME'),
          ),
        ],
      ),
      )
    );
  }
  
  // Method to build the About Me section.
  Widget _buildAboutMeSection() {
    return Card(
      elevation: 8.0,
      color: const Color(0xFF2C2C2E),
      key: _sectionKeys['about'],
      margin: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildSectionHeader('About Me'),
          // The image and text section for "About Me".
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFFFBC02D),
                child: Icon(Icons.person, size: 70, color: Colors.black),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "I'm Benjamin Smith, Graphic Designer / Photographer",
                      style: TextStyle(color: Color(0xFFFBC02D), fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                      style: TextStyle(color: Color(0xFFBDBDBD)),
                    ),
                    const SizedBox(height: 20),
                    // Stats section.
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildStatBox('15+', 'Years Experience'),
                        _buildStatBox('350+', 'Happy Clients'),
                        _buildStatBox('200+', 'Projects Done'),
                        _buildStatBox('45k', 'Followers'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable method for the stats boxes.
  Widget _buildStatBox(String count, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(count, style: Theme.of(context).textTheme.displayMedium?.copyWith(color: const Color(0xFFFBC02D))),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
  
  // Method to build the Resume section.
  Widget _buildResumeSection() {
    return Container(
      key: _sectionKeys['resume'],
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildSectionHeader('Resume'),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            children: [
              // Column for experience.
              SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Experience', style: TextStyle(color: Color(0xFFFBC02D), fontSize: 20)),
                    const SizedBox(height: 10),
                    ..._resumeEntries.map((entry) => _buildResumeItem(entry)).toList(),
                  ],
                ),
              ),
              // Column for education (mocked to look like experience).
              SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Education', style: TextStyle(color: Color(0xFFFBC02D), fontSize: 20)),
                    const SizedBox(height: 10),
                    ..._resumeEntries.map((entry) => _buildResumeItem(entry)).toList(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Reusable method for a single resume item.
  Widget _buildResumeItem(Map<String, String> entry) {
    return Card(
      color: const Color(0xFF2C2C2E),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(entry['subtitle']!, style: const TextStyle(color: Color(0xFFFBC02D))),
            const SizedBox(height: 10),
            Text(entry['description']!, style: const TextStyle(color: Color(0xFFBDBDBD))),
          ],
        ),
      ),
    );
  }

  // Method to build the Portfolio section.
  Widget _buildPortfolioSection() {
    return Container(
      key: _sectionKeys['portfolio'],
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildSectionHeader('Portfolio'),
          // Filter buttons for the portfolio.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterButton('all', 'ALL'),
              const SizedBox(width: 10),
              _buildFilterButton('graphic_design', 'GRAPHIC DESIGN'),
              const SizedBox(width: 10),
              _buildFilterButton('web_design', 'WEB DESIGN'),
              const SizedBox(width: 10),
              _buildFilterButton('photography', 'PHOTOGRAPHY'),
            ],
          ),
          const SizedBox(height: 30),
          // Grid of portfolio items.
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: _portfolioItems
                .where((item) => _selectedFilter == 'all' || item['category'] == _selectedFilter)
                .map((item) => _buildPortfolioItem(item))
                .toList(),
          ),
        ],
      ),
    );
  }
  
  // Reusable method for a single portfolio item.
  Widget _buildPortfolioItem(Map<String, dynamic> item) {
    return SizedBox(
      width: 400,
      child: Card(
        color: const Color(0xFF2C2C2E),
        child: Column(
          children: [
            Image.network(item['image_url'], fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(item['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable method for a portfolio filter button.
  Widget _buildFilterButton(String filter, String label) {
    final bool isSelected = _selectedFilter == filter;
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? Colors.black : const Color(0xFFBDBDBD),
        backgroundColor: isSelected ? const Color(0xFFFBC02D) : Colors.transparent,
        side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFBDBDBD)),
      ),
      child: Text(label),
    );
  }

  // Method to build the Testimonials section.
  Widget _buildTestimonialsSection() {
    return Container(
      key: _sectionKeys['testimonials'],
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildSectionHeader('Testimonials'),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: _testimonials.map((testimonial) => _buildTestimonialItem(testimonial)).toList(),
          ),
        ],
      ),
    );
  }

  // Reusable method for a single testimonial item.
  Widget _buildTestimonialItem(Map<String, String> testimonial) {
    return Card(
      color: const Color(0xFF2C2C2E),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(testimonial['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(testimonial['rating']!, style: const TextStyle(color: Color(0xFFFBC02D))),
            const SizedBox(height: 10),
            Text(testimonial['text']!, style: const TextStyle(color: Color(0xFFBDBDBD))),
          ],
        ),
      ),
    );
  }
  
  // Method to build the Contact section.
  Widget _buildContactSection() {
    return Container(
      key: _sectionKeys['contact'],
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildSectionHeader('Contact'),
          // The contact form is a placeholder, as it requires a backend.
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF2C2C2E),
            child: const Text('Contact form placeholder.', style: TextStyle(color: Color(0xFFBDBDBD))),
          ),
          const SizedBox(height: 20),
          const Text('THANKS FOR PATIENCE!', style: TextStyle(color: Color(0xFFBDBDBD))),
        ],
      ),
    );
  }
}
