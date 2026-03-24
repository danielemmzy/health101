// screens/add_card_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF333333), size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Card",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child: CartScreen()),
                );
              },
              child: Stack(
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        "7",
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CARD PREVIEW (YOUR STYLE)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFF339CFF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: Offset(0, 6)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Type Icon
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.credit_card, color: Colors.white, size: 36),
                    ),
                    SizedBox(height: 20),

                    // Card Number
                    Text(
                      _cardNumberController.text.isEmpty
                          ? "**** **** **** 2187"
                          : _formatCardNumber(_cardNumberController.text),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Card Holder & Expiry
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CARD HOLDER",
                              style: TextStyle(color: Colors.white70, fontSize: 10.sp, letterSpacing: 1),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _cardHolderController.text.isEmpty
                                  ? "AMELIA RENATA"
                                  : _cardHolderController.text.toUpperCase(),
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "EXPIRES",
                              style: TextStyle(color: Colors.white70, fontSize: 10.sp, letterSpacing: 1),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _expiryController.text.isEmpty ? "MM/YY" : _expiryController.text,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // FORM FIELDS
              _buildInputField(
                label: "Card Number",
                controller: _cardNumberController,
                hint: "1234 5678 9012 3456",
                keyboardType: TextInputType.number,
                maxLength: 19,
                onChanged: (_) => setState(() {}),
              ),
              _buildInputField(
                label: "Card Holder Name",
                controller: _cardHolderController,
                hint: "Amelia Renata",
                onChanged: (_) => setState(() {}),
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: "Expiry Date",
                      controller: _expiryController,
                      hint: "MM/YY",
                      keyboardType: TextInputType.datetime,
                      maxLength: 5,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      label: "CVV",
                      controller: _cvvController,
                      hint: "123",
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      obscureText: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              // ADD CARD BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF339CFF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 4,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Card added successfully!"),
                          backgroundColor: Color(0xFF339CFF),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add Card",
                    style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool obscureText = false,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLength: maxLength,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15.sp),
              filled: true,
              fillColor: Color(0xFFF5F5F5),
              counterText: "",
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Color(0xFF339CFF), width: 2),
              ),
            ),
            style: GoogleFonts.inter(fontSize: 15.sp),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  String _formatCardNumber(String number) {
    final cleaned = number.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(cleaned[i]);
    }
    return buffer.toString();
  }
}