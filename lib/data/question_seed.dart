import '../models/question.dart';

class QuestionsSeed {
  static Map<String, List<Question>> get preguntasPorLeccion => {
    // 🟩 Unidad 1: Fundamentos
    'unidad_1_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "Hola" en inglés?',
        opciones: ['Hello', 'Bye', 'Thanks', 'Good'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cómo responderías a "Hello"?',
        opciones: ['Thanks', 'Hello', 'Goodbye', 'Yes'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Cómo se dice "Adiós" en inglés?',
        opciones: ['Bye', 'Hi', 'Hello', 'Good morning'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Qué significa "Good morning"?',
        opciones: ['Buenas noches', 'Buenos días', 'Buenas tardes', 'Adiós'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué dirías para saludar por la tarde?',
        opciones: ['Good afternoon', 'Good night', 'See you', 'Thanks'],
        respuestaCorrecta: 0,
      ),
    ],

    'unidad_1_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "Me llamo Ana"?',
        opciones: ['My name is Ana', 'I am Ana', 'Ana good', 'I Ana is'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cómo se pregunta "¿Cómo te llamas?" en inglés?',
        opciones: ['Where are you?', 'What is your name?', 'How old are you?', 'Who are you?'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q3',
        enunciado: 'Selecciona la opción correcta: "______ name is John."',
        opciones: ['I', 'He', 'My', 'You'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Cómo responderías si alguien dice "Nice to meet you"?',
        opciones: ['Thanks', 'Me too', 'Nice to meet you too', 'Goodbye'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q5',
        enunciado: 'Completa: "I am _____."',
        opciones: ['fine', 'happy', 'John', 'good'],
        respuestaCorrecta: 2,
      ),
    ],

    // 🟨 Unidad 2: Gramática básica
    'unidad_2_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cuál es el artículo definido en inglés?',
        opciones: ['The', 'A', 'An', 'One'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cuál es el artículo indefinido para palabras que comienzan con consonante?',
        opciones: ['The', 'A', 'An', 'Some'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q3',
        enunciado: 'Selecciona el uso correcto: "_____ apple".',
        opciones: ['A', 'An', 'The', 'Some'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Cuál es el plural de "book"?',
        opciones: ['Books', 'Bookes', 'Bookies', 'Bookses'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: 'Elige la frase correcta:',
        opciones: [
          'The cat is black.',
          'Cat the is black.',
          'A black the cat.',
          'Is cat the black.'
        ],
        respuestaCorrecta: 0,
      ),
    ],

    'unidad_2_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cuál es la forma correcta del verbo "to be" en primera persona?',
        opciones: ['I is', 'I am', 'I are', 'I be'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q2',
        enunciado: 'Completa: "You _____ my friend."',
        opciones: ['am', 'is', 'are', 'be'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Cuál es la forma negativa de "I am happy"?',
        opciones: ['I not am happy', 'I am not happy', 'Am not I happy', 'I no am happy'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q4',
        enunciado: 'Selecciona la pregunta correcta:',
        opciones: [
          'Are you student?',
          'You are student?',
          'Do you student?',
          'You is student?'
        ],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: 'Completa: "He _____ a teacher."',
        opciones: ['is', 'are', 'am', 'be'],
        respuestaCorrecta: 0,
      ),
    ],

    // 🟦 Unidad 3: Conversación básica
    'unidad_3_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "¿Cómo estás?" en inglés?',
        opciones: ['How are you?', 'Who are you?', 'Where are you?', 'How old are you?'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cómo preguntar "¿Qué haces?"?',
        opciones: ['What do you do?', 'What is your name?', 'How are you?', 'Where are you?'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Cómo preguntar "¿Dónde vives?"?',
        opciones: ['Where do you live?', 'Who are you?', 'When are you?', 'What do you live?'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Qué significa "How old are you?"?',
        opciones: [
          '¿Cuántos años tienes?',
          '¿Cómo estás?',
          '¿Dónde estás?',
          '¿Qué haces?'
        ],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: 'Selecciona la forma correcta: "______ do you go to school?"',
        opciones: ['Where', 'Who', 'What', 'When'],
        respuestaCorrecta: 0,
      ),
    ],

    'unidad_3_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo responder a "How are you?"?',
        opciones: ['I am fine, thanks.', 'I have 10 years.', 'I go school.', 'I name is John.'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cuál sería una respuesta común a "What is your name?"?',
        opciones: ['I am 20', 'My name is Ana', 'Fine, thanks', 'Goodbye'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q3',
        enunciado: 'Completa: "Where are you from?" – "_____ from Spain."',
        opciones: ['I', 'I am', 'I be', 'I are'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Cómo responderías a "Do you speak English?"?',
        opciones: ['Yes, I do.', 'No, I am not.', 'I do not are.', 'Yes, I am.'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué podrías decir para agradecer algo?',
        opciones: ['Thanks', 'Please', 'Sorry', 'Hello'],
        respuestaCorrecta: 0,
      ),
    ],

    // 🟥 Unidad 4: Vocabulario diario
    'unidad_4_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "mesa" en inglés?',
        opciones: ['Chair', 'Bed', 'Table', 'Door'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cómo se dice "silla" en inglés?',
        opciones: ['Chair', 'Table', 'Window', 'Wall'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q3',
        enunciado: 'Selecciona la traducción correcta: "bed".',
        opciones: ['Cama', 'Mesa', 'Puerta', 'Silla'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Qué significa "door"?',
        opciones: ['Pared', 'Ventana', 'Puerta', 'Techo'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Cómo se dice "ventana" en inglés?',
        opciones: ['Window', 'Wall', 'Roof', 'Floor'],
        respuestaCorrecta: 0,
      ),
    ],

    'unidad_4_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "pan" en inglés?',
        opciones: ['Rice', 'Bread', 'Apple', 'Milk'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cómo se dice "leche" en inglés?',
        opciones: ['Water', 'Bread', 'Milk', 'Juice'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q3',
        enunciado: 'Selecciona la traducción de "apple":',
        opciones: ['Manzana', 'Uva', 'Banana', 'Naranja'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Qué significa "rice"?',
        opciones: ['Arroz', 'Pan', 'Carne', 'Queso'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Cómo se dice "jugo" en inglés?',
        opciones: ['Juice', 'Bread', 'Tea', 'Milk'],
        respuestaCorrecta: 0,
      ),
    ],

    //Unidad 5: Verbos comunes
    'unidad_5_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "correr" en inglés?',
        opciones: ['Run', 'Walk', 'Jump', 'Eat'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cuál es la traducción de "read"?',
        opciones: ['Dormir', 'Leer', 'Correr', 'Caminar'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q3',
        enunciado: 'Selecciona el verbo correcto: "I _____ every morning."',
        opciones: ['run', 'sleep', 'apple', 'happy'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Qué significa "write"?',
        opciones: ['Correr', 'Leer', 'Escribir', 'Comer'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Cómo se dice "comer" en inglés?',
        opciones: ['Sleep', 'Eat', 'Play', 'Talk'],
        respuestaCorrecta: 1,
      ),
    ],

    'unidad_5_leccion_2': [
      Question(
        id: 'q1',
        enunciado: 'Completa: "I wake up at 7 and then I _____ breakfast."',
        opciones: ['do', 'eat', 'play', 'sleep'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Qué verbo usarías para "ir a la escuela"?',
        opciones: ['go', 'make', 'see', 'read'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Cómo se dice "trabajar" en inglés?',
        opciones: ['Work', 'Walk', 'Wait', 'Want'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q4',
        enunciado: 'Selecciona la frase correcta:',
        opciones: [
          'I go to school every day.',
          'I to school go every day.',
          'Go I school every day.',
          'I every day go school.'
        ],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué significa "take a shower"?',
        opciones: ['Desayunar', 'Bañarse', 'Caminar', 'Dormir'],
        respuestaCorrecta: 1,
      ),
    ],

    // 🟫 Unidad 6: El tiempo y el clima
    'unidad_6_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "hace calor" en inglés?',
        opciones: ['It is hot', 'It is cold', 'It rains', 'It snows'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Qué significa "It is raining"?',
        opciones: ['Está nevando', 'Está lloviendo', 'Hace frío', 'Hace sol'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Cómo se dice "hace frío" en inglés?',
        opciones: ['It is warm', 'It is hot', 'It is cold', 'It is cloudy'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q4',
        enunciado: 'Selecciona la traducción correcta: "It is sunny."',
        opciones: ['Está nublado', 'Hace sol', 'Está lloviendo', 'Hace viento'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué significa "windy"?',
        opciones: ['Ventoso', 'Nevado', 'Soleado', 'Caluroso'],
        respuestaCorrecta: 0,
      ),
    ],

    'unidad_6_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "primavera" en inglés?',
        opciones: ['Spring', 'Summer', 'Autumn', 'Winter'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: 'Selecciona la traducción correcta: "Winter".',
        opciones: ['Invierno', 'Verano', 'Primavera', 'Otoño'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Qué estación sigue después del verano?',
        opciones: ['Spring', 'Autumn', 'Winter', 'Summer'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Cómo se dice "verano" en inglés?',
        opciones: ['Summer', 'Winter', 'Autumn', 'Spring'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué estación viene después de la primavera?',
        opciones: ['Summer', 'Winter', 'Autumn', 'Spring'],
        respuestaCorrecta: 0,
      ),
    ],

    // 🟪 Unidad 7: Viajes y transporte
    'unidad_7_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "coche" en inglés?',
        opciones: ['Bus', 'Car', 'Bike', 'Train'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Qué significa "bus"?',
        opciones: ['Tren', 'Avión', 'Autobús', 'Bicicleta'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Cómo se dice "bicicleta" en inglés?',
        opciones: ['Bike', 'Car', 'Bus', 'Plane'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q4',
        enunciado: 'Selecciona la traducción de "train":',
        opciones: ['Barco', 'Tren', 'Taxi', 'Coche'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué significa "plane"?',
        opciones: ['Avión', 'Bus', 'Bicicleta', 'Tren'],
        respuestaCorrecta: 0,
      ),
    ],

    'unidad_7_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "aeropuerto" en inglés?',
        opciones: ['Station', 'Airport', 'Port', 'Garage'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q2',
        enunciado: 'Selecciona la traducción correcta: "flight".',
        opciones: ['Vuelo', 'Maleta', 'Pasaporte', 'Tren'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Qué significa "passport"?',
        opciones: ['Boleto', 'Pasaporte', 'Asiento', 'Equipaje'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q4',
        enunciado: 'Completa: "My flight is at ______."',
        opciones: ['7 am', 'blue', 'airport', 'passport'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué significa "boarding pass"?',
        opciones: ['Puerta de embarque', 'Pasaje de abordo', 'Vuelo retrasado', 'Asiento'],
        respuestaCorrecta: 1,
      ),
    ],

    // 🟦 Unidad 8: Compras y dinero
    'unidad_8_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "tienda" en inglés?',
        opciones: ['Shop', 'Bank', 'Market', 'Office'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Qué significa "buy"?',
        opciones: ['Vender', 'Comprar', 'Llevar', 'Pagar'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q3',
        enunciado: 'Selecciona la traducción de "cash":',
        opciones: ['Tarjeta', 'Dinero en efectivo', 'Moneda', 'Banco'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Cómo se dice "cliente" en inglés?',
        opciones: ['Seller', 'Client', 'Customer', 'Buyer'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué significa "price"?',
        opciones: ['Precio', 'Descuento', 'Producto', 'Dinero'],
        respuestaCorrecta: 0,
      ),
    ],

    'unidad_8_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "dinero" en inglés?',
        opciones: ['Money', 'Price', 'Bill', 'Coin'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Qué significa "cheap"?',
        opciones: ['Caro', 'Barato', 'Gratis', 'Nuevo'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q3',
        enunciado: 'Selecciona la traducción de "expensive".',
        opciones: ['Barato', 'Caro', 'Pequeño', 'Lento'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Cómo se dice "billete" o "cuenta" en inglés?',
        opciones: ['Bill', 'Price', 'Money', 'Card'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué significa "How much is it?"?',
        opciones: ['¿Qué hora es?', '¿Dónde está?', '¿Cuánto cuesta?', '¿Qué es eso?'],
        respuestaCorrecta: 2,
      ),
    ],

    // 🟩 Unidad 9: Salud y cuerpo
    'unidad_9_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "cabeza" en inglés?',
        opciones: ['Head', 'Hand', 'Leg', 'Arm'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: 'Selecciona la traducción correcta: "arm".',
        opciones: ['Brazo', 'Pierna', 'Cabeza', 'Mano'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Qué significa "foot"?',
        opciones: ['Cabeza', 'Pie', 'Dedo', 'Brazo'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Cómo se dice "ojo" en inglés?',
        opciones: ['Ear', 'Nose', 'Eye', 'Mouth'],
        respuestaCorrecta: 2,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué significa "hand"?',
        opciones: ['Cabeza', 'Pie', 'Mano', 'Ojo'],
        respuestaCorrecta: 2,
      ),
    ],

    'unidad_9_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "doctor" en inglés?',
        opciones: ['Doctor', 'Medic', 'Nurse', 'Hospital'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: 'Selecciona la traducción de "I feel sick".',
        opciones: ['Me siento enfermo', 'Estoy cansado', 'Estoy feliz', 'Tengo hambre'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q3',
        enunciado: '¿Qué significa "headache"?',
        opciones: ['Dolor de cabeza', 'Dolor de estómago', 'Fiebre', 'Tos'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q4',
        enunciado: '¿Cómo se dice "hospital" en inglés?',
        opciones: ['Clinic', 'Hospital', 'Doctor', 'Pharmacy'],
        respuestaCorrecta: 1,
      ),
      Question(
        id: 'q5',
        enunciado: '¿Qué significa "medicine"?',
        opciones: ['Comida', 'Remedio o medicina', 'Hospital', 'Agua'],
        respuestaCorrecta: 1,
      ),
    ],
  };
}
