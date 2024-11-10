import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maqueta/features/carnet/domain/providers/card_provider.dart';
import 'package:maqueta/features/equipment/data/domain/providers/equipment_provider.dart';
import 'package:maqueta/features/equipment/data/models/equipment.dart';
import 'package:maqueta/features/equipment/presentation/page/add_equipment_page.dart';
import 'package:maqueta/core/widgets/equipment_card.dart';
import 'package:maqueta/core/widgets/home_app_bar.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UserProvider>(context, listen: false).fetchUserData());
  }

  Future<void> _navigateToAddEquipmentPage(BuildContext context) async {
    final newEquipment = await Navigator.push<Equipment>(
      context,
      MaterialPageRoute(builder: (context) => const AddEquipmentPage()),
    );

    if (newEquipment != null) {
      context.read<EquipmentProvider>().addEquipment(newEquipment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mis Equipos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF39A900),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateToAddEquipmentPage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF39A900),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Agregar equipo",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  if (userProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userProvider.error != null) {
                    return _buildError(userProvider.error!);
                  } else if (userProvider.user?.equipments.isEmpty ?? true) {
                    // Use `user` instead of `student`
                    return _buildEmptyEquipmentView();
                  }
                  return _buildEquipmentList(userProvider
                      .user!.equipments); // Use `user` instead of `student`
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String errorMessage) {
    return Center(
      child: Text(
        'Error al cargar los datos: $errorMessage',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildEmptyEquipmentView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "No tienes equipos registrados.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEquipmentList(List<Equipment> equipments) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: equipments.length,
      itemBuilder: (context, index) {
        final equipment = equipments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: EquipmentCard(
            type: equipment.model,
            brand: equipment.brand,
            model: equipment.model,
            color: equipment.color,
            serialNumber: equipment.serial,
            isActive: equipment.state == true,
            onEdit: () {
              _showEditModal(context, equipment: equipment);
            },
            onDeactivate: () => _showToggleDialog(context, equipment),
          ),
        );
      },
    );
  }

  void _showToggleDialog(BuildContext context, Equipment equipment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            equipment.state == true ? 'Desactivar equipo' : 'Activar equipo',
            style: TextStyle(
              color: equipment.state == true ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            equipment.state == true
                ? '¿Estás seguro de que deseas desactivar este equipo?'
                : '¿Estás seguro de que deseas activar este equipo?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar',
                  style: TextStyle(color: Color(0xFF39A900))),
            ),
            TextButton(
              onPressed: () async {
                // Close the dialog first
                Navigator.of(context).pop();

                // Retrieve providers outside of async context
                final equipmentProvider = context.read<EquipmentProvider>();
                final userProvider = context.read<UserProvider>();

                // Perform asynchronous operations
                await equipmentProvider.toggleEquipmentState(equipment);
                await userProvider.fetchUserData();
              },
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Color(0xFF39A900)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context, {required Equipment equipment}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Equipo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: equipment.color),
                decoration: const InputDecoration(labelText: 'Color'),
                onChanged: (value) => equipment.color = value,
              ),
              TextField(
                controller: TextEditingController(text: equipment.serial),
                decoration: const InputDecoration(labelText: 'Número de serie'),
                onChanged: (value) => equipment.serial = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await context
                    .read<EquipmentProvider>()
                    .updateEquipment(equipment);
                Navigator.of(context).pop();
                await context.read<UserProvider>().fetchUserData();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
