import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediplan/Widgets/Home_Screen/bouncing_fab.dart';

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  final user = FirebaseAuth.instance.currentUser;

  // ✅ دالة حذف الدواء
  Future<void> deleteMedication(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('medications')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Medication deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error deleting: $e")),
      );
    }
  }

  // ✅ دالة تسجيل الخروج
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/welcomeScreen', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error logging out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // يمنع الرجوع Back
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "MediPlan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,

            ),

          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        // 🔹 إضافة الدراور (الجانبي)
        drawer: Drawer(
          backgroundColor: Colors.white.withOpacity(0.95),
          child: Column(
            children: [
              const SizedBox(height: 100), // مسافة من الأعلى

              // 🔹 زر Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent, size: 28),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  tileColor: Colors.redAccent.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutConfirmationDialog();
                  },
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 زر About
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blueAccent, size: 28),
                  title: const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  tileColor: Colors.blueAccent.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  onTap: () {
                    Navigator.pop(context); // اغلاق الـ Drawer أولاً
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'About This App',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'هذا البرنامج مصمم لمساعدتك على تذكير وتنظيم مواعيد الدواء الخاصة بك بسهولة.\n\nنحن سعداء لثقتك بنا ونتمنى لك تجربة سلسة وفعّالة.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),

                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
        ,



          floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: BouncingFAB(
            onPressed: () {
              Navigator.pushNamed(context, '/addMedication');
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),




        body: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                "assets/images/Background.png",
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 عرض قائمة الأدوية من Firestore
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('medications')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No medications added yet",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    );
                  }

                  final meds = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: meds.length,
                    itemBuilder: (context, index) {
                      final med = meds[index];
                      final name = med['name'] ?? 'Unnamed';
                      final type = med['type'] ?? '';
                      final dosage = med['dosage'] ?? '';
                      final times = List.from(med['times'] ?? []);

                      return Card(
                        elevation: 5, // الظل
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.grey.shade100.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.medication, color: Colors.blueAccent, size: 28),
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              "Type: $type\nDosage: $dosage\nTimes: ${times.join(', ')}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    title: const Text("Delete Medication"),
                                    content: Text("Are you sure you want to delete '$name'?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.redAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  deleteMedication(med.id);
                                }
                              },
                            ),
                          ),
                        ),
                      );

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 دالة لعرض تأكيد تسجيل الخروج
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الـ Dialog
              _logout(); // تنفيذ تسجيل الخروج
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}