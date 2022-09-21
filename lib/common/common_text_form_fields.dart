import 'package:flutter/material.dart';
import 'package:serviceprovider/common/common_styles.dart';

mobileNumberTextFormField(GlobalKey<FormState> mobileKey,
    TextEditingController mobileController, bool enabled) {
  return Form(
    key: mobileKey,
    child: TextFormField(
      controller: mobileController,
      enabled: enabled,
      keyboardType: TextInputType.number,
      maxLength: 14,
      style: CommonStyles.whiteText12BoldW500(),
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Mobile Number'.toUpperCase(),
        prefixStyle: const TextStyle(color: Colors.black),
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        disabledBorder: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
  );
}

class MobileNoTextField extends StatelessWidget {
  const MobileNoTextField(
      {Key? key,
      required this.enabled,
      required this.mobileController,
      required this.mobileKey})
      : super(key: key);
  final GlobalKey<FormState> mobileKey;
  final TextEditingController mobileController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: mobileKey,
      child: TextFormField(
        controller: mobileController,
        enabled: enabled,
        keyboardType: TextInputType.number,
        maxLength: 13,
        style: CommonStyles.black13(),
        validator: (value) {
          if (value!.length != 10) {
            return "Must have 10 digits.";
          }
          return null;
        },
        decoration: InputDecoration(
          errorStyle: CommonStyles.red9(),
          isDense: true,
          labelText: 'Mobile Number'.toUpperCase(),
          helperText: "",
          counterText: "",
          helperStyle: CommonStyles.black13(),
          prefixStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          disabledBorder: InputBorder.none,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class NameTextForm extends StatelessWidget {
  const NameTextForm(
      {Key? key,
      required this.nameController,
      required this.nameKey,
      required this.edit})
      : super(key: key);
  final TextEditingController nameController;
  final GlobalKey<FormState> nameKey;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: nameKey,
      child: TextFormField(
        controller: nameController,
        enabled: edit,
        keyboardType: TextInputType.name,
        style: CommonStyles.black13(),
        validator: (value) {
          if (value!.length < 3) {
            return "Enter a valid name";
          }
          return null;
        },
        // initialValue: vendorProfile.retailerName,
        decoration: InputDecoration(
          isDense: true,
          labelText: 'Name'.toUpperCase(),
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          disabledBorder: InputBorder.none,
          errorStyle: CommonStyles.whiteText12BoldW500(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class EmailTextForm extends StatelessWidget {
  const EmailTextForm(
      {Key? key,
      required this.emailController,
      required this.emailKey,
      required this.edit})
      : super(key: key);
  final TextEditingController emailController;
  final GlobalKey<FormState> emailKey;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: emailKey,
      child: TextFormField(
        controller: emailController,
        enabled: edit,
        keyboardType: TextInputType.emailAddress,
        style: CommonStyles.black13(),

        validator: (value) {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value!)) {
            return "Enter Valid email";
          }
          return null;
        },
        // initialValue: vendorProfile.email,
        decoration: InputDecoration(
          isDense: true,
          labelText: 'Email'.toUpperCase(),
          errorStyle: CommonStyles.red9(),
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          disabledBorder: InputBorder.none,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class LandMarkTextForm extends StatelessWidget {
  const LandMarkTextForm(
      {Key? key,
      required this.landMarkController,
      required this.landMarkKey,
      required this.edit})
      : super(key: key);
  final TextEditingController landMarkController;
  final GlobalKey<FormState> landMarkKey;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: landMarkKey,
      child: TextFormField(
        controller: landMarkController,
        enabled: edit,
        keyboardType: TextInputType.name,
        style: CommonStyles.black13(),
        validator: (value) {
          if (value!.length < 3) {
            return "Enter a valid LandMark";
          }
          return null;
        },
        // initialValue: vendorProfile.retailerName,
        decoration: InputDecoration(
          isDense: true,
          // labelText: 'LandMark'.toUpperCase(),
          /* labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),*/
          disabledBorder: InputBorder.none,
          errorStyle: CommonStyles.whiteText12BoldW500(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class AccountNumber extends StatelessWidget {
  const AccountNumber(
      {Key? key,
      required this.accountNumberController,
      required this.accountNumberKey,
      required this.edit})
      : super(key: key);
  final TextEditingController accountNumberController;
  final GlobalKey<FormState> accountNumberKey;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: accountNumberKey,
      child: TextFormField(
        controller: accountNumberController,
        enabled: edit,
        keyboardType: TextInputType.number,
        style: CommonStyles.black13(),
        validator: (value) {
          if (value!.length < 10) {
            return "Enter a valid Account Number";
          }
          return null;
        },
        // initialValue: vendorProfile.retailerName,
        decoration: InputDecoration(
          isDense: true,
          labelText: 'Account Number'.toUpperCase(),
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          disabledBorder: InputBorder.none,
          errorStyle: CommonStyles.whiteText12BoldW500(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class AccountName extends StatelessWidget {
  const AccountName(
      {Key? key,
      required this.accountNameController,
      required this.accountNameKey,
      required this.edit})
      : super(key: key);
  final TextEditingController accountNameController;
  final GlobalKey<FormState> accountNameKey;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: accountNameKey,
      child: TextFormField(
        controller: accountNameController,
        enabled: edit,
        keyboardType: TextInputType.number,
        style: CommonStyles.black13(),
        validator: (value) {
          if (value!.length < 3) {
            return "Enter a valid Account Name";
          }
          return null;
        },
        // initialValue: vendorProfile.retailerName,
        decoration: InputDecoration(
          isDense: true,
          labelText: 'Account Name'.toUpperCase(),
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          disabledBorder: InputBorder.none,
          errorStyle: CommonStyles.whiteText12BoldW500(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class AccountIFSC extends StatelessWidget {
  const AccountIFSC(
      {Key? key,
      required this.accountIFSCController,
      required this.accountIFSCKey,
      required this.edit})
      : super(key: key);
  final TextEditingController accountIFSCController;
  final GlobalKey<FormState> accountIFSCKey;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: accountIFSCKey,
      child: TextFormField(
        controller: accountIFSCController,
        enabled: edit,
        keyboardType: TextInputType.number,
        style: CommonStyles.black13(),
        validator: (value) {
          if (value!.length < 3) {
            return "Enter a valid Account Name";
          }
          return null;
        },
        // initialValue: vendorProfile.retailerName,
        decoration: InputDecoration(
          isDense: true,
          labelText: 'IFSC Code'.toUpperCase(),
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          disabledBorder: InputBorder.none,
          errorStyle: CommonStyles.whiteText12BoldW500(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
