import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:medi_scan_mobile/colors.dart';
import 'package:medi_scan_mobile/widget/bottomNav.dart';
import 'package:medi_scan_mobile/widget/appBar.dart';
import 'package:medi_scan_mobile/screens/Medical_Information.dart';

class MedicalInformationPart2 extends StatefulWidget {
  final Map<String, String> patientData;
  final MedicalData sharedData;
  const MedicalInformationPart2({super.key, required this.patientData, required this.sharedData});

  @override
  State<MedicalInformationPart2> createState() => _MedicalInformationPart2State();
}

class _MedicalInformationPart2State extends State<MedicalInformationPart2> {
  late MedicalData data;

  final conditionTypes = ['Condition Type', 'N/A', 'Chronic', 'Acute', 'Infectious', 'General', 'Mental Health', 'Auto immune', 'Cancer', 'Cardiovascular', 'Respiratory', 'Neurological', 'Pregnancy Complication', 'Congenital', 'Substance Abuse'];
  final severityOptions = ['Severity', 'Mild', 'Moderate', 'Severe'];
  final conditionStatusOptions = ['Condition Status', 'Active', 'Progressive', 'Resolved'];
  final flagOptions = ['Flag', 'Normal', 'High', 'Low'];

  @override
  void initState() {
    super.initState();
    data = widget.sharedData;
  }

