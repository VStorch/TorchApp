import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torch_app/pages/login_page.dart';
import '../components/custom_drawer_pet_shop.dart';
import 'pix_settings_page.dart';

class Settings extends StatefulWidget {
  final int petShopId;
  final int userId;

  const Settings({
    super.key,
    required this.petShopId,
    required this.userId,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;
  final Color corCardFundo = const Color(0xFFFFF59D);
  final Color corCardIcon = const Color(0xFFFFF9C4);

  bool notificationsEnabled = true;
  bool notifyNewAppointments = true;
  bool notifyAppointmentChanges = true;
  bool notifyNewReviews = true;
  bool notifyPromotions = true;
  bool notifyPayments = true;
  String currentLanguage = 'Português';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      notifyNewAppointments = prefs.getBool('notify_new_appointments') ?? true;
      notifyAppointmentChanges = prefs.getBool('notify_appointment_changes') ?? true;
      notifyNewReviews = prefs.getBool('notify_new_reviews') ?? true;
      notifyPromotions = prefs.getBool('notify_promotions') ?? true;
      notifyPayments = prefs.getBool('notify_payments') ?? true;
      currentLanguage = prefs.getString('language') ?? 'Português';
    });
  }

  Future<void> _saveNotificationPreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      currentLanguage = language;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Idioma alterado para $language'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: corFundo,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: corPrimaria, width: 3),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: corPrimaria,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications_active, size: 28, color: corTexto),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Configurar Notificações',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Escolha o que você deseja ser notificado',
                  style: TextStyle(
                    fontSize: 14,
                    color: corTexto.withOpacity(0.7),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildNotificationOption(
                      icon: Icons.event_available,
                      title: 'Novos Agendamentos',
                      subtitle: 'Receba notificações quando clientes marcarem serviços',
                      value: notifyNewAppointments,
                      onChanged: (value) {
                        setModalState(() => notifyNewAppointments = value);
                        setState(() => notifyNewAppointments = value);
                        _saveNotificationPreference('notify_new_appointments', value);
                      },
                      color: Colors.green,
                    ),

                    _buildNotificationOption(
                      icon: Icons.edit_calendar,
                      title: 'Alterações em Agendamentos',
                      subtitle: 'Notificações de cancelamentos, confirmações e conclusões',
                      value: notifyAppointmentChanges,
                      onChanged: (value) {
                        setModalState(() => notifyAppointmentChanges = value);
                        setState(() => notifyAppointmentChanges = value);
                        _saveNotificationPreference('notify_appointment_changes', value);
                      },
                      color: Colors.orange,
                    ),

                    _buildNotificationOption(
                      icon: Icons.star_rate,
                      title: 'Novas Avaliações',
                      subtitle: 'Saiba quando clientes avaliarem seus serviços',
                      value: notifyNewReviews,
                      onChanged: (value) {
                        setModalState(() => notifyNewReviews = value);
                        setState(() => notifyNewReviews = value);
                        _saveNotificationPreference('notify_new_reviews', value);
                      },
                      color: Colors.amber,
                    ),

                    _buildNotificationOption(
                      icon: Icons.payment,
                      title: 'Pagamentos',
                      subtitle: 'Notificações sobre pagamentos recebidos',
                      value: notifyPayments,
                      onChanged: (value) {
                        setModalState(() => notifyPayments = value);
                        setState(() => notifyPayments = value);
                        _saveNotificationPreference('notify_payments', value);
                      },
                      color: Colors.blue,
                    ),

                    _buildNotificationOption(
                      icon: Icons.local_offer,
                      title: 'Promoções e Cupons',
                      subtitle: 'Quando clientes usarem seus cupons de desconto',
                      value: notifyPromotions,
                      onChanged: (value) {
                        setModalState(() => notifyPromotions = value);
                        setState(() => notifyPromotions = value);
                        _saveNotificationPreference('notify_promotions', value);
                      },
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corPrimaria,
                      foregroundColor: corTexto,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preferências de notificação salvas!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Salvar Preferências',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: value ? color : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: corTexto,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: corTexto.withOpacity(0.7),
            ),
          ),
        ),
        value: value,
        activeColor: color,
        onChanged: onChanged,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: corFundo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: corPrimaria, width: 3),
        ),
        title: Row(
          children: [
            Icon(Icons.language, color: corTexto),
            const SizedBox(width: 12),
            const Text('Escolha o idioma'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('🇧🇷 Português'),
              value: 'Português',
              groupValue: currentLanguage,
              activeColor: corPrimaria,
              onChanged: (value) {
                if (value != null) {
                  _saveLanguagePreference(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('🇺🇸 English'),
              value: 'English',
              groupValue: currentLanguage,
              activeColor: corPrimaria,
              onChanged: (value) {
                if (value != null) {
                  _saveLanguagePreference(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('🇪🇸 Español'),
              value: 'Español',
              groupValue: currentLanguage,
              activeColor: corPrimaria,
              onChanged: (value) {
                if (value != null) {
                  _saveLanguagePreference(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final barHeight = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: corFundo,
      drawer: CustomDrawerPetShop(
        petShopId: widget.petShopId,
        userId: widget.userId,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(barHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: corPrimaria,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: -10,
                  top: -6,
                  bottom: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.pets, size: barHeight * 0.8, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: barHeight * 0.6,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ListView(
          children: [
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.notifications_active,
              title: "Notificações",
              subtitle: notificationsEnabled
                  ? "Ativadas - Toque para configurar"
                  : "Desativadas",
              trailing: Switch(
                value: notificationsEnabled,
                activeColor: corPrimaria,
                onChanged: (value) async {
                  setState(() => notificationsEnabled = value);
                  await _saveNotificationPreference('notifications_enabled', value);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value
                          ? 'Notificações ativadas'
                          : 'Notificações desativadas'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              onTap: notificationsEnabled ? _showNotificationSettings : null,
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.pix,
              title: "Configurações PIX",
              subtitle: "Configure seus dados para receber pagamentos",
              iconColor: Colors.teal[700],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PixSettingsPage(
                      petShopId: widget.petShopId,
                      userId: widget.userId,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.language,
              title: "Idioma",
              subtitle: currentLanguage,
              onTap: _showLanguageDialog,
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.info_outline,
              title: "Sobre o app",
              subtitle: "Versão 1.0.0",
              onTap: () => showAboutDialog(
                context: context,
                applicationName: "PetShop App",
                applicationVersion: "1.0.0",
                applicationIcon: Icon(Icons.pets, size: screenHeight * 0.06, color: Colors.black),
                children: [
                  Text(
                    "Este app ajuda você a gerenciar seu pet shop com facilidade e rapidez.",
                    style: TextStyle(fontSize: screenHeight * 0.02),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.logout,
              title: "Sair",
              subtitle: "Voltar para a tela de login",
              iconColor: Colors.red,
              titleColor: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sair'),
                    content: const Text('Deseja realmente sair da sua conta?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                                (route) => false,
                          );
                        },
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required double screenHeight,
    required double screenWidth,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      color: corCardFundo,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.012,
        ),
        leading: Container(
          decoration: BoxDecoration(
            color: corCardIcon,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(screenHeight * 0.015),
          child: Icon(
            icon,
            size: screenHeight * 0.035,
            color: iconColor ?? Colors.black,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: titleColor ?? corTexto,
            fontSize: screenHeight * 0.022,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(
            color: corTexto.withOpacity(0.7),
            fontSize: screenHeight * 0.018,
          ),
        )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}