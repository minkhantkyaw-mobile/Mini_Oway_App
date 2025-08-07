import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/driver_screen/driver_login_screen.dart';
import 'package:project_one/theme/theme.dart';
import 'package:project_one/viewModels/driver/driver_signup/driver_signUp_controller.dart';
import 'package:project_one/widgets/custom_scaffold.dart';
import 'package:project_one/widgets/logo.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({super.key});

  @override
  State<DriverSignupScreen> createState() => _DriverSignupScreenState();
}

class _DriverSignupScreenState extends State<DriverSignupScreen> {
  final DriverSignupController signupController = Get.put(
    DriverSignupController(),
  );
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  bool _obsurePassword = true;
  bool _obsureConfirmPassword = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();
  final chooseTownshipController = TextEditingController();

  final List<String> townships = [
    'MahaAungmye Township, Maha Aungmye District,Mandalay Region',
    'Chanayethazan Township, Maha Aungmye District,Mandalay Region',
    "Chanmyathazi Township,Maha Aungmye District,Mandalay Region",
    "Pyigyidagun Township, Maha Aungmye District,Mandalay Region",
    "Aungmyethazan Township,Aungmyethazan District,Mandalay Region",
    "Patheingyi Township,Aungmyethazan District,Mandalay Region",
    "Madaya Township,Aungmyethazan District,Mandalay Region",
    "Amarapura Township,Amarapura District,Mandalay Region",
    "Pyinoolwin Township, Pyin-Oo-Lwin District, Mandalay Region",
    "Thabeikkyin Township,Thabeikkyin District,Mandalay Region",
    "Singu Township,Thabeikkyin District,Mandalay Region",
    "Mogok Township,Thabeikkyin District,Mandalay Region",
    'Kyaukse Township,Kyaukse District, Mandalay Region',
    'Myittha Township, Kyaukse District, Mandalay Region',
    'Sintgaing Township, Kyaukse District, Mandalay Region',
    'Tada-U Township, Tada-U District,Mandalay Region',
    'Ngazun Township, Tada-U District,Mandalay Region',
    'Mahlaing Township,Meiktila District,Mandalay Region',
    'Meiktila Township ,Meiktila District,Mandalay Region',
    'Thazi Township,Meiktila District,Mandalay Region',
    'Wundwin Township,Meiktila District,Mandalay Region',
    'Myingyan Township,Myingyan District,Mandalay Region',
    'Natogyi Township,Myingyan District,Mandalay Region',
    'Taungtha Township,Myingyan District,Mandalay Region',
    'Nyaung-U Township,Nyaung-U District,Mandalay Region',
    'Kyaukpadaung Township,Nyaung-U District,Mandalay Region',
    'Pyawbwe Township,Yamethin District,Mandalay Region',
    'Yamethin Township ,Yamethin District,Mandalay Region',
  ];

  final List<String> vehicleTypes = [
    'Mini Oway',
    'Bike Carry',
    'Car Taxi',
    'Bus',
    'Light Truck',
  ];

  String? selectedVehicle;
  String? selectedTownship;

  String? currentLatitude = "21.9562";
  String? currentLongitude = "96.0823";

