import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class SocialMediaSection extends StatelessWidget {
  final TextEditingController instagramController;
  final TextEditingController facebookController;
  final TextEditingController siteController;
  final TextEditingController whatsappController;

  const SocialMediaSection({
    super.key,
    required this.instagramController,
    required this.facebookController,
    required this.siteController,
    required this.whatsappController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.toDouble();

    final containerWidth = (screenWidth * 0.9 > 380 ? 380 : screenWidth * 0.9).toDouble();
    final padding = (screenWidth * 0.05).toDouble();
    final spacing = (screenWidth * 0.04).toDouble();
    final fontSizeTitle = (screenWidth * 0.045).toDouble();
    final fontSizeLabel = (screenWidth * 0.038).toDouble();
    final buttonPaddingH = (screenWidth * 0.04).toDouble();
    final buttonPaddingV = (screenWidth * 0.035).toDouble();
    final borderRadius = (screenWidth * 0.03).toDouble();

    return Center(
      child: Container(
        width: containerWidth,
        padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(padding),
          border: Border.all(color: Colors.black, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Redes sociais",
                style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: spacing),
            const LabelText("Instagram:"),
            CustomTextField(controller: instagramController, hint: "@seudopetshop"),
            const LabelText("Facebook:"),
            CustomTextField(controller: facebookController, hint: "facebook.com/seupetshop"),
            const LabelText("Site (opcional):"),
            CustomTextField(controller: siteController, hint: "www.seupetshop.com.br"),
            const LabelText("WhatsApp comercial:"),
            SizedBox(height: spacing / 2),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(controller: whatsappController, hint: "+55 47 99999-9999"),
                ),
                SizedBox(width: spacing / 2),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4E04D),
                    padding: EdgeInsets.symmetric(horizontal: buttonPaddingH, vertical: buttonPaddingV),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                  ),
                  child: Text(
                    "Testar link",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: fontSizeLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
