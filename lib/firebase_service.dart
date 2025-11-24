import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Gemini AI - API key provided by user
  static const String _geminiApiKey = "AIzaSyAJBOZxPEwozVms5jqTPDoiwUPjpF4Bi0k"; // User's API key
  static final GenerativeModel _geminiModel = GenerativeModel(
    model: 'gemini-pro',
    apiKey: _geminiApiKey,
  );

  // Helper method to download image bytes from URL
  static Future<Uint8List> _downloadImageBytes(String imageUrl) async {
    print('Downloading image from: $imageUrl');
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      print('Image downloaded successfully, size: ${response.bodyBytes.length} bytes');
      return response.bodyBytes;
    } else {
      print('Failed to download image: ${response.statusCode}');
      throw Exception('Failed to download image: ${response.statusCode}');
    }
  }

  // Auth methods
  static Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Firestore methods - User Profile
  static Future<void> saveUserProfile({
    required String name,
    required String email,
    required int age,
    required double weight,
    required double height,
    required double goalWeight,
    required String gender,
    required String activityLevel,
    required String goal,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': email,
      'age': age,
      'weight': weight,
      'height': height,
      'goalWeight': goalWeight,
      'gender': gender,
      'activityLevel': activityLevel,
      'goal': goal,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  // Body Progress methods
  static Future<void> saveBodyProgress({
    required double weight,
    required double height,
    required double? bodyFat,
    required double? waist,
    required double? hips,
    String? imageUrl,
    String? notes,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('body_progress')
        .add({
          'weight': weight,
          'height': height,
          'bodyFat': bodyFat,
          'waist': waist,
          'hips': hips,
          'imageUrl': imageUrl,
          'notes': notes,
          'date': FieldValue.serverTimestamp(),
        });
  }

  static Future<List<Map<String, dynamic>>> getBodyProgress() async {
    final user = currentUser;
    if (user == null) return [];

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('body_progress')
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Workout methods
  static Future<void> saveWorkoutSession({
    required String name,
    required int duration,
    required int caloriesBurned,
    required List<String> exercises,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .add({
          'name': name,
          'duration': duration,
          'caloriesBurned': caloriesBurned,
          'exercises': exercises,
          'date': FieldValue.serverTimestamp(),
        });
  }

  static Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    final user = currentUser;
    if (user == null) return [];

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Firebase Storage methods
  static Future<String> uploadBodyImage(File file) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('body_images/${user.uid}/$fileName');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Gemini AI methods
  static Future<String> analyzeBodyProgressWithGemini({
    required String beforeImageUrl,
    required String afterImageUrl,
    required Map<String, dynamic> beforeData,
    required Map<String, dynamic> afterData,
  }) async {
    final prompt = """
Analiza estas dos imágenes corporales y los datos proporcionados para evaluar el progreso físico.

DATOS ANTES:
- Peso: ${beforeData['weight']} kg
- Altura: ${beforeData['height']} cm
- Fecha: ${beforeData['date']?.toDate()?.toString() ?? 'N/A'}

DATOS DESPUÉS:
- Peso: ${afterData['weight']} kg
- Altura: ${afterData['height']} cm
- Fecha: ${afterData['date']?.toDate()?.toString() ?? 'N/A'}

INSTRUCCIONES:
1. Compara visualmente las imágenes y analiza cambios en:
   - Composición corporal (grasa vs músculo)
   - Definición muscular
   - Postura y alineación
   - Áreas específicas (abdomen, brazos, piernas, etc.)

2. Evalúa el progreso basado en los datos numéricos

3. Proporciona un análisis motivador y constructivo

4. Da recomendaciones específicas para continuar mejorando

5. Mantén un tono positivo y profesional
""";

    try {
      print('Starting Gemini analysis for body progress...');
      print('Before image URL: $beforeImageUrl');
      print('After image URL: $afterImageUrl');

      // Download image bytes
      final beforeImageBytes = await _downloadImageBytes(beforeImageUrl);
      final afterImageBytes = await _downloadImageBytes(afterImageUrl);

      print('Sending to Gemini API...');
      final response = await _geminiModel.generateContent([
        Content.text(prompt),
        Content.data('image/jpeg', beforeImageBytes),
        Content.data('image/jpeg', afterImageBytes),
      ]);

      print('Gemini response received');
      final result = response.text ?? "No se pudo generar el análisis. Inténtalo de nuevo.";
      print('Analysis result: $result');
      return result;
    } catch (e) {
      print('Error in Gemini analysis: $e');
      return "Error al analizar las imágenes: $e";
    }
  }

  static Future<String> analyzeSingleImageWithGemini({
    required String imageUrl,
    required Map<String, dynamic> bodyData,
  }) async {
    final prompt = """
Analiza esta imagen corporal y proporciona una evaluación detallada.

DATOS CORPORALES:
- Peso: ${bodyData['weight']} kg
- Altura: ${bodyData['height']} cm
- Porcentaje de grasa: ${bodyData['bodyFat'] ?? 'No especificado'}%
- Circunferencia cintura: ${bodyData['waist'] ?? 'No especificado'} cm
- Circunferencia cadera: ${bodyData['hips'] ?? 'No especificado'} cm

INSTRUCCIONES:
1. Evalúa la composición corporal visible
2. Analiza la distribución de grasa y músculo
3. Evalúa la postura y alineación corporal
4. Proporciona observaciones específicas sobre áreas clave
5. Da recomendaciones personalizadas basadas en lo observado
6. Mantén un tono profesional y motivador
""";

    try {
      // Download image bytes
      final imageBytes = await _downloadImageBytes(imageUrl);

      final response = await _geminiModel.generateContent([
        Content.text(prompt),
        Content.data('image/jpeg', imageBytes),
      ]);

      return response.text ?? "No se pudo generar el análisis. Inténtalo de nuevo.";
    } catch (e) {
      return "Error al analizar la imagen: $e";
    }
  }

  // Body visualization generation - Demo version with pre-saved texts
  static Future<String> generateBodyVisualizationWithGemini({
    required double beforeWeight,
    required double currentWeight,
    required double height,
    Map<String, dynamic>? userProfile,
  }) async {
    final weightDifference = beforeWeight - currentWeight;
    final isWeightLoss = weightDifference > 0;
    final weightLost = weightDifference.abs();

    // Simulate API delay for realistic demo experience
    await Future.delayed(const Duration(seconds: 2));

    // Return different demo texts based on weight difference
    if (isWeightLoss) {
      if (weightLost < 5) {
        return """¡Excelente progreso inicial! Has perdido ${weightLost.toStringAsFixed(1)} kg y los cambios ya son notables.

**Cambios visibles:**
- Tu rostro se ve más definido, especialmente en las mejillas y mandíbula
- Los brazos muestran mejor definición muscular
- La cintura se ve más estrecha y el abdomen más plano
- Las piernas tienen mejor tono y forma

**Lo que viene:**
Continúa con tu rutina actual y verás cómo se acentúan estos cambios. Mantén la consistencia en alimentación y ejercicio para resultados óptimos.

¡Sigue así! Cada kilogramo cuenta en tu transformación.""";
      } else if (weightLost < 10) {
        return """¡Transformación notable! Has perdido ${weightLost.toStringAsFixed(1)} kg y tu cuerpo muestra cambios significativos.

**Cambios corporales destacados:**
- Rostro: Mejillas más definidas, cuello más esbelto
- Brazos: Mayor definición en bíceps y tríceps
- Torso: Abdomen más plano, cintura más marcada
- Caderas: Mejor proporción y forma
- Piernas: Tonificación visible en muslos y pantorrillas

**Recomendaciones:**
- Incorpora ejercicios de fuerza para mantener masa muscular
- Mantén una alimentación balanceada rica en proteínas
- No olvides días de descanso activo

¡Estás en el camino correcto hacia tu mejor versión!""";
      } else {
        return """¡Transformación impresionante! Has perdido ${weightLost.toStringAsFixed(1)} kg y tu cuerpo refleja una dedicación excepcional.

**Cambios transformadores:**
- Rostro: Líneas faciales más definidas, expresión más confiada
- Brazos: Músculos bien desarrollados y tonificados
- Torso: Abdomen plano con definición visible, espalda más fuerte
- Caderas y glúteos: Forma atlética y proporcionada
- Piernas: Piernas fuertes y esbeltas con buena definición muscular

**Para mantener los resultados:**
- Establece rutinas de mantenimiento semanales
- Monitorea tu composición corporal, no solo el peso
- Celebra tus logros y mantén la motivación alta

¡Eres un ejemplo de dedicación y disciplina! Sigue inspirando a otros con tu transformación.""";
      }
    } else {
      // Weight gain scenarios
      final weightGained = weightLost; // Same variable, different context
      if (weightGained < 5) {
        return """¡Buen inicio en tu ganancia de masa muscular! Has aumentado ${weightGained.toStringAsFixed(1)} kg de manera saludable.

**Cambios iniciales:**
- Mayor plenitud en brazos y hombros
- Desarrollo inicial de pecho y espalda
- Piernas más fuertes y con mejor forma
- Mayor energía y vitalidad general

**Próximos pasos:**
Continúa con tu plan de nutrición y entrenamiento. Los cambios se volverán más evidentes con el tiempo.

¡La consistencia es clave para construir el cuerpo que deseas!""";
      } else {
        return """¡Desarrollo muscular sólido! Has ganado ${weightGained.toStringAsFixed(1)} kg de masa muscular de calidad.

**Cambios corporales:**
- Brazos más voluminosos y definidos
- Pecho y espalda con mayor presencia
- Abdomen más firme con desarrollo del core
- Piernas poderosas con buena masa muscular
- Postura más erguida y atlética

**Recomendaciones:**
- Asegura suficiente proteína en tu alimentación
- Varía tus rutinas de entrenamiento
- Incluye recuperación adecuada

¡Estás construyendo un cuerpo fuerte y saludable!""";
      }
    }
  }
}