  Widget _card(String title, String subtitle, Widget child, IconData icon) => Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: AppColors.primary, size: 18),
        SizedBox(width: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
      ]),
      if (subtitle.isNotEmpty) Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      SizedBox(height: 12),
      child,
    ]),
  );

  Widget _input(String label, String key, {String hint = ''}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      SizedBox(height: 4),
      TextField(
        controller: MedicalData.getController(key),
        decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(fontSize: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: EdgeInsets.all(12)),
        style: TextStyle(fontSize: 10),
      ),
      SizedBox(height: 20),
    ],
  );

  Widget _date(String label, DateTime? date, Function(DateTime) onSelect) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      SizedBox(height: 4),
      GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
          if (picked != null) onSelect(picked);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Expanded(child: Text(date?.toLocal().toString().split(' ')[0] ?? 'dd/mm/yyyy', style: TextStyle(fontSize: 10, color: date != null ? Colors.black : Colors.grey.shade600))),
            Icon(LucideIcons.calendar, size: 16, color: Colors.grey),
          ]),
        ),
      ),
      SizedBox(height: 20),
    ],
  );

  Widget _dropdown(String label, String currentValue, List<String> options, Function(String?) onChanged) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      SizedBox(height: 4),
      DropdownButtonFormField<String>(
        initialValue: currentValue,
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: EdgeInsets.all(12)),
        isExpanded: true,
        style: TextStyle(fontSize: 10, color: Colors.black),
        items: options.map((option) => DropdownMenuItem(value: option, child: Text(option, style: TextStyle(fontSize: 10)))).toList(),
        onChanged: onChanged,
      ),
      SizedBox(height: 20),
    ],
  );

  Widget _patientInfo(String label, String value) => Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(value, style: TextStyle(fontSize: 12)),
      ],
    ),
  );

  Widget _listItem(String text, int index, List<String> list) => Container(
    margin: EdgeInsets.only(top: 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
    child: Row(children: [
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: text.split('\n').map((line) {
          if (line.contains(':')) {
            final parts = line.split(':');
            return RichText(text: TextSpan(
              style: TextStyle(fontSize: 12, color: Colors.black),
              children: [
                TextSpan(text: '${parts[0].trim()}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: parts.length > 1 ? parts[1].trim() : ''),
              ],
            ));
          }
          return Text(line, style: TextStyle(fontSize: 12, color: Colors.black));
        }).toList(),
      )),
      IconButton(icon: Icon(LucideIcons.trash_2, color: Colors.red, size: 16), onPressed: () => setState(() => list.removeAt(index))),
    ]),
  );

  Widget _medicationItem(int index) {
    final lines = data.currentMedicationsList[index].split('\n');
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines.map((line) {
            if (line.contains(':')) {
              final parts = line.split(':');
              return RichText(text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.black),
                children: [
                  TextSpan(text: '${parts[0].trim()}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: parts.length > 1 ? parts[1].trim() : ''),
                ],
              ));
            }
            return Text(line, style: TextStyle(fontSize: 12, color: Colors.black));
          }).toList(),
        )),
        IconButton(icon: Icon(LucideIcons.trash_2, color: Colors.red, size: 16), onPressed: () => setState(() => data.currentMedicationsList.removeAt(index))),
      ]),
    );
  }

  Widget _addButton(String text, VoidCallback onPressed) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Text(text, style: TextStyle(fontSize: 14)),
    ),
  );

  void _addMedication() {
    final name = MedicalData.getController('medicationName').text;
    final dosage = MedicalData.getController('dosage').text;
    final frequency = MedicalData.getController('frequency').text;
    
    if (name.isNotEmpty && data.dateStarted != null && dosage.isNotEmpty && frequency.isNotEmpty) {
      setState(() {
        data.currentMedicationsList.add('Medication Name: $name\nDate Started: ${data.dateStarted!.toLocal().toString().split(' ')[0]}\nDosage: $dosage\nFrequency: $frequency');
        for (var key in ['medicationName', 'dosage', 'frequency']) {
          MedicalData.getController(key).clear();
        }
        data.dateStarted = null;
      });
    }
  }

  void _addToList(List<String> list, String Function() buildEntry, List<String> requiredFields, List<dynamic> requiredValues) {
    bool allValid = requiredFields.every((field) => MedicalData.getController(field).text.isNotEmpty) && requiredValues.every((value) => value != null);
    if (allValid) {
      setState(() {
        list.add(buildEntry());
        for (var field in requiredFields) {
          MedicalData.getController(field).clear();
        }
        _resetDropdowns();
      });
    }
  }

  void _resetDropdowns() {
    data.selectedConditionType = 'Condition Type';
    data.selectedSeverity = 'Severity';
    data.selectedConditionStatus = 'Condition Status';
    data.selectedAllergySeverity = 'Severity';
    data.selectedFlag = 'Flag';
    data.diagnoseDate = data.revolutionDate = data.testDate = data.dateGiven = data.nextDue = data.dateOfPrescribe = null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) { if (!didPop) Navigator.pop(context); },
      child: Scaffold(
        appBar: customAppBar("Medical Information", LucideIcons.file_plus, context),
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(child: Column(children: [
          SizedBox(height: 20),
          Text("Medical Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("Complete Patient Medical Profile", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          SizedBox(height: 20),

          _card("Patient Information", "", Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _patientInfo('Full Name', widget.patientData["Full Name"] ?? ''),
            _patientInfo('Birth Date', widget.patientData["Birth Date"] ?? ''),
            _patientInfo('Gender', widget.patientData["Gender"] ?? ''),
            _patientInfo('ID Number', widget.patientData["ID Number"] ?? ''),
          ]), LucideIcons.user),

          _card("Current Medication", "Type N/A if not applicable", Column(children: [
            Row(children: [
              Expanded(child: _input("Medication Name", 'medicationName', hint: "Medication Name")),
              SizedBox(width: 16),
              Expanded(child: _date("Date Started", data.dateStarted, (date) => setState(() => data.dateStarted = date))),
            ]),
            Row(children: [
              Expanded(child: _input("Dosage", 'dosage', hint: "Dosage")),
              SizedBox(width: 16),
              Expanded(child: _input("Frequency", 'frequency', hint: "Frequency")),
            ]),
            _addButton("Add", _addMedication),
            ...data.currentMedicationsList.asMap().entries.map((e) => _medicationItem(e.key)),
          ]), LucideIcons.pill),

          _card("Medical History", "Type N/A if not applicable", Column(children: [
            Row(children: [
              Expanded(child: _input("Condition Name", 'conditionName', hint: "Condition Name")),
              SizedBox(width: 16),
              Expanded(child: _date("Diagnose Date", data.diagnoseDate, (date) => setState(() => data.diagnoseDate = date))),
            ]),
            Row(children: [
              Expanded(child: _dropdown("Condition Type", data.selectedConditionType, conditionTypes, (value) => setState(() => data.selectedConditionType = value!))),
              SizedBox(width: 16),
              Expanded(child: _dropdown("Severity", data.selectedSeverity, severityOptions, (value) => setState(() => data.selectedSeverity = value!))),
            ]),
            Row(children: [
              Expanded(child: _dropdown("Condition Status", data.selectedConditionStatus, conditionStatusOptions, (value) => setState(() => data.selectedConditionStatus = value!))),
              SizedBox(width: 16),
              Expanded(child: _date("Resolution Date", data.revolutionDate, (date) => setState(() => data.revolutionDate = date))),
            ]),
            _addButton("Add", () => _addToList(data.medicalHistory, () => 'Condition Name: ${MedicalData.getController('conditionName').text}\nDiagnose Date: ${data.diagnoseDate!.toLocal().toString().split(' ')[0]}\nCondition Type: ${data.selectedConditionType}\nSeverity: ${data.selectedSeverity}\nCondition Status: ${data.selectedConditionStatus}${data.revolutionDate != null ? '\nResolution Date: ${data.revolutionDate!.toLocal().toString().split(' ')[0]}' : ''}', ['conditionName'], [data.diagnoseDate, data.selectedConditionType != 'Condition Type', data.selectedSeverity != 'Severity', data.selectedConditionStatus != 'Condition Status'])),
            ...data.medicalHistory.asMap().entries.map((e) => _listItem(e.value, e.key, data.medicalHistory)),
          ]), LucideIcons.heart),

          _card("Allergies", "Type N/A if not applicable", Column(children: [
            Row(children: [
              Expanded(child: _input("Allergy Name", 'allergyName', hint: "e.g seafood allergy")),
              SizedBox(width: 16),
              Expanded(child: _input("Allergy Type", 'allergyType', hint: "e.g Food, Medication etc.")),
            ]),
            Row(children: [
              Expanded(child: _input("Allergy Reaction", 'allergyReaction', hint: "e.g Difficulty breathing")),
              SizedBox(width: 16),
              Expanded(child: _dropdown("Severity", data.selectedAllergySeverity, severityOptions, (value) => setState(() => data.selectedAllergySeverity = value!))),
            ]),
            _addButton("Add", () => _addToList(data.allergiesList, () => 'Allergy Name: ${MedicalData.getController('allergyName').text}\nAllergy Type: ${MedicalData.getController('allergyType').text}\nAllergy Reaction: ${MedicalData.getController('allergyReaction').text}\nSeverity: ${data.selectedAllergySeverity}', ['allergyName', 'allergyType', 'allergyReaction'], [data.selectedAllergySeverity != 'Severity'])),
            ...data.allergiesList.asMap().entries.map((e) => _listItem(e.value, e.key, data.allergiesList)),
          ]), LucideIcons.dna),

          _card("Lab Result", "Type N/A if not applicable", Column(children: [
            _input("Test Name", 'testName', hint: "Test Name"),
            Row(children: [
              Expanded(child: _date("Date of Test", data.testDate, (date) => setState(() => data.testDate = date))),
              SizedBox(width: 16),
              Expanded(child: _input("Test Result", 'testResult', hint: "Test Result")),
            ]),
            Row(children: [
              Expanded(child: _input("Reference Range", 'referenceRange', hint: "e.g 40-60")),
              SizedBox(width: 16),
              Expanded(child: _dropdown("Flag", data.selectedFlag, flagOptions, (value) => setState(() => data.selectedFlag = value!))),
            ]),
            _addButton("Add", () => _addToList(data.labResultsList, () => 'Test Name: ${MedicalData.getController('testName').text}\nDate of Test: ${data.testDate!.toLocal().toString().split(' ')[0]}\nTest Result: ${MedicalData.getController('testResult').text}\nReference Range: ${MedicalData.getController('referenceRange').text}\nFlag: ${data.selectedFlag}', ['testName', 'testResult', 'referenceRange'], [data.testDate, data.selectedFlag != 'Flag'])),
            ...data.labResultsList.asMap().entries.map((e) => _listItem(e.value, e.key, data.labResultsList)),
          ]), LucideIcons.dna),

          _card("Prescription", "Type N/A if not applicable", Column(children: [
            _input("Medication Name", 'prescriptionMedicationName', hint: "Medication Name"),
            Row(children: [
              Expanded(child: _input("Dosage", 'prescriptionDosage', hint: "Dosage")),
              SizedBox(width: 16),
              Expanded(child: _input("Quantity", 'quantity', hint: "Quantity")),
            ]),
            Row(children: [
              Expanded(child: _date("Date of Prescribe", data.dateOfPrescribe, (date) => setState(() => data.dateOfPrescribe = date))),
              SizedBox(width: 16),
              Expanded(child: _input("Prescribe By", 'prescribeBy', hint: "Name of Provider")),
            ]),
            _addButton("Add", () => _addToList(data.prescriptionsList, () => 'Medication Name: ${MedicalData.getController('prescriptionMedicationName').text}\nDosage: ${MedicalData.getController('prescriptionDosage').text}\nQuantity: ${MedicalData.getController('quantity').text}\nDate of Prescribe: ${data.dateOfPrescribe!.toLocal().toString().split(' ')[0]}\nPrescribe By: ${MedicalData.getController('prescribeBy').text}', ['prescriptionMedicationName', 'prescriptionDosage', 'quantity', 'prescribeBy'], [data.dateOfPrescribe])),
            ...data.prescriptionsList.asMap().entries.map((e) => _listItem(e.value, e.key, data.prescriptionsList)),
          ]), LucideIcons.pill),

          SizedBox(height: 20),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
            Expanded(child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(LucideIcons.arrow_left, size: 16),
              label: Text("Previous", style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.symmetric(vertical: 12)),
            )),
            SizedBox(width: 16),
            Expanded(child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.symmetric(vertical: 12)),
              child: Text("Save to Records", style: TextStyle(fontSize: 14)),
            )),
          ])),
          SizedBox(height: 30),
        ])),
        bottomNavigationBar: Container(
          // ignore: deprecated_member_use
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 6, offset: const Offset(0, -3))]),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Bottomnav(initialIndex: index)), (route) => false),
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
      ),
    );
  }
}