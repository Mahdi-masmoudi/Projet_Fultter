import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../model/contact.model.dart';
import '../services/contact.service.dart';

class AjoutModifContactPage extends StatefulWidget {
  AjoutModifContactPage({this.contact, this.modifMode = false});
  final Contact? contact;
  final bool modifMode;
  @override
  State<AjoutModifContactPage> createState() =>
      _AjoutModifContactPage();
}

class _AjoutModifContactPage
    extends State<AjoutModifContactPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  Contact contact = Contact();

  ContactService contactService = ContactService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.modifMode ? 'PageModifer Contact' : 'Paget Ajouter Contact'),
      ),
      body: Form(
        key: globalKey,
        child: _formUI(),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormHelper.submitButton(
              widget.modifMode ? 'Modifer' : 'Ajouter',
              () {
                if (validateAndSave()) {
                  if (widget.modifMode)
                    contactService.modifierContact(contact!).then((value) {
                      Navigator.pop(context);
                    });
                  else
                    contactService.ajouterContact(contact!).then((value) {
                      Navigator.pop(context);
                    });
                }
              },
              borderRadius: 10,
              btnColor: Colors.teal,
              borderColor: Colors.teal,
            ),
            FormHelper.submitButton(
              "Annuler",
              () {
                Navigator.pop(context);
              },
              borderRadius: 10,
              btnColor: Colors.teal,
              borderColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.modifMode) contact = widget.contact!;
  }

  _formUI() {

    return SingleChildScrollView(


      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            FormHelper.inputFieldWidgetWithLabel(context, "nom", "Nom", "",
                (onValidate) {

              if (onValidate.isEmpty) {
                return "+Required";
              }
              return null;
            }, (onSaved) {
              contact!.nom = onSaved.toString().trim();
            },
                initialValue:widget.modifMode ? contact!.nom! : "",
                prefixIcon: const Icon(
                  Icons.text_fields,
                  color: Colors.teal,
                ),
                borderRadius: 10,
                contentPadding: 15,
                fontSize: 14,
                labelFontSize: 14,
                paddingLeft: 0,
                paddingRight: 0,
                prefixIconPaddingLeft: 10,
                borderColor: Colors.teal),
            FormHelper.inputFieldWidgetWithLabel(
                context, "telephone", "Telephone", "", (onValidate) {
              if (onValidate.isEmpty) {
                return "+Required";
              }
              return null;
            }, (onSaved) {
              contact!.tel = int.parse(onSaved.toString().trim());
            },
                initialValue:widget.modifMode ? contact!.tel.toString() : "",
                showPrefixIcon: true,
                prefixIcon: const Icon(
                  Icons.numbers,
                  color: Colors.teal,
                ),
                borderRadius: 10,
                contentPadding: 15,
                fontSize: 14,
                labelFontSize: 14,
                paddingLeft: 0,
                paddingRight: 0,
                prefixIconPaddingLeft: 10,
                isNumeric: true,
                borderColor: Colors.teal),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
