import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:maqueta/features/profile/data/datasources/profile_service.dart';
import 'package:maqueta/features/carnet/data/datasources/student_service.dart';
import 'package:maqueta/core/utils/blood_type.dart';

import 'package:maqueta/core/widgets/home_app_bar.dart';
import 'package:maqueta/features/carnet/data/models/user.dart';
import 'package:maqueta/features/carnet/data/datasources/card_service.dart';
import 'package:maqueta/core/providers/token_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  User? _userData;
  bool _isLoading = false;
  String? _selectedBloodType;
  final StudentService _studentService = StudentService();
  final ProfileUpdateService _profileUpdateService;
  final CardService _peopleService = CardService();
  final TokenStorage tokenStorage = TokenStorage();

  final TextEditingController _dateBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Variables para almacenar los valores iniciales
  String? _initialBloodType;
  String? _initialDateBirth;
  String? _initialAddress;
  File? _initialImage;

  _ProfilePageState()
      : _profileUpdateService = ProfileUpdateService(StudentService());

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _peopleService.getUser();
      final student = await _studentService.getUserData();
      if (user != null) {
        setState(() {
          _userData = user;
          _dateBirthController.text = student.dateBirth;
          _addressController.text = student.address;
          _selectedBloodType = user.bloodType;

          // Guardar los valores iniciales
          _initialDateBirth = student.dateBirth;
          _initialAddress = student.address;
          _initialBloodType = user.bloodType;
          _initialImage = _image;
          _isLoading = false;
        });
      } else {
        _showMessage('No se encontraron datos del usuario.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showMessage('Error al cargar los datos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (!pickedFile.path.endsWith('.jpg') &&
          !pickedFile.path.endsWith('.jpeg')) {
        _showMessage('Por favor selecciona una imagen en formato JPG.');
        return;
      }
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    // Verificar si hay cambios usando el servicio
    if (!_profileUpdateService.hasChanges(
      currentImage: _image,
      initialImage: _initialImage,
      currentBloodType: _selectedBloodType,
      initialBloodType: _initialBloodType,
      currentDateBirth: _dateBirthController.text,
      initialDateBirth: _initialDateBirth!,
      currentAddress: _addressController.text,
      initialAddress: _initialAddress!,
    )) {
      _showMessage('No se han realizado cambios para guardar.');
      return;
    }

    setState(() {
      _isLoading = true; // Inicia la carga
    });

    try {
      final decodeToken = await tokenStorage.decodeJwtToken();
      final document = int.parse(decodeToken['sub']);

      // Llama al servicio para actualizar el perfil
      await _profileUpdateService.updateProfile(
        image: _image,
        initialImage: _initialImage,
        bloodType: _selectedBloodType!,
        dateBirth: _dateBirthController.text,
        address: _addressController.text,
        document: document,
      );

      _showMessage('Datos guardados correctamente.');

      // Actualizar los valores iniciales después de guardar
      setState(() {
        _initialImage = _image;
        _initialBloodType = _selectedBloodType;
        _initialDateBirth = _dateBirthController.text;
        _initialAddress = _addressController.text;
      });
    } catch (e) {
      _showMessage('Error al guardar los datos: $e');
    } finally {
      setState(() {
        _isLoading = false; // Finaliza la carga
      });
    }
  }

  void _showMessage(String message) {
    if (!mounted) return; // Asegúrate de que el widget esté en pantalla
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Text(
            message,
            style: const TextStyle(fontSize: 17),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF39A900), // Color principal (verde)
              onPrimary: Colors.white, // Color del texto en el botón "OK"
              onSurface: Color(0xFF2B2B30), // Color del texto en el calendario
            ),
            dialogBackgroundColor: Colors.white, // Color de fondo del diálogo
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateBirthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const HomeAppBar(),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(
                    child: CircularProgressIndicator()) // Indicador de carga
              else if (_userData == null)
                const Center(
                  child: Text(
                    'No se encontraron datos del usuario.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Mi Perfil",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF39A900),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileHeader(_userData!),
                      const SizedBox(height: 25),
                      _buildProfileInfo(_userData!),
                      const SizedBox(height: 20),
                      _buildSaveButton(),
                    ],
                  ),
                ),
            ],
          ),
          Positioned(
            top: 55,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    ImageProvider? imageProvider;

    if (_image != null) {
      imageProvider = FileImage(_image!);
    } else if (user.photo != null && user.photo!.isNotEmpty) {
      imageProvider = MemoryImage(user.photo!);
    } else {
      imageProvider = const AssetImage('images/icono.jpg');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 25),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 70,
            backgroundImage: imageProvider,
            child: _image == null && (user.photo == null || user.photo!.isEmpty)
                ? Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white.withOpacity(0.7),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.name} ${user.lastName}",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2B2B30),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  color: const Color(0xFF888787),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildInfoColumn("Nombres", user.name, false)),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildInfoColumn("Apellidos", user.lastName, false)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: _buildInfoColumn(
                      "Tipo de Documento", user.acronym, false)),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildInfoColumn(
                      "Número de Documento", user.documentNumber, false)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: _buildInfoColumn(
                      "Número de Celular", user.phoneNumber, false)),
              const SizedBox(width: 15),
              Expanded(child: _buildBloodTypeDropdown()),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: _buildInfoColumn(
                      "Número de Ficha", user.studySheet, false)),
              const SizedBox(width: 15),
              Expanded(
                  child:
                      _buildInfoColumn("Centro", user.trainingCenter, false)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      _selectDate(context), // Abre el selector de fecha
                  child: AbsorbPointer(
                    child: _buildInfoColumn(
                      "Fecha Nacimiento",
                      "",
                      true,
                      controller: _dateBirthController,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildInfoColumn(
                  "Dirección",
                  "",
                  true,
                  controller: _addressController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RH',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF39A900), // Color del título
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedBloodType,
          items: AppConstants.bloodTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(
                type,
                style: const TextStyle(
                  color: Color(0xFF2B2B30), // Color del texto del item
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBloodType = value;
            });
          },
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF39A900), // Color del borde
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF39A900), // Borde cuando está habilitado
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF39A900), // Borde cuando está enfocado
                width: 2.0,
              ),
            ),
          ),
          style: const TextStyle(
            color: Color(0xFF2B2B30), // Color del texto seleccionado
          ),
          dropdownColor: Colors.white, // Color de fondo del menú desplegable
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value, bool editable,
      {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF39A900), // Color del texto del label
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller ?? TextEditingController(text: value),
          enabled: editable,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF39A900), // Color del borde
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF39A900), // Borde cuando está habilitado
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF39A900), // Borde cuando está enfocado
                width: 2.0,
              ),
            ),
            hintText: label == "Fecha Nacimiento"
                ? "Selecciona tu fecha"
                : "Ingresa tu dirección",
            hintStyle:
                const TextStyle(color: Colors.grey), // Color del hint text
          ),
          style: const TextStyle(
            color: Color(0xFF2B2B30), // Color del texto cuando se escribe
          ),
          readOnly: label ==
              "Fecha Nacimiento", // Solo lectura para Fecha de Nacimiento
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF39A900),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Guardar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
