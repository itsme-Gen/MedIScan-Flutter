import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/widget/bottomNav.dart';

class MedicalInformation extends StatefulWidget {
  final Map<String, String> patientData;
  const MedicalInformation({super.key, required this.patientData});

  @override
  State<MedicalInformation> createState() => _MedicalInformationState();
}

class _MedicalInformationState extends State<MedicalInformation> {
  // Controllers
  final controllers = {
    'condition': TextEditingController(),
    'vaccine': TextEditingController(),
    'medication': TextEditingController(),
    'dosage': TextEditingController(),
    'frequency': TextEditingController(),
    'prescribe': TextEditingController(),
    'test': TextEditingController(),
    'labFrequency': TextEditingController(),
    'remarks': TextEditingController(),
  };
  
  // State
  String selectedStatus = 'Select Status';
  DateTime? conditionDate, firstDoseDate, secondDoseDate, labDate;
  List<Map<String, String>> medicalHistory = [], vaccinations = [], medications = [], labResults = [];

  Widget buildCard(String title, String subtitle, Widget child) => Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    width: double.infinity,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        if (subtitle.isNotEmpty) Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        SizedBox(height: 16),
        child,
      ],
    ),
  );

  Widget buildInput(String hint, String key, {int maxLines = 1}) => TextField(
    controller: controllers[key],
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: maxLines > 1 ? Colors.grey.shade500 : null),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.all(maxLines > 1 ? 16 : 12),
    ),
    style: TextStyle(fontSize: 14),
  );

  Widget buildDatePicker(String hint, DateTime? date, Function(DateTime) onSelect) => 
    GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
        if (picked != null) onSelect(picked);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(LucideIcons.calendar, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text(date?.toLocal().toString().split(' ')[0] ?? hint, style: TextStyle(color: date != null ? Colors.black : Colors.grey.shade600)),
          ],
        ),
      ),
    );

  Widget buildDropdown() => DropdownButtonFormField<String>(
    initialValue: selectedStatus,
    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
    items: ['Select Status', 'Active', 'Inactive', 'Chronic'].map((status) => DropdownMenuItem(value: status, child: Text(status, style: TextStyle(fontSize: 12),))).toList(),
    onChanged: (value) => setState(() => selectedStatus = value!),
  );

  Widget buildSavedItem(List<Map<String, String>> list, int index) => Container(
    margin: EdgeInsets.only(top: 8),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
    child: Row(
      children: [
        Expanded(child: RichText(
          text: TextSpan(
            children: list[index]['display']!.split('\n').expand((line) {
              if (line.contains(':')) {
                var parts = line.split(':');
                return [
                  TextSpan(text: '${parts[0]}:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  TextSpan(text: parts.length > 1 ? parts[1] : '', style: TextStyle(fontSize: 13, color: Colors.black)),
                  TextSpan(text: '\n')
                ];
              }
              return [TextSpan(text: '$line\n', style: TextStyle(fontSize: 13, color: Colors.black))];
            }).toList()..removeLast(),
          ),
        )),
        IconButton(icon: Icon(LucideIcons.trash_2, color: Colors.red, size: 16), onPressed: () => setState(() => list.removeAt(index))),
      ],
    ),
  );

  Widget buildButton(String text, VoidCallback onPressed) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), child: Text(text)),
  );

  void addData(List<Map<String, String>> list, String display, List<String> clearKeys, {bool resetDate = false, bool resetStatus = false}) {
    setState(() {
      list.add({'display': display});
      for (String key in clearKeys) {
        controllers[key]!.clear();
      }
      if (resetDate) conditionDate = firstDoseDate = secondDoseDate = labDate = null;
      if (resetStatus) selectedStatus = 'Select Status';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(LucideIcons.file_plus, color: AppColors.primary),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("Medical Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary))),
            ],
          ),
        ),
        actions: [Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Icon(LucideIcons.circle_user, color: AppColors.primary, size: 30))],
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Medical Information", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Complete Patient Medical Profile", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            SizedBox(height: 30),
            
            // Personal Information
            buildCard("Personal Information", "", Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ['Full Name', 'ID Number', 'Birth Date'].map((label) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade700)),
                    Text(widget.patientData[label] ?? '', style: TextStyle(fontSize: 14)),
                  ],
                ),
              )).toList(),
            )),

            // Medical History
            buildCard("Medical History", "Add Patient medical condition and history", Column(
              children: [
                buildInput("Condition", 'condition'),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: buildDatePicker("dd/mm/yyyy", conditionDate, (date) => setState(() => conditionDate = date))),
                    SizedBox(width: 12),
                    Expanded(child: buildDropdown()),
                  ],
                ),
                SizedBox(height: 16),
                buildButton("Add", () {
                  if (controllers['condition']!.text.isNotEmpty && conditionDate != null && selectedStatus != 'Select Status') {
                    addData(medicalHistory, 'Condition: ${controllers['condition']!.text}\nDate: ${conditionDate!.toLocal().toString().split(' ')[0]}\nStatus: $selectedStatus', ['condition'], resetDate: true, resetStatus: true);
                  }
                }),
                ...medicalHistory.asMap().entries.map((e) => buildSavedItem(medicalHistory, e.key)),
              ],
            )),

            // Vaccinations
            buildCard("Vaccinations", "Track Vaccination History", Column(
              children: [
                buildInput("Vaccine Name", 'vaccine'),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("First Dose", style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        SizedBox(height: 4),
                        buildDatePicker("dd/mm/yyyy", firstDoseDate, (date) => setState(() => firstDoseDate = date)),
                      ],
                    )),
                    SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Second Dose", style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        SizedBox(height: 4),
                        buildDatePicker("dd/mm/yyyy", secondDoseDate, (date) => setState(() => secondDoseDate = date)),
                      ],
                    )),
                  ],
                ),
                SizedBox(height: 16),
                buildButton("Add", () {
                  if (controllers['vaccine']!.text.isNotEmpty && firstDoseDate != null) {
                    addData(vaccinations, 'Vaccine: ${controllers['vaccine']!.text}\nFirst Dose: ${firstDoseDate!.toLocal().toString().split(' ')[0]}${secondDoseDate != null ? '\nSecond Dose: ${secondDoseDate!.toLocal().toString().split(' ')[0]}' : ''}', ['vaccine'], resetDate: true);
                  }
                }),
                ...vaccinations.asMap().entries.map((e) => buildSavedItem(vaccinations, e.key)),
              ],
            )),

            // Current Medication
            buildCard("Current Medication", "List of current medication and prescription", Column(
              children: [
                ...['Medication Name', 'Dosage', 'Frequency', 'Prescribed by'].asMap().entries.map((entry) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: buildInput(entry.value, ['medication', 'dosage', 'frequency', 'prescribe'][entry.key]),
                )),
                SizedBox(height: 4),
                buildButton("Add", () {
                  if (controllers['medication']!.text.isNotEmpty && 
                      controllers['dosage']!.text.isNotEmpty && 
                      controllers['frequency']!.text.isNotEmpty && 
                      controllers['prescribe']!.text.isNotEmpty) {
                    addData(medications, 'Medication: ${controllers['medication']!.text}\nDosage: ${controllers['dosage']!.text}\nFrequency: ${controllers['frequency']!.text}\nPrescribed by: ${controllers['prescribe']!.text}', ['medication', 'dosage', 'frequency', 'prescribe']);
                  }
                }),
                ...medications.asMap().entries.map((e) => buildSavedItem(medications, e.key)),
              ],
            )),

            // Lab Result
            buildCard("Lab Result", "Laboratory Lab result/card reports", Column(
              children: [
                buildInput("Test Name", 'test'),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: buildDatePicker("dd/mm/yyyy", labDate, (date) => setState(() => labDate = date))),
                    SizedBox(width: 12),
                    Expanded(child: buildInput("Frequency", 'labFrequency')),
                  ],
                ),
                SizedBox(height: 16),
                buildButton("Add", () {
                  if (controllers['test']!.text.isNotEmpty && labDate != null) {
                    addData(labResults, 'Test: ${controllers['test']!.text}\nDate: ${labDate!.toLocal().toString().split(' ')[0]}\nFrequency: ${controllers['labFrequency']!.text}', ['test', 'labFrequency'], resetDate: true);
                  }
                }),
                ...labResults.asMap().entries.map((e) => buildSavedItem(labResults, e.key)),
              ],
            )),

            // Remarks & Notes
            buildCard("Remarks & Notes", "Additional medical notes and observations", Column(
              children: [buildInput("Enter any additional medical notes, allergies, special conditions or remarks...", 'remarks', maxLines: 6)],
            )),

            SizedBox(height: 30),
            // Save Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Medical Information Saved Successfully!"))),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: Text("Save Medical Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Medical Record will be securely saved to patient's records", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Container(
        // ignore: deprecated_member_use
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 6, offset: const Offset(0, -3))]),
        child: BottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: index)), (route) => false);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.secondary,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.house), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(LucideIcons.camera), label: 'Scan ID'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(LucideIcons.bot), label: "Assistant"),
          ],
        ),
      ),
    );
  }
}