import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const VirtualHospitalApp());
}

class VirtualHospitalApp extends StatelessWidget {
  const VirtualHospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFAF3E0), // Cream background
      ),
      home: const LoginScreen(), // Start with Login
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/chat': (context) => const AIChatScreen(),
        '/vitals': (context) => const VitalsScreen(),
        '/diet-calendar': (context) => const DietCalendarScreen(),
        '/diet-plan': (context) => const DietPlanDetailScreen(),
        '/diet-manager': (context) => const DietManagerScreen(),
      },
    );
  }
}

// ==================== SCREEN 1: LOGIN ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountry = "United States";
  bool _isLoading = false;

  final List<Map<String, String>> _countries = [
    {"name": "United States", "flag": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Flag_of_the_United_States.svg/32px-Flag_of_the_United_States.svg.png"},
    {"name": "Pakistan", "flag": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Flag_of_Pakistan.svg/32px-Flag_of_Pakistan.svg.png"},
    {"name": "India", "flag": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Flag_of_India.svg/32px-Flag_of_India.svg.png"},
    {"name": "United Kingdom", "flag": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Flag_of_the_United_Kingdom.svg/32px-Flag_of_the_United_Kingdom.svg.png"},
    {"name": "Canada", "flag": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Flag_of_Canada_%28Pantone%29.svg/32px-Flag_of_Canada_%28Pantone%29.svg.png"},
    {"name": "Australia", "flag": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Flag_of_Australia_%28converted%29.svg/32px-Flag_of_Australia_%28converted%29.svg.png"},
  ];

  void _validateAndLogin() {
    setState(() => _isLoading = true);

    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();

    // Validate empty fields
    if (email.isEmpty || phone.isEmpty) {
      setState(() => _isLoading = false);
      _showErrorDialog("Please fill in all fields");
      return;
    }

    // Validate email format only
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _isLoading = false);
      _showErrorDialog("Please enter a valid email address");
      return;
    }

    // Validate phone number format only (should be digits only)
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      setState(() => _isLoading = false);
      _showErrorDialog("Phone number should contain only numbers");
      return;
    }

    if (phone.length < 10) {
      setState(() => _isLoading = false);
      _showErrorDialog("Phone number should be at least 10 digits");
      return;
    }

    // All validations passed - Login successful
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(185, 140, 140, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: const Color.fromRGBO(134, 55, 53, 1)),
            const SizedBox(width: 10),
            const Text("Invalid Input"),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                color: const Color(0xFFA1887F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(249, 183, 183, 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 133, 105, 105),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Select Country",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6D4C41),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                      _countries[index]["flag"]!,
                      width: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.flag);
                      },
                    ),
                    title: Text(
                      _countries[index]["name"]!,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    trailing: _selectedCountry == _countries[index]["name"]
                        ? Icon(Icons.check, color: Colors.brown.shade400)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCountry = _countries[index]["name"]!;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Logo and Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, color: Colors.brown.shade300, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "VirtualHospital",
                      style: GoogleFonts.philosopher(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8D6E63),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                // Health Icons Grid
                Wrap(
                  spacing: 40,
                  runSpacing: 40,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildHealthIcon(Icons.hotel, Colors.pink.shade100),
                    _buildHealthIcon(Icons.medical_services_outlined, Colors.orange.shade100),
                    _buildHealthIcon(Icons.local_hospital_outlined, Colors.brown.shade100),
                    _buildHealthIcon(Icons.monitor_heart_outlined, Colors.red.shade100),
                    _buildHealthIcon(Icons.medication_outlined, Colors.amber.shade100),
                    _buildHealthIcon(Icons.vaccines_outlined, Colors.green.shade100),
                  ],
                ),
                const SizedBox(height: 50),
                // Home Text
                Text(
                  "Home",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
                const SizedBox(height: 40),
                // Email Input
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(157, 228, 142, 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      hintStyle: TextStyle(color: const Color(0xFFA3C1BE)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Phone Input
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(221, 167, 232, 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      hintStyle: TextStyle(color: const Color.fromRGBO(197, 123, 158, 1)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Country Selector
                GestureDetector(
                  onTap: _showCountryPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          _countries.firstWhere((c) => c["name"] == _selectedCountry)["flag"]!,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.flag, size: 24);
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _selectedCountry,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _validateAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA1887F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Continue",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Don't have my account?",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.brown.shade400, size: 28),
    );
  }
}

// ==================== SCREEN 2: DASHBOARD ====================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome,",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "[Patient Name]",
                        style: GoogleFonts.philosopher(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6D4C41),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFFFCDD2),
                    child: Icon(Icons.person, color: Colors.brown.shade400, size: 28),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Text(
                      "[Patient Name]",
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFFFFCDD2),
                      child: Icon(Icons.person, color: Colors.brown.shade400, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Feature Cards Grid
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.0,
                  children: [
                    _buildFeatureCard(
                      "Chat with Gemini AI",
                      Icons.chat_bubble_outline,
                      const Color(0xFFE8F5E9),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AIChatScreen())),
                    ),
                    _buildFeatureCard(
                      "Daily Health Tracker",
                      Icons.favorite_border,
                      const Color(0xFFFCE4EC),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VitalsScreen())),
                    ),
                    _buildFeatureCard(
                      "Daily Meals Tracker",
                      Icons.restaurant_menu_outlined,
                      const Color(0xFFFFF3E0),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DietCalendarScreen())),
                    ),
                    _buildFeatureCard(
                      "Exercise & Yoga",
                      Icons.self_improvement_outlined,
                      const Color(0xFFD7CCC8),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DietPlanDetailScreen())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          selectedItemColor: const Color(0xFF8D6E63),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 32, color: Colors.brown.shade600),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6D4C41),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 3: DIET CALENDAR ====================
