import 'package:flutter/material.dart';
import 'package:maqueta/features/carnet/data/models/user.dart';
import 'package:maqueta/features/carnet/domain/providers/card_provider.dart';
import 'package:maqueta/features/carnet/presentation/page/qr_modal.dart';
import 'package:maqueta/core/widgets/home_app_bar.dart';
import 'package:maqueta/core/widgets/info_column.dart';
import 'package:provider/provider.dart';

class CarnetPage extends StatefulWidget {
  const CarnetPage({super.key});

  @override
  State<CarnetPage> createState() => _CarnetPageState();
}

class _CarnetPageState extends State<CarnetPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: userProvider.fetchUserData, // Reload data on pull
        child: ListView(
          children: [
            const HomeAppBar(),
            if (userProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (userProvider.error != null)
              _buildError(userProvider.error!)
            else if (user == null)
              _buildNoData()
            else
              Center(
                child: _buildCarnet(screenSize, user),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds error message widget
  Widget _buildError(String errorMessage) {
    return Center(
      child: Text(
        'Error loading data: $errorMessage',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  /// Builds widget for no data available
  Widget _buildNoData() {
    return const Center(
      child: Text(
        'No user data found.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  /// Builds the main carnet display with user information
  Widget _buildCarnet(Size screenSize, User user) {
    return Container(
      width: screenSize.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: user.photo != null
                ? MemoryImage(user.photo!)
                : const AssetImage('images/icono.jpg') as ImageProvider,
          ),
          const SizedBox(height: 15),
          Text(
            '${user.name.toUpperCase()} ${user.lastName.toUpperCase()}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF39A900),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            'Aprendiz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF39A900),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            user.program,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildQrButton(),
          const SizedBox(height: 25),
          _buildUserDetails(user),
        ],
      ),
    );
  }

  void _showQrModal() {
    showDialog(
      context: context,
      builder: (context) => QrModal(),
    );
  }

  Widget _buildUserDetails(User user) {
    return Column(
      children: [
        _buildInfoRow(user.acronym, user.documentNumber, "RH", user.bloodType),
        const SizedBox(height: 15),
        _buildInfoRow(
            "Número Ficha", user.studySheet, "Centro", user.trainingCenter),
        const SizedBox(height: 15),
        _buildInfoRow("Jornada", user.journey, "Programa", user.program),
      ],
    );
  }

  _buildQrButton() {
    return ElevatedButton.icon(
      onPressed: _showQrModal, // No se pasa el usuario
      icon: const Icon(Icons.qr_code, color: Colors.white),
      label: const Text(
        "Mostrar QR",
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007D78),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(
          child: InfoColumnWidget(label: label1, value: value1),
        ),
        Expanded(
          child: InfoColumnWidget(label: label2, value: value2),
        ),
      ],
    );
  }
}
