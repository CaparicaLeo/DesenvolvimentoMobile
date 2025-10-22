import 'dart:io';

import 'package:agenda_de_contatos/database/helper/contact_helper.dart';
import 'package:agenda_de_contatos/database/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;
  ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact? _editContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imgController = TextEditingController();
  final ContactHelper _helper = ContactHelper();
  final ImagePicker _picker = ImagePicker();
  final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editContact = Contact(name: "", email: "", phone: "", img: "");
    } else {
      _editContact = widget.contact;
      _nameController.text = _editContact?.name ?? "";
      _emailController.text = _editContact?.email ?? "";
      _phoneController.text = _editContact?.phone ?? "";
      _imgController.text = _editContact?.img ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_editContact?.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveContact();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => _selectImage(),
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        _editContact?.img != null &&
                            _editContact!.img!.isNotEmpty
                        ? FileImage(File(_editContact!.img!))
                        : AssetImage("assets/imgs/user.png") as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editContact?.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editContact?.email = text;
                });
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Telefone"),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editContact?.phone = text;
                });
              },
              keyboardType: TextInputType.phone,
              inputFormatters: [phoneMask],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _editContact?.img = image.path;
      });
    }
  }

  void _saveContact() async {
    // 1. Validação do Nome (já existia)
    if (_editContact?.name == null || _editContact!.name!.isEmpty) {
      _showSnackBar("Nome é Obrigatório");
      return; // Para a execução
    }

    // 2. Validação do Email
    String email = _editContact?.email ?? "";
    if (email.isNotEmpty) {
      // Regex simples para validação de email
      final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$",
      );
      if (!emailRegExp.hasMatch(email)) {
        _showSnackBar("Email inválido. Verifique o formato.");
        return; // Para a execução
      }
    }

    // 3. Validação do Telefone
    String phone = _editContact?.phone ?? "";
    // A máscara (##) #####-#### tem 15 caracteres no total
    // Se o campo não estiver vazio, ele DEVE ter 15 caracteres
    if (phone.isNotEmpty && phone.length != 15) {
      _showSnackBar("Número de telefone incompleto.");
      return; // Para a execução
    }

    // Se todas as validações passaram, continua para salvar
    if (_editContact?.img == "") {
      _editContact?.img = null;
    }

    if (_editContact?.id != null) {
      await _helper.updateContact(_editContact!);
    } else {
      await _helper.saveContact(_editContact!);
    }
    Navigator.pop(context, _editContact);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red, // Destaque para o erro
      ),
    );
  }
}