class DietCalendarScreen extends StatefulWidget {
  const DietCalendarScreen({super.key});

  @override
  State<DietCalendarScreen> createState() => _DietCalendarScreenState();
}

class _DietCalendarScreenState extends State<DietCalendarScreen> {
  String selectedMeal = "Breakfast";
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF3E0),
        elevation: 0,
        title: Text(
          "Daily Diet Plan",
          style: GoogleFonts.poppins(
            color: const Color(0xFF6D4C41),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6D4C41)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF6D4C41)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Meal Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                children: [
                  _buildMealTab("Breakfast"),
                  const SizedBox(width: 10),
                  _buildMealTab("Lunch"),
                  const SizedBox(width: 10),
                  _buildMealTab("Dinner"),
                ],
              ),
            ),
            // Redy xfady text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Redy xfady",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Calendar Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Weekday Headers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeekday("Sum"),
                        _buildWeekday("Mt"),
                        _buildWeekday("We"),
                        _buildWeekday("Th"),
                        _buildWeekday("Fr"),
                        _buildWeekday("Sat"),
                        _buildWeekday("Sum"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Calendar Dates
                    _buildCalendarRow([1, 2, 3, 6, 6, 6, null]),
                    _buildCalendarRow([7, 8, 9, 10, 11, 15, 19]),
                    _buildCalendarRow([18, 15, 15, 18, 21, 22, 23]),
                    _buildCalendarRow([29, 29, 30, 31, null, null, null]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Recommende today
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recommende today",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Recommendation Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRecommendBox("1", const Color(0xFFE8F5E9)),
                    _buildRecommendBox("30", const Color(0xFFFFCDD2)),
                    _buildRecommendBox("2", Colors.white),
                    _buildRecommendBox("19", Colors.white),
                    _buildRecommendBox("30", Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Bottom profile icon with navigation
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const DietManagerScreen())
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFD7CCC8),
                  child: Icon(Icons.person, color: Colors.brown.shade600, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 80), // Extra space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          selectedItemColor: const Color(0xFF8D6E63),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTab(String meal) {
    bool isSelected = selectedMeal == meal;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedMeal = meal),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD7CCC8) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            meal,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6D4C41),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekday(String day) {
    return Text(
      day,
      style: GoogleFonts.poppins(
        fontSize: 11,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildCalendarRow(List<int?> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          if (day == null) return const SizedBox(width: 30);
          return Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: day == 6 ? const Color(0xFFD7CCC8) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF6D4C41),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendBox(String number, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          number,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6D4C41),
          ),
        ),
      ),
    );
  }
}

// ==================== SCREEN 4: VITALS TRACKER ====================
class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Daily Title
              Text(
                "Daily",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6D4C41),
                ),
              ),
              const SizedBox(height: 25),
              // Vitals Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildVitalCard("BP", "122/90", const Color(0xFFFFF3E0)),
                    _buildVitalCard("Temp", "98.6°F", const Color(0xFFFFF3E0)),
                    _buildVitalCard("O₂", "98.67°F", const Color(0xFFFFF3E0)),
                    _buildVitalCard("Water", "(9₂(E))", const Color(0xFFE3F2FD)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Sugar, Water, Wear tracking
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSmallStat("Yoga", "0"),
                    _buildSmallStat("Sugar", "0"),
                    _buildSmallStat("Water", "3.6L"),
                    _buildSmallStat("Wear", "2.5j"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Graph
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomPaint(
                    painter: GraphPainter(),
                    size: const Size(double.infinity, 200),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Daily M>ealz today
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Daily M>ealz today",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6D4C41),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Meal Items
              _buildMealItem("🧘", "Yoga (7 AM", "Set 3.0 obr", const Color(0xFFFFF3E0)),
              _buildMealItem("🧘", "Yoga≤ (7 AM", "M9dium 9 AM", const Color(0xFFE8F5E9)),
              _buildMealItem("💧", "Drink Water 9 AM", "MMoum 9 AM", const Color(0xFFE3F2FD)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          selectedItemColor: const Color(0xFF8D6E63),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(String label, String value, Color color) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6D4C41),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6D4C41),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6D4C41),
          ),
        ),
      ],
    );
  }

  Widget _buildMealItem(String emoji, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6D4C41),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.brown.shade300,
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Graph Painter
class GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink.shade200
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height * 0.6);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== SCREEN 5: DIET PLAN DETAIL ====================
class DietPlanDetailScreen extends StatefulWidget {
  const DietPlanDetailScreen({super.key});

