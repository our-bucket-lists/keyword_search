import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyBasicFilter extends StatefulWidget {
  const MyBasicFilter({super.key});

  @override
  State<MyBasicFilter> createState() => _MyBasicFilterState();
}

class _MyBasicFilterState extends State<MyBasicFilter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: TextFormField(
              controller: TextEditingController(),
              obscureText: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              decoration: InputDecoration(
                // disabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(8.0),
                //   borderSide:
                //       BorderSide(color: Colors.red, width: 100),
                // ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: Colors.white.withAlpha(40), width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                      BorderSide(color: Colors.white.withAlpha(80), width: 2),
                ),
                hintText: "創作者",
                hintStyle: TextStyle(
                  // fontWeight: FontWeight.w400,
                  // fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                filled: true,
                fillColor: Colors.white.withAlpha(40),
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
          const SizedBox(width: 16,),
          SizedBox(
            width: 160,
            child: TextFormField(
              controller: TextEditingController(),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              obscureText: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              decoration: InputDecoration(
                // disabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(8.0),
                //   borderSide:
                //       BorderSide(color: Colors.red, width: 100),
                // ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: Colors.white.withAlpha(40), width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                      BorderSide(color: Colors.white.withAlpha(80), width: 2),
                ),
                hintText: "觀看數",
                hintStyle: TextStyle(
                  // fontWeight: FontWeight.w400,
                  // fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                filled: true,
                fillColor: Colors.white.withAlpha(40),
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
