import 'package:partida/partida.dart';
import 'package:partida/src/problemas.dart';
import 'package:test/test.dart';

void main(){
  group('Jugador', () {
    test('debe de tener nombre no vacio', () {
      expect(()=> Jugador(nombre:''), throwsA(TypeMatcher<ProblemaNombreJugadorVacio>()));
    });
    test('mismo nombre mismo id', () {
      Jugador j1 = Jugador(nombre: 'Lizeth');
      Jugador j2 = Jugador(nombre: 'Lizeth');

      expect(j1, equals(j2));
    });
    test('diferente nombre, diferentes instancias', () {
      Jugador j1 = Jugador(nombre: 'Lizeth');
      Jugador j2 = Jugador(nombre: 'Daniela');

      expect(j1, isNot(equals(j2)));
    });
  });
}