  @override
  State<DietPlanDetailScreen> createState() => _DietPlanDetailScreenState();
}

class _DietPlanDetailScreenState extends State<DietPlanDetailScreen> {
  bool alarmSet = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF3E0),
        elevation: 0,
        title: Text(
          "Daily Diet Plan",
          style: GoogleFonts.poppins(
            color: const Color(0xFF6D4C41),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6D4C41)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF6D4C41)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Based on your health profile...",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Exercise Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: _buildExerciseCard(
                      "Gentle Yoga for Flexibility",
                      "https://cdn-icons-png.flaticon.com/512/3048/3048398.png",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildExerciseCard(
                      "Low-impact Cardio (20 min)",
                      "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=200&h=200&fit=crop",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Set Alarm Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 183, 163, 133),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.alarm, color: Colors.brown.shade600, size: 24),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Set Alarm",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6D4C41),
                            ),
                          ),
                          Text(
                            "Set remind",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: alarmSet,
                      onChanged: (value) => setState(() => alarmSet = value),
                      activeColor: const Color(0xFFA1887F),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Daily tracker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Daily tracker",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Tracker Items
            _buildTrackerItem("🧘", "Yoga (7 AM", "Set 3.p abi"),
            _buildTrackerItem("💧", "Drink Water", ""),
            _buildTrackerItem("💧", "Drink Water (9 AM)", ""),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFA1887F),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          selectedItemColor: const Color(0xFF8D6E63),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(String title, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: const Color(0xFFE8F5E9),
                  child: Icon(Icons.self_improvement, size: 50, color: Colors.brown.shade300),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6D4C41),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerItem(String emoji, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6D4C41),
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.brown.shade300,
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 6: DIET MANAGER ====================
class DietManagerScreen extends StatefulWidget {
  const DietManagerScreen({super.key});

  @override
  State<DietManagerScreen> createState() => _DietManagerScreenState();
}

class _DietManagerScreenState extends State<DietManagerScreen> {
  int _selectedIndex = 0;
  bool calorieToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF3E0),
        elevation: 0,
        title: Text(
          "Diet Manager",
          style: GoogleFonts.poppins(
            color: const Color(0xFF6D4C41),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6D4C41)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF6D4C41)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Meal Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMealCard(
                      "Low-impact Cardio (30 min)",
                      "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=200&h=200&fit=crop",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildMealCard(
                      "Dw-impæt k+mel (350 cal)",
                      "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&h=200&fit=crop",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // P+egnals Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "P+egnals",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100&h=100&fit=crop",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: const Color(0xFFFFF3E0),
                            child: Icon(Icons.restaurant, color: Colors.brown.shade300),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Calories Today SBBl/900",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6D4C41),
                            ),
                          ),
                          Text(
                            "(30 cal)",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: calorieToggle,
                      onChanged: (value) => setState(() => calorieToggle = value),
                      activeColor: const Color(0xFFA1887F),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Progress Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Progress",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100&h=100&fit=crop",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: const Color(0xFFE8F5E9),
                            child: Icon(Icons.restaurant, color: Colors.brown.shade300),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Calories Today",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6D4C41),
                            ),
                          ),
                          Text(
                            "Diet Adheræance: 90%)",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFA1887F),
                      child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 1) {
              // Navigate to profile or other screen
            }
          },
          selectedItemColor: const Color(0xFF8D6E63),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(String title, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: const Color(0xFFFFF3E0),
                  child: Icon(Icons.restaurant, size: 50, color: Colors.brown.shade300),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6D4C41),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== AI CHAT SCREEN ====================
class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add({
      "sender": "ai",
      "message": "Hello! I'm your AI medical consultant. How can I help you today?\n\nNote: Make sure your Python server is running on http://127.0.0.1:8000"
    });
  }

  Future<void> _askAI() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({"sender": "user", "message": userMessage});
      _isLoading = true;
    });
    _controller.clear();

    try {
      // Try connecting to Python backend (FastAPI on port 8000)
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/chat'), // For emulator use: http://10.0.2.2:8000/chat
        body: jsonEncode({'message': userMessage}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({"sender": "ai", "message": data['response']});
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add({
            "sender": "ai",
            "message": "Server error. Please check if your Python backend is running correctly."
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "sender": "ai",
          "message": "⚠️ Connection Error!\n\nYour Python server is not running.\n\nTo fix this:\n1. Open terminal\n2. Navigate to your Python project folder\n3. Run: python api.py\n4. Make sure it's running on http://127.0.0.1:8000\n\nError: ${e.toString()}"
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF3E0),
        elevation: 0,
        title: Text(
          "AI Medical Consultant",
          style: GoogleFonts.poppins(
            color: const Color(0xFF6D4C41),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6D4C41)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["sender"] == "user";
                
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser 
                          ? const Color(0xFFA1887F) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      message["message"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isUser ? Colors.white : const Color(0xFF6D4C41),
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.brown.shade400,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "AI is typing...",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF3E0),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type your symptoms...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _isLoading ? null : _askAI,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: _isLoading ? Colors.grey.shade300 : const Color(0xFFA1887F),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}