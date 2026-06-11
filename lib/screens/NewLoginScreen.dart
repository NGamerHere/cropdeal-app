import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  bool isOtpSent=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4, // Limits background image to top 40% of screen
            child: Image.asset(
              'assets/images/login_bg.png', // Replace with your actual farm background image path
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/LoginBgIcon.png',
                    width: 210,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "CONNECT. TRADE. GROW",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "India's trusted marketplace for \nfarmers and agri business.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,fontSize: 14),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(25.0),
                    margin: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child:Column(
                      children: [
                        const Text(
                          "Enter Mobile Number",
                          style: TextStyle(fontSize: 23 , fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "We'll send you a 6-digit OTP.",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),

                              const Text(
                                "+91",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),

                              const Icon(Icons.arrow_drop_down),

                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.grey.shade300,
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: "Enter phone number",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Resend OTP",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        if(!isOtpSent)
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: ()=>{
                                setState(() {
                                  isOtpSent = true;
                                })
                              },
                              child: Text("Send OTP",style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                          ),
                        if (isOtpSent) ...[
                          const SizedBox(height: 30),
                          const Text(
                            "Enter OTP",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 23 , fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Enter the 6-digit code send to your mobile number",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 15),
                          Pinput(
                            length: 6,
                            defaultPinTheme: defaultPinTheme,

                            focusedPinTheme: defaultPinTheme.copyDecorationWith(
                              border: Border.all(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),

                            submittedPinTheme: defaultPinTheme,

                            onCompleted: (pin) {
                              print(pin);
                            },
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: ()=>{
                                print("the button is pressed")
                              },
                              child: Text("Submit & Continue",style: TextStyle(color: Colors.white,fontSize: 16),),
                            ),
                          )
                        ]
                      ],
                    ) ,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

final defaultPinTheme = PinTheme(
  width: 55,
  height: 55,
  textStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF243424),
  ),
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.grey.shade300,
    ),
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
  ),
);