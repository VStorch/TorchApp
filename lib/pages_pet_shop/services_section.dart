import 'package:flutter/material.dart';

class ServicesSection extends StatefulWidget {
  final List<String> serviceOptions;
  final List<String> selectedServices;
  final TextEditingController otherServiceController;

  const ServicesSection({
    super.key,
    required this.serviceOptions,
    required this.selectedServices,
    required this.otherServiceController,
  });

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.toDouble();

    final containerWidth = (screenWidth * 0.9 > 380 ? 380.0 : screenWidth * 0.9);
    final padding = screenWidth * 0.05;
    final spacing = screenWidth * 0.04;
    final fontSizeTitle = screenWidth * 0.045;
    final fontSizeOption = screenWidth * 0.038;
    final borderRadius = padding;

    return Center(
      child: Container(
        width: containerWidth,
        padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.black, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Serviços oferecidos",
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: spacing),
            ...widget.serviceOptions.map((option) => CheckboxListTile(
              title: Text(
                option,
                style: TextStyle(fontSize: fontSizeOption),
              ),
              value: widget.selectedServices.contains(option),
              activeColor: const Color(0xFFF4E04D),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    if (!widget.selectedServices.contains(option)) {
                      widget.selectedServices.add(option);
                    }
                  } else {
                    widget.selectedServices.remove(option);
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding:
              EdgeInsets.symmetric(horizontal: padding / 2),
            )),
            if (widget.selectedServices.contains("Outro"))
              Padding(
                padding: EdgeInsets.only(top: spacing / 2),
                child: TextField(
                  controller: widget.otherServiceController,
                  decoration:
                  const InputDecoration(hintText: "Digite o outro serviço..."),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
