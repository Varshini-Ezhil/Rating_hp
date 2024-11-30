// main.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // For shared preferences
import 'package:http/http.dart' as http; // Add this import for HTTP requests

class AppColors {
  static const primary = Color(0xFF004E8F);
  static const secondary = Color(0xFFDF1A14);
  static const background = Color(0xFFF5F7FA);
  static const cardBackground = Colors.white;
  static const textPrimary = Color(0xFF2D3142);
  static const textSecondary = Color(0xFF9C9EB9);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true; // Check if it's the first launch

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false); // Set to false for future launches
  }

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MyApp({Key? key, required this.isFirstLaunch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HP Petrol Bunk',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
      ),
      home:  SplashScreen()  // Navigate based on first launch
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a loading period
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to MyHomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010269), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with your logo image
            Image.asset('assets/HP_round_logo.png', height: 250), // Logo
            const SizedBox(height: 20),
            const Text(
              'Hindustan Petroleum ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.white,
            ), // Loading animation
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _bunkNameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _bunkNameController.addListener(_validateForm);
    _locationController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _bunkNameController.text.isNotEmpty && 
                     _locationController.text.isNotEmpty;
    });
  }

  void _saveConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bunkName', _bunkNameController.text);
    await prefs.setString('location', _locationController.text);

    // Navigate to CreateResponsePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreateResponsePage(
          bunkName: _bunkNameController.text,
          location: _locationController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF004E8F),  // HP Blue
              Color(0xFF003366),  // Darker blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Logo Section
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/HP_round_logo.png',
                        height: 150,
                        width: 150,
                        
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      'Hindustan Petroleum ',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 40),
                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004E8F),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Bunk Name Field
                          TextFormField(
                            controller: _bunkNameController,
                            decoration: InputDecoration(
                              labelText: 'Petrol Bunk Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(
                                Icons.local_gas_station,
                                color: Color(0xFF004E8F),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              labelStyle: TextStyle(color: Colors.grey.shade600),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your petrol bunk name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Location Field
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: 'Location',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(
                                Icons.location_on,
                                color: Color(0xFF004E8F),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              labelStyle: TextStyle(color: Colors.grey.shade600),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your location';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isFormValid
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        _saveConfiguration();
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDF1A14),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: Colors.grey.shade300,
                                disabledForegroundColor: Colors.grey.shade600,
                                elevation: 2,
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bunkNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}







class CreateResponsePage extends StatefulWidget {
  final String bunkName;
  final String location;

  const CreateResponsePage({Key? key, required this.bunkName, required this.location}) : super(key: key);

  @override
  State<CreateResponsePage> createState() => _CreateResponsePageState();
}

class _CreateResponsePageState extends State<CreateResponsePage> {
  final _phoneController = TextEditingController();
  double _customerServiceRating = 0;

  String? _airPump;
  String? _toilets;
  String? _cng;
  String? _electricCharging;
  String? _boi;
  String? _shield;

  // Add your Google Sheets API URL and credentials here
  final String _sheetId = '1TuZrv7fxEH-Jib_xOb7N6hTnhr1cFOLIWeYkSQukQVc'; // Replace with your Google Sheet ID
  final String _apiKey = '8acc17263f6e5e1fe81a232cce2cf367e664b070'; // Replace with your API key

  // Method to send response to Google Sheets
  Future<void> _sendResponseToSheet(BunkResponse response) async {
    //final url = 'https://sheets.googleapis.com/v4/spreadsheets/1TuZrv7fxEH-Jib_xOb7N6hTnhr1cFOLIWeYkSQukQVc/values/response!A1:append?valueInputOption=USER_ENTERED&key=8acc17263f6e5e1fe81a232cce2cf367e664b070'; // Adjust the range as needed

    final response = BunkResponse(
      timestamp: DateTime.now(),
      bunkName: widget.bunkName,
      location: widget.location,
            facilities: {
        'Air Pump Working': _airPump == 'yes',
        'Toilets Were Clean': _toilets == 'yes',
        'CNG Available': _cng == 'yes',
        'Electric Charging': _electricCharging == 'yes',
        'Air BOI Available': _boi == 'yes',
        'Windshield Cleaning': _shield == 'yes',
      },
      rating: _customerServiceRating.toInt(),
      phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text:null,




    );

    final body = {
      "values": [
        
          response.timestamp.toIso8601String(),
          response.bunkName,
          response.location,
          response.rating,
          response.phoneNumber ?? '', // Use an empty string if phoneNumber is null
           // Convert facilities map to JSON string
        
      ]
      ,"facilities" : jsonEncode(response.facilities),
    };

    final request = await http.post(
      Uri.parse("https://sea-lion-app-dkjy3.ondigitalocean.app/"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (request.statusCode == 200) {
      print('Response sent to Google Sheets successfully!');
    } else {
      print('Failed to send response: ${request.body}');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(8.0), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate Your Experience',
            style: TextStyle(
              fontSize: 28, // Reduced font size
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 5), // Reduced height
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _customerServiceRating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _customerServiceRating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.green[700],
                    size: 50, // Reduced size
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10), // Reduced height
          const Text(
            'Available Facilities',
            style: TextStyle(
              fontSize: 20, // Reduced font size
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
           // Reduced height
          Column(
            children: [
              _buildFacilityOption(
                'Air pump working',
                _airPump,
                (value) => setState(() => _airPump = value),
              ),
              _buildFacilityOption(
                'Toilets were clean',
                _toilets,
                (value) => setState(() => _toilets = value),
              ),
              _buildFacilityOption(
                'Air boi was readily available',
                _boi,
                (value) => setState(() => _boi = value),
              ),
              _buildFacilityOption(
                'CNG',
                _cng,
                (value) => setState(() => _cng = value),
              ),
              _buildFacilityOption(
                'Windshield cleaning done',
                _shield,
                (value) => setState(() => _shield = value),
              ),
              _buildFacilityOption(
                'Electric Charging',
                _electricCharging,
                (value) => setState(() => _electricCharging = value),
              ),
            ],
          ),
          const SizedBox(height: 10), // Reduced height
          const Text(
            'Contact Number (Optional)',
            style: TextStyle(
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 5), // Reduced height
           TextFormField(
             controller: _phoneController,
             keyboardType: TextInputType.phone,
             decoration: InputDecoration(
               hintText: 'Enter your phone number',
               filled: true,
               fillColor: Colors.white,
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(8),
                 borderSide: BorderSide(color: Colors.grey.shade200),
               ),
               prefixIcon: const Icon(
                 Icons.phone,
                 color: AppColors.primary,
               ),
             ),
           ),
          const SizedBox(height: 10), // Reduced height
          SizedBox(
            width: double.infinity,
            height: 50, // Reduced height
            child: ElevatedButton(
              onPressed: () {
                if (_customerServiceRating > 0 &&
                    _airPump != null &&
                    _toilets != null &&
                    _cng != null &&
                    _electricCharging != null &&
                    _boi != null &&
                    _shield != null) {
                  
                  final responseto = BunkResponse(
                    timestamp: DateTime.now(),
      bunkName: widget.bunkName,
      location: widget.location,
            facilities: {
        'Air Pump Working': _airPump == 'yes',
        'Toilets Were Clean': _toilets == 'yes',
        'CNG Available': _cng == 'yes',
        'Electric Charging': _electricCharging == 'yes',
        'Air BOI Available': _boi == 'yes',
        'Windshield Cleaning': _shield == 'yes',
      },
      rating: _customerServiceRating.toInt(),
      phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text:null,
                  );

                      // Send response to Google Sheets
                      _sendResponseToSheet(responseto);

                      // Here you can save the response to SharedPreferences or any other storage
                      // For now, we will just clear the fields for the next response
                      setState(() {
                        _customerServiceRating = 0;
                        _airPump = null;
                        _toilets = null;
                        _cng = null;
                        _electricCharging = null;
                        _boi = null;
                        _shield = null;
                        _phoneController.clear();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Response submitted successfully!'),
                          backgroundColor: Color(0xFF4CAF50),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields'),
                          backgroundColor: Color(0xFFDF1A14),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDF1A14),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Submit Response',
                style: TextStyle(
                  fontSize: 16, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  // Helper method to build facility options
  Widget _buildFacilityOption(String title, String? selectedValue, Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          
          Row(
            children: [
              Expanded(
                child: buildOptionButton('Yes', selectedValue == 'yes', () => onChanged('yes'), Colors.green),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: buildOptionButton('No', selectedValue == 'no', () => onChanged('no'), Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build option buttons
  Widget buildOptionButton(String text, bool isSelected, VoidCallback onTap, Color color) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: isSelected ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// Define the BunkResponse class here
class BunkResponse {
  final String bunkName;
  final String location;
  final DateTime timestamp;
  final int rating;
  final String? phoneNumber;
  final Map<String, bool> facilities;

  BunkResponse({
    required this.bunkName,
    required this.location,
    required this.timestamp,
    required this.rating,
    this.phoneNumber,
    required this.facilities,
  });

  factory BunkResponse.fromJson(Map<String, dynamic> json) {
    return BunkResponse(
      bunkName: json['bunkName'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      rating: json['rating'],
      phoneNumber: json['phoneNumber'],
      facilities: Map<String, bool>.from(json['facilities']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bunkName': bunkName,
      'location': location,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to String
      'rating': rating,
      'phoneNumber': phoneNumber,
      'facilities': facilities,
    };
  }
}