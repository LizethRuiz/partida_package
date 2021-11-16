import 'package:partida/partida.dart';
import 'package:partida/src/problemas.dart';
import 'package:partida/src/puntuaciones.dart';
import 'package:test/test.dart';

void main() {

  group('Partidas', () {
    late Jugador j1, j2, j3, j4, j5;

    setUp((){
      j1 = Jugador(nombre: 'Lizeth');
      j2 =  Jugador(nombre: 'Daniela');
      j3 =  Jugador(nombre: 'Perla');
      j5 =  Jugador(nombre: 'Siomara');
      j4 = Jugador(nombre: 'Carlos');
    });
    test('debe de tener nombre no vacio', () {
      expect(()=> Partida(jugadores: { Jugador(nombre: 'Lizeth') }), throwsA(TypeMatcher<ProblemaNumeroJugadoresMenorMinimo>()));
    });
    test('debe de tener maximo 4 jugadores', () {
      expect(()=> Partida(jugadores: {j1, j2, j3, j4, j5}), throwsA(TypeMatcher<ProblemaNumeroJugadoresMaximo>()));
    });
    test('con dos jugadores esta bien', () {
      expect(()=> Partida(jugadores: {j1, j2}), returnsNormally);
    });
  });
  
  group('Puntuaciones Ronda 1', () {
    late Jugador j1, j2, j3;
    setUp((){
      j1= Jugador(nombre:'Lizeth');
      j2= Jugador(nombre:'Diana');
      j3= Jugador(nombre:'Siomara');
    });

    test('Jugadores puntuando sean los mismos de la partida', () {
      Partida p = Partida(jugadores: { j1, j2 });
      PRonda1 p1 = PRonda1(jugador: j1, cuantasAzules: 3);
      PRonda1 p2 = PRonda1(jugador: j2, cuantasAzules: 5);
      PRonda1 p3 = PRonda1(jugador: j3, cuantasAzules: 6);
      expect(()=> p.puntuacionRonda1([p1, p3]), throwsA(TypeMatcher<ProblemaJugadoresNoConcuerdan>()));
      expect(()=> p.puntuacionRonda1([p1, p2]), returnsNormally);
    });
  });

  group('Puntuaciones Ronda 2', () {
    late Jugador j1, j2, j3;
    late PRonda1 p11, p12, p13;
    late PRonda1 p11mal, p12mal, p13mal;
    late PRonda2 p21, p22, p23;

    setUp((){
      j1= Jugador(nombre:'Lizeth');
      j2= Jugador(nombre:'Diana');
      j3= Jugador(nombre:'Siomara');

      p11 = PRonda1(jugador: j1, cuantasAzules: 0);
      p12 = PRonda1(jugador: j2, cuantasAzules: 0);
      p13 = PRonda1(jugador: j3, cuantasAzules: 7);

      p11mal = PRonda1(jugador: j1, cuantasAzules: 10);
      p12mal = PRonda1(jugador: j2, cuantasAzules: 10);

      p21 = PRonda2(jugador: j1, cuantasAzules: 1, cuantasVerdes: 1);
      p22 = PRonda2(jugador: j2, cuantasAzules: 2, cuantasVerdes: 2);
      p23 = PRonda2(jugador: j3, cuantasAzules: 1, cuantasVerdes: 1);
    });
    
    test('Jugadores puntuando no concuerdan', () {
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11,p12]);
      expect(()=> p.puntuacionRonda2([p21, p23]), throwsA(TypeMatcher<ProblemaJugadoresNoConcuerdan>()));
      
    });

    test('Jugadores puntuando concuerdan',(){
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11,p12]);
      expect(()=> p.puntuacionRonda2([p21, p22]), returnsNormally);
    });

    test('Debe ser llamado despues de puntuacion ronda 1',(){
      Partida p = Partida(jugadores: { j1, j2 });
      expect(()=> p.puntuacionRonda2([p21, p22]), throwsA(TypeMatcher<ProblemaOrdenIncorrecto>()));
    });

    test('Cartas azules no deben ser menores al número anterior', () {
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11mal, p12mal]);
      expect(()=> p.puntuacionRonda2([p21, p22]), throwsA(TypeMatcher<ProblemaDisminucionAzules>()));
    });

    test('Cartas azules pueden ser iguales o mayores al numero anterior', (){
      Partida p = Partida(jugadores: {j1, j2});
      p.puntuacionRonda1([p11, p12]);
      expect(()=> p.puntuacionRonda2([p21, p22]), returnsNormally);
    });

    test('Maximo de cartas azules es 20', (){
      Partida p = Partida(jugadores: {j1, j2});
      p.puntuacionRonda1([p11, p12]);
      expect(()=> p.puntuacionRonda2([PRonda2(jugador: j1, cuantasAzules: 21, cuantasVerdes: 1), PRonda2(jugador: j2, cuantasAzules: 21, cuantasVerdes: 1)]), throwsA(TypeMatcher<ProblemaDemasiadosAzules>()));
    });

    test('Maximo de cartas verdes es 20', (){
      Partida p = Partida(jugadores: {j1, j2});
      p.puntuacionRonda1([p11, p12]);
      expect(()=> p.puntuacionRonda2([PRonda2(jugador: j1, cuantasAzules: 15, cuantasVerdes: 21), PRonda2(jugador: j2, cuantasAzules: 9, cuantasVerdes: 21)]), throwsA(TypeMatcher<ProblemaDemasiadosVerdes>()));
    });

    test('Maximo de ambas cartas debe de ser 20', (){
      Partida p = Partida(jugadores: {j1, j2});
      p.puntuacionRonda1([p11, p12]);
      expect(()=> p.puntuacionRonda2([PRonda2(jugador: j1, cuantasAzules: 11, cuantasVerdes: 11), PRonda2(jugador: j2, cuantasAzules: 9, cuantasVerdes: 21)]), throwsA(TypeMatcher<ProblemaExcesoCartas>()));
    });
  });

  group('Puntuaciones Ronda 3', () {
    late Jugador j1, j2, j3;
    late PRonda3 p31, p32, p33, p31mal, p32mal;
    late PRonda2 p21mal, p22mal, p21, p22;
    late PRonda1 p11, p12;

    setUp((){
      j1= Jugador(nombre:'Lizeth');
      j2= Jugador(nombre:'Diana');
      j3= Jugador(nombre:'Siomara');

      p11 = PRonda1(jugador: j1, cuantasAzules: 7);
      p12 = PRonda1(jugador: j2, cuantasAzules: 7);

      p21 = PRonda2(jugador: j1, cuantasAzules: 9, cuantasVerdes: 4);
      p22 = PRonda2(jugador: j2, cuantasAzules: 9, cuantasVerdes: 4);

      p21mal = PRonda2(jugador: j1, cuantasAzules: 15, cuantasVerdes: 4);
      p22mal = PRonda2(jugador: j2, cuantasAzules: 15, cuantasVerdes: 4);

      p31 = PRonda3(jugador: j1, cuantasAzules: 14, cuantasVerdes: 5, cuantasNegras:1, cuantasRosas:1);
      p32 = PRonda3(jugador: j2, cuantasAzules: 14, cuantasVerdes: 5, cuantasNegras:2, cuantasRosas:2);
      p33 = PRonda3(jugador: j3, cuantasAzules: 14, cuantasVerdes: 1, cuantasNegras:1, cuantasRosas:1);

      p31mal = PRonda3(jugador: j1, cuantasAzules: 14, cuantasVerdes: 1, cuantasNegras:1, cuantasRosas:1);
      p32mal = PRonda3(jugador: j2, cuantasAzules: 14, cuantasVerdes: 1, cuantasNegras:2, cuantasRosas:2);
    });
    
    test('Jugadores puntuando no concuerdan', () {
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11, p12]);
      p.puntuacionRonda2([p21, p22]);
      expect(()=> p.puntuacionRonda3([p31, p33]), throwsA(TypeMatcher<ProblemaJugadoresNoConcuerdan>()));
    });

    test('Jugadores puntuando sean los mismos de la partida', () {
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11, p12]);
      p.puntuacionRonda2([p21, p22]);
      expect(()=> p.puntuacionRonda3([p31, p32]), returnsNormally);
    });

    test('Debe ser llamado despues de puntuacion ronda 2',(){
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11, p12]);
      expect(()=> p.puntuacionRonda3([p31, p32]), throwsA(TypeMatcher<ProblemaOrdenIncorrecto>()));
    });

    test('Cartas azules no deben ser menores al número anterior', () {
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11, p12]);
      p.puntuacionRonda2([p21mal, p22mal]);
      expect(()=> p.puntuacionRonda3([p31, p32]), throwsA(TypeMatcher<ProblemaDisminucionAzules>()));
    });
    
    test('Cartas azules pueden ser iguales o mayores al numero anterior', (){
      Partida p = Partida(jugadores: {j1, j2});
      p.puntuacionRonda1([p11, p12]);
      p.puntuacionRonda2([p21, p22]);
      expect(()=> p.puntuacionRonda3([p31, p32]), returnsNormally);
    });

    test('Cartas verdes no deben ser menores al número anterior', () {
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11, p12]);
      p.puntuacionRonda2([p21, p22]);
      expect(()=> p.puntuacionRonda3([p31mal, p32mal]), throwsA(TypeMatcher<ProblemaDisminucionVerdes>()));
    });

    test('cartas verdes pueden ser iguales o mayores al numero anterior', () {
      Partida p = Partida(jugadores: { j1, j2 });
      p.puntuacionRonda1([p11, p12]);
      p.puntuacionRonda2([p21, p22]);
      expect(()=> p.puntuacionRonda3([p31, p32]), returnsNormally);
    });

    test('Maximo de cartas azules es 30', (){
      Partida p = Partida(jugadores: {j1, j2});
      p.puntuacionRonda1([p11, p12]);
      p.puntuacionRonda2([p21, p22]);
      expect(()=> p.puntuacionRonda3([PRonda3(jugador: j1, cuantasAzules: 31, cuantasVerdes: 21, cuantasNegras:1, cuantasRosas: 1), 
        PRonda3(jugador: j2, cuantasAzules: 21, cuantasVerdes: 21, cuantasNegras: 1, cuantasRosas: 2)]), throwsA(TypeMatcher<ProblemaDemasiadosAzules>()));
    });

    test('Maximo de cartas verdes es 30', (){
      Partida p = Partida(jugadores: {j1, j2});
      p.puntuacionRonda1([p11, p12]);
      p.puntuacionRonda2([p21, p22]);
      expect(()=> p.puntuacionRonda3([PRonda3(jugador: j1, cuantasAzules: 22, cuantasVerdes: 31, cuantasNegras:1, cuantasRosas: 1), 
        PRonda3(jugador: j2, cuantasAzules: 22, cuantasVerdes: 31, cuantasNegras: 1, cuantasRosas: 2)]), throwsA(TypeMatcher<ProblemaDemasiadosVerdes>()));
    });

  });

  
  group('puntuaciones', () {
    //Crear partida
    //Darle cartas azules al jugador 1 3
    //Darle cartas azules al jugador 2 2
    //llamar puntuaciones
    //debe de regresar una lista con PuntuaciónJugador
    late Jugador j1, j2;
    late PRonda1 p11, p12;

    setUp((){
      j1= Jugador(nombre:'Lizeth');
      j2= Jugador(nombre:'Diana');

      p11 = PRonda1(jugador: j1, cuantasAzules: 2);
      p12 = PRonda1(jugador: j2, cuantasAzules: 2);
    });

    test('Debe regresar lista PuntuacionesJugador', (){
      Partida p = Partida(jugadores: {j1, j2});
      p.puntuacionRonda1([p11, p12]);
      expect(()=> p.puntuaciones(fase.ronda1), returnsNormally);
    });
  });
}

