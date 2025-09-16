import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../bloc/txn_bloc.dart';
import '../model/txn_model.dart';

enum TransactionType { income, expense }

class TransactionFormPage extends StatefulWidget {
  final TransactionType transactionType;

  const TransactionFormPage({super.key, required this.transactionType});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  // ...existing code...

  Future<void> _pickAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final pickedFile = File(result.files.single.path!);
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = result.files.single.name;
        final savedFile = await pickedFile.copy('${appDir.path}/$fileName');
        setState(() {
          _attachmentPath = savedFile.path;
          _attachmentFileName = fileName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attachment added: $fileName')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add attachment: $e')),
      );
    }
  }

  /* Future<void> _pickAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final pickedFile = File(result.files.single.path!);
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = result.files.single.name;
        final savedFile = await pickedFile.copy('${appDir.path}/$fileName');
        setState(() {
          _attachmentPath = savedFile.path;
          _attachmentFileName = fileName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attachment added: $fileName')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add attachment: $e')),
      );
    }
  } */

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedWallet;
  bool _isRepeatEnabled = false;

  String? _attachmentPath;
  String? _attachmentFileName;

  Color get _primaryColor => widget.transactionType == TransactionType.income
      ? const Color(0xFF10B981)
      : const Color(0xFFEF4444);

  String get _title => widget.transactionType == TransactionType.income ? 'Income' : 'Expense';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Amount Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How much?',
                  style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '₹',
                      style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w600),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Form Section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Category Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Category',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items:
                              [
                                'Food & Dining',
                                'Shopping',
                                'Entertainment',
                                'Bills & Utilities',
                                'Transportation',
                                'Health & Medical',
                                'Travel',
                                'Others',
                              ].map((String category) {
                                return DropdownMenuItem<String>(value: category, child: Text(category));
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description Field
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Description',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Wallet Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedWallet,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Wallet',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: ['Cash', 'Bank Account', 'Credit Card', 'Digital Wallet'].map((String wallet) {
                            return DropdownMenuItem<String>(value: wallet, child: Text(wallet));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedWallet = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Add Attachment
                      InkWell(
                        onTap: () => _pickAttachment(),
                        child: Row(
                          children: [
                            Icon(Icons.attach_file, color: Colors.grey.shade600, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              _attachmentFileName != null ? _attachmentFileName! : 'Add attachment',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
  
                      // Repeat Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Repeat',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                              Text('Repeat transaction', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                            ],
                          ),
                          Switch(
                            value: _isRepeatEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _isRepeatEnabled = value;
                              });
                            },
                            activeColor: _primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _handleContinue();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  void _handleContinue() {
    // Handle form submission
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    if (_selectedWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a wallet')));
      return;
    }

    // Process the transaction
    print('Transaction Type: ${widget.transactionType}');
    print('Amount: ₹$amount');
    print('Category: $_selectedCategory');
    print('Description: ${_descriptionController.text}');
    print('Wallet: $_selectedWallet');
    print('Repeat: $_isRepeatEnabled');
    print('Attachment Path: $_attachmentPath');

TransactionModel txnData = TransactionModel(
      amount: amount,
      category: _selectedCategory!,
      description: _descriptionController.text,
      wallet: _selectedWallet!,
      attachmentPath: _attachmentPath,
      type: widget.transactionType == TransactionType.income ? 'income' : 'expense',
      date: DateTime.now(), walletId: 0,
    );

    context.read<TxnBloc>().add(CreateTxnEvent(txnData: txnData));
    context.pop();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// Example usage:
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionFormPage(transactionType: TransactionType.income)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
              child: const Text('Add Income'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionFormPage(transactionType: TransactionType.expense)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
