import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:flutter/services.dart';
import '../data/app_state.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final addressController = TextEditingController(text: AppState.address);
  final phoneController = TextEditingController(text: AppState.phone);
  final emailController = TextEditingController(text: AppState.email);

  String shipping = "Standard";
  String paymentMethod = AppState.paymentMethod;

  InputDecoration fieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
      filled: true,
      fillColor: context.inputFillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1450F0)),
      ),
    );
  }

  void showEditAddressPopup() {
    final editController = TextEditingController(text: addressController.text);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          'Edit Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        content: TextField(
          controller: editController,
          maxLines: 3,
          decoration: fieldStyle('Enter address'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                addressController.text = editController.text.trim();
                AppState.address = editController.text.trim();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1450F0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void showEditContactPopup() {
    final phoneEdit = TextEditingController(text: phoneController.text);
    final emailEdit = TextEditingController(text: emailController.text);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          'Edit Contact Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneEdit,
              decoration: fieldStyle('Phone'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailEdit,
              decoration: fieldStyle('Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                phoneController.text = phoneEdit.text.trim();
                emailController.text = emailEdit.text.trim();
                AppState.phone = phoneEdit.text.trim();
                AppState.email = emailEdit.text.trim();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1450F0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void showPaymentPopup() {
    String tempPayment = paymentMethod;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          'Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setInnerState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    value: 'Card',
                    groupValue: tempPayment,
                    title: const Text('Card'),
                    onChanged: (value) {
                      setInnerState(() {
                        tempPayment = value!;
                      });
                    },
                  ),
                  if (tempPayment == 'Card')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card number *',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textColor),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            decoration: fieldStyle('0000 0000 0000 0000').copyWith(
                              suffixIcon: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'VISA',
                                    style: TextStyle(
                                      color: Color(0xFF1450F0),
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                              CardNumberFormatter(),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Expiration date *',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textColor),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 120,
                            child: TextField(
                              decoration: fieldStyle('MM/YY'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                ExpiryDateFormatter(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Security code *',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textColor),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  decoration: fieldStyle('CVV'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.credit_card, color: Colors.grey),
                              const SizedBox(width: 6),
                              const Expanded(
                                child: Text(
                                  '3 digits on back of card',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  RadioListTile<String>(
                    value: 'Cash on Delivery',
                    groupValue: tempPayment,
                    title: const Text('Cash on Delivery'),
                    onChanged: (value) {
                      setInnerState(() {
                        tempPayment = value!;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                paymentMethod = tempPayment;
                AppState.paymentMethod = tempPayment;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1450F0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void goToSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const PaymentSuccess(),
      ),
    );
  }

  Widget infoCard({
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: context.highlightBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle.isEmpty ? 'Not added yet' : subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.subTextColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF1450F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: context.cardColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: context.cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    item['images'][0],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: context.secondaryBgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${item['qty']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              item['name'],
              style: TextStyle(
                fontSize: 17,
                color: context.textColor,
              ),
            ),
          ),
          Text(
            AppState.formatMoney((item['price'] as int) * (item['qty'] as int)),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget shippingOption({
    required String value,
    required String title,
    required String subtitle,
    required String priceText,
  }) {
    final selected = shipping == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          shipping = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selected ? context.secondaryBgColor : context.highlightBgColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_off,
              color: selected
                  ? const Color(0xFF1450F0)
                  : const Color(0xFFD0D5DD),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF1450F0),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              priceText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: context.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = AppState.activeCheckoutItems;
    final shippingCharge = shipping == "Express" ? 500 : 0;
    final total = AppState.checkoutTotal + shippingCharge;

    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: context.cardColor,
        foregroundColor: context.textColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'No items selected',
                style: TextStyle(fontSize: 18),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoCard(
                    title: 'Shipping Address',
                    subtitle: addressController.text,
                    onEdit: showEditAddressPopup,
                  ),
                  infoCard(
                    title: 'Contact Information',
                    subtitle:
                        '${phoneController.text.isEmpty ? '' : phoneController.text}\n${emailController.text.isEmpty ? '' : emailController.text}'.trim(),
                    onEdit: showEditContactPopup,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Items',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: context.textColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: context.secondaryBgColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${items.length}',
                          style: TextStyle(
                            color: context.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ...items.map((item) => productItem(item)),
                  const SizedBox(height: 18),
                  Text(
                    'Shipping Options',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  shippingOption(
                    value: 'Standard',
                    title: 'Standard',
                    subtitle: '5-7 days',
                    priceText: 'FREE',
                  ),
                  shippingOption(
                    value: 'Express',
                    title: 'Express',
                    subtitle: '1-2 days',
                    priceText: 'Rs 500',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.textColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: showPaymentPopup,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1450F0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: context.cardColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: showPaymentPopup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: context.secondaryBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        paymentMethod,
                        style: const TextStyle(
                          color: Color(0xFF1450F0),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total ${AppState.formatMoney(total)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.textColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: items.isNotEmpty ? goToSuccess : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1450F0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Pay',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: context.bgColor,
        foregroundColor: context.textColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.highlightBgColor,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 80,
                color: Color(0xFF1450F0),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1450F0),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                AppState.completePayment();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              child: const Text('Back to Home'),
            )
          ],
        ),
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length && nonZeroIndex == 2) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}