  @override
  Widget build(BuildContext context) {
    final DriverSignupController driverSignupController = Get.put(
      DriverSignupController(),
    );
    return CustomScaffold(
      child: Column(
        children: [
          Image.network(
            "https://framerusercontent.com/images/r4bqA98NZdxraufAO0IxKjxH6U.png?scale-down-to=512",
            height: 100,
          ),
          SizedBox(height: 2),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),

                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Create An Account',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),

                      Text(
                        'Fill in your details to get started',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),

                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'Date Time: ${DateTime.now().toString().substring(0, 19)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Full Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Full Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          prefixIcon: Icon(Icons.person),
                          hintText: 'Full Name',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          } else if (!value.contains('@gmail.com')) {
                            return 'Invaild Email (missing @)';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obsurePassword,
                        obscuringCharacter: '*',

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          } else if (value.length > 6) {
                            return 'Password must be at least 6 characters';
                          }

                          final hasUppercase = value.contains(RegExp(r'[A-Z]'));
                          final hasLowercase = value.contains(RegExp(r'[a-z]'));
                          final hasDigit = value.contains(RegExp(r'\d'));
                          final hasSpecialChar = value.contains(
                            RegExp(r'[!@#\$%^&*(),.?":{}|<>]'),
                          );

                          if (!hasUppercase ||
                              !hasLowercase ||
                              !hasDigit ||
                              !hasSpecialChar) {
                            return 'Password must contain at least one uppercase,lowercase,number and special character';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorMaxLines: 2,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obsurePassword = !_obsurePassword;
                              });
                            },
                            icon: _obsurePassword
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      /////////////Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _obsureConfirmPassword,
                        obscuringCharacter: '*',

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Confirm Password';
                          } else if (passwordController.value !=
                              confirmPasswordController.value) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorMaxLines: 2,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obsureConfirmPassword =
                                    !_obsureConfirmPassword;
                              });
                            },
                            icon: _obsureConfirmPassword
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ///////////For Phone
                      TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Phone Number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Phone Number',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      ///select township
                      GestureDetector(
                        onTap: () {
                          _chooseTownshipsDialog(); // You control selection
                        },
                        child: AbsorbPointer(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedTownship,
                            // This is what shows in the UI
                            decoration: InputDecoration(
                              label: const Text(
                                'Choose Your Township',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              prefixIcon: const Icon(Icons.home),
                              hintText: 'Select Township',
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: [
                              if (selectedTownship != null)
                                DropdownMenuItem(
                                  value: selectedTownship,
                                  child: Text(
                                    selectedTownship!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                            ],
                            onChanged: null,
                            // No action — you use custom dialog
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a township';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      //////////For Address
                      TextFormField(
                        controller: addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Other Address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Other Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          prefixIcon: Icon(Icons.home),
                          hintText: 'Other Address',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      ///For Vehicle Types
                      ///
                      GestureDetector(
                        onTap: () {
                          _chooseVheiclesDialog(); // You control selection
                        },
                        child: AbsorbPointer(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedVehicle,
                            // This is what shows in the UI
                            decoration: InputDecoration(
                              label: const Text(
                                'Choose Your Vehicle',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              prefixIcon: const Icon(Icons.home),
                              hintText: 'Select Vehicle',
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: [
                              if (selectedVehicle != null)
                                DropdownMenuItem(
                                  value: selectedVehicle,
                                  child: Text(
                                    selectedVehicle!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                            ],
                            onChanged: null,
                            // No action — you use custom dialog
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a vehicle';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon button with background circle
                              InkWell(
                                onTap: driverSignupController.pickImage,
                                borderRadius: BorderRadius.circular(30),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.photo_camera,
                                    size: 32,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              // Optional label beside icon
                              Text(
                                'Your Vehicles \n Image',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                              ),

                              Spacer(),

                              // Image preview with rounded corners & shadow
                              Obx(() {
                                final image =
                                    driverSignupController.imageFile.value;
                                return Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.grey[200],
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: image != null
                                      ? Image.file(image, fit: BoxFit.cover)
                                      : Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 48,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: lightColorScheme.primary,
                          ),
                          Text(
                            'I agree to the processing of ',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          GestureDetector(
                            child: Text(
                              'Personal Data',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            print("Clicked");

                            final imageFileCheck =
                                driverSignupController.imageFile.value;
                            if (imageFileCheck == null) {
                              Get.snackbar(
                                "Image Required",
                                "Please select a profile image before signing up.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            try {
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                barrierDismissible: false,
                              );
                              final position = await getCurrentLocation();
                              setState(() {
                                currentLatitude = "22.0261";
                                currentLongitude = "96.1095";
                              });
                              Get.snackbar(
                                "Location",
                                "Lat: $currentLatitude, Long: $currentLongitude",
                              );
                            } catch (e) {
                              Get.snackbar("Error", e.toString());
                              print(e);
                            }

                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                barrierDismissible: false,
                              );
                              String? uploadedImageUrl;

                              try {
                                final imageFile =
                                    driverSignupController.imageFile.value;
                                if (imageFile != null) {
                                  uploadedImageUrl =
                                      await DriverSignupController.instance
                                          .uploadToImageKit(imageFile);

                                  if (uploadedImageUrl == null) {
                                    Get.back(); // Close loading
                                    Get.snackbar(
                                      "Upload Error",
                                      "Failed to upload profile image.",
                                    );
                                    return;
                                  }
                                }

                                await DriverSignupController.instance.register(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  currentLatitude.toString(),
                                  currentLongitude.toString(),
                                  selectedVehicle ?? 'Mini Oway',
                                  passwordController.text.trim(),
                                  phoneController.text.trim(),
                                  selectedTownship ?? 'Paleik',
                                  addressController.text.trim(),
                                  context,
                                  profileImageUrl: uploadedImageUrl,
                                );
                              } catch (e) {
                                Get.back(); // Close loading
                                Get.snackbar("Error", e.toString());
                              }
                            } else if (!agreePersonalData) {
                              Get.snackbar(
                                "Warning",
                                "Please agree to the processing of personal data",
                              );
                            }
                          },

                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Logo(icon: FontAwesomeIcons.google)],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(DriverLoginScreen());
                            },
                            child: Text(
                              'Login',

                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _chooseTownshipsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "Select Townships in Mandalay Region",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: townships.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 20,
                      ),
                      title: Text(
                        townships[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: selectedTownship == townships[index]
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedTownship =
                              townships[index]; // 🔥 Set selected item
                        });
                        // Optionally: Update selected township state
                        // setState(() => selectedTownship = townships[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _chooseVheiclesDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "Select Townships in Mandalay Region",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: vehicleTypes.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.car_crash,
                        color: Colors.red,
                        size: 20,
                      ),
                      title: Text(
                        vehicleTypes[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: selectedVehicle == vehicleTypes[index]
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedVehicle =
                              vehicleTypes[index]; // 🔥 Set selected item
                        });
                        // Optionally: Update selected township state
                        // setState(() => selectedTownship = townships[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
