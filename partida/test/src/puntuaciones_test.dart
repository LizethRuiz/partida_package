import 'package:partida/partida.dart';
import 'package:partida/src/problemas.dart';
import 'package:partida/src/puntuaciones.dart';
import 'package:test/test.dart';

void main() {
  group('Puntuacion ronda 1', () {
    late Jugador jugador;

    setUp(() => jugador = Jugador(nombre:'Lizeth'));
    test('La cantidad de azules debe ser cero o mayor.', () async {
      expect(()=> PRonda1(jugador:jugador, cuantasAzules: -1), throwsA(TypeMatcher<ProblemaAzulesNegativas>()));
    });
    test('Maximo azules es 10', () async {
      expect(()=> PRonda1(jugador:jugador, cuantasAzules: 11), throwsA(TypeMatcher<ProblemaDemasiadosAzules>()));
    });
    test('Cantidad entre 1 y 10 esta bien', () async {
      expect(()=> PRonda1(jugador:jugador, cuantasAzules: 3), returnsNormally);
    });
  });
  
  group('Puntuacion ronda 2', () {
    late Jugador jugador;

    setUp(() => jugador = Jugador(nombre:'Lizeth'));
    test('Cartas azules no deben ser negativas.', () async {
      expect(()=> PRonda2(jugador:jugador, cuantasAzules: -1, cuantasVerdes: 0), throwsA(TypeMatcher<ProblemaAzulesNegativas>()));
    });
    test('Cartas verdes no deben ser negativas', () async {
      expect(()=> PRonda2(jugador:jugador, cuantasAzules: 11, cuantasVerdes: -1), throwsA(TypeMatcher<ProblemaVerdesNegativas>()));
    });
    test('Se aceptan azules positivas', () async {
      expect(()=> PRonda2(jugador:jugador, cuantasAzules: 3, cuantasVerdes: 3), returnsNormally);
    });
     test('Se aceptan verdes positivas', () async {
      expect(()=> PRonda2(jugador:jugador, cuantasAzules: 3, cuantasVerdes: 3), returnsNormally);
    });
  });

  group('Puntuacion ronda 3', () {
    late Jugador jugador;

    setUp(() => jugador = Jugador(nombre:'Lizeth'));
    test('Cartas azules no deben ser negativas.', () async {
      expect(()=> PRonda3(jugador:jugador, cuantasAzules: -1, cuantasVerdes: 0, cuantasNegras:3, cuantasRosas:3), throwsA(TypeMatcher<ProblemaAzulesNegativas>()));
    });
    test('Cartas verdes no deben ser negativas', () async {
      expect(()=> PRonda3(jugador:jugador, cuantasAzules: 11, cuantasVerdes: -1, cuantasNegras:3, cuantasRosas:3), throwsA(TypeMatcher<ProblemaVerdesNegativas>()));
    });
    test('Cartas negras no deben ser negativas', () async {
      expect(()=> PRonda3(jugador:jugador, cuantasAzules: 11, cuantasVerdes: 3, cuantasNegras:-1, cuantasRosas:3), throwsA(TypeMatcher<ProblemaNegrasNegativas>()));
    });
    test('Cartas rosas no deben ser negativas', () async {
      expect(()=> PRonda3(jugador:jugador, cuantasAzules: 11, cuantasVerdes: 3, cuantasNegras:3, cuantasRosas:-1), throwsA(TypeMatcher<ProblemaRosasNegativas>()));
    });
    test('Se aceptan azules positivas', () async {
      expect(()=> PRonda3(jugador:jugador, cuantasAzules: 3, cuantasVerdes: 3, cuantasNegras:3, cuantasRosas:3), returnsNormally);
    });
     test('Se aceptan verdes positivas', () async {
      expect(()=> PRonda3(jugador:jugador, cuantasAzules: 3, cuantasVerdes: 3, cuantasNegras:3, cuantasRosas:3), returnsNormally);
    });
    test('Se aceptan negras positivas', () async {
      expect(()=> PRonda3(jugador:jugador, cuantasAzules: 3, cuantasVerdes: 3, cuantasNegras:3, cuantasRosas:3), returnsNormally);
    });
    test('Se aceptan rosas positivas', () async {
      expect(()=> PRonda3(jugador:jugador, cuantasAzules: 3, cuantasVerdes: 3, cuantasNegras:3, cuantasRosas:3), returnsNormally);
    });
  });
}