import 'package:flutter/material.dart';

class ReceiptLogConfigSection extends StatefulWidget {
  const ReceiptLogConfigSection({super.key});
  @override
  State<ReceiptLogConfigSection> createState() =>
      _ReceiptLogConfigSectionState();
}

class _ReceiptLogConfigSectionState extends State<ReceiptLogConfigSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Receipt Log Config Section'),
        ],
      ),
    );
  }
}
