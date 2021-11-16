import 'package:partida/src/problemas.dart';
import 'package:partida/src/puntuaciones.dart';
import '../partida.dart';
import 'helpers.dart';

const numeroMaximoJugadores = 4;
const numeroMinimoJugadores = 2;
const maximoCartasJugadasRonda2 = 20;
const maximoCartasJugadasRonda3 = 30;
const puntosPorAzul = 3;
const puntosPorVerde = 4;
const puntosPorNegra = 4;
const puntosPorRosa = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
enum fase {ronda1, ronda2, ronda3, desenlace}

class Partida {
  Partida({required this.jugadores}){
    if (jugadores.length < numeroMinimoJugadores) throw ProblemaNumeroJugadoresMenorMinimo();
    if (jugadores.length > numeroMaximoJugadores) throw ProblemaNumeroJugadoresMaximo();
  }

  final Set<Jugador> jugadores;
  List<PRonda1> _puntuacionesRonda1 = [];
  List<PRonda2> _puntuacionesRonda2 = [];
  List<PRonda3> _puntuacionesRonda3 = [];

  List <PuntuacionJugador> puntuaciones(fase ronda){
    List<PuntuacionJugador> _puntuacionesJugador = [];
    switch (ronda) {
      case fase.ronda1:
        for(var pRonda1 in _puntuacionesRonda1){
          Jugador jugador = pRonda1.jugador;
          int azules = pRonda1.cuantasAzules;
          _puntuacionesJugador.add(PuntuacionJugador(jugador:jugador, porAzules:puntosPorAzul*azules, porVerdes:0 , porNegras:0, porRosas:0));
        }
        return _puntuacionesJugador;
      case fase.ronda2:
        for(var pRonda2 in _puntuacionesRonda2){
          Jugador jugador = pRonda2.jugador;
          int azules = pRonda2.cuantasAzules;
          int verdes = pRonda2.cuantasVerdes;
          _puntuacionesJugador.add(PuntuacionJugador(jugador:jugador, porAzules:puntosPorAzul*azules, porVerdes:puntosPorVerde*verdes , porNegras:0, porRosas:0));
        }
        return _puntuacionesJugador;
      case fase.ronda3:
        for(var pRonda3 in _puntuacionesRonda3){
          Jugador jugador = pRonda3.jugador;
          int azules = pRonda3.cuantasAzules;
          int verdes = pRonda3.cuantasVerdes;
          int negras = pRonda3.cuantasNegras;
          int rosas = pRonda3.cuantasRosas;
          _puntuacionesJugador.add(
            PuntuacionJugador(jugador:jugador, 
            porAzules:puntosPorAzul*azules, 
            porVerdes:puntosPorVerde*verdes , 
            porNegras:puntosPorNegra*negras, 
            porRosas:rosas > 15 ? 120 : puntosPorRosa[rosas]));
        }
        return _puntuacionesJugador;
      case fase.desenlace:
        int totalAzules = 0;
        int totalVerdes = 0;
        int totalNegras = 0;
        int totalRosas = 0;

        for(Jugador j in jugadores){
          totalAzules = totalAzules + puntuaciones(fase.ronda1)
                        .firstWhere((element) => element.jugador == j).porAzules;
          totalAzules = totalAzules + puntuaciones(fase.ronda2)
                        .firstWhere((element) => element.jugador == j).porAzules;
          totalVerdes = totalVerdes + puntuaciones(fase.ronda2)
                        .firstWhere((element) => element.jugador == j).porVerdes;
          totalAzules = totalAzules + puntuaciones(fase.ronda3)
                        .firstWhere((element) => element.jugador == j).porAzules;
          totalVerdes = totalVerdes + puntuaciones(fase.ronda3)
                        .firstWhere((element) => element.jugador == j).porVerdes;
          totalNegras = totalNegras + puntuaciones(fase.ronda3)
                        .firstWhere((element) => element.jugador == j).porNegras;
          totalRosas = totalRosas + puntuaciones(fase.ronda3)
                        .firstWhere((element) => element.jugador == j).porRosas;

          _puntuacionesJugador.add(PuntuacionJugador(jugador: j, porAzules: totalAzules, porVerdes: totalVerdes, porNegras: totalNegras, porRosas: totalRosas));
        }
        return _puntuacionesJugador;
    }
  }

  void puntuacionRonda1(List<PRonda1> puntuaciones){
    Set<Jugador> jugadoresR1 = puntuaciones.map((e)=>e.jugador).toSet();
    if(!setEquals(jugadores, jugadoresR1)) throw ProblemaJugadoresNoConcuerdan();

    _puntuacionesRonda1 = puntuaciones;
  }

  void puntuacionRonda2(List<PRonda2> puntuaciones){
    if(_puntuacionesRonda1.isEmpty) throw ProblemaOrdenIncorrecto();

    if(!setEquals(jugadores, puntuaciones.map((e)=>e.jugador).toSet())) throw ProblemaJugadoresNoConcuerdan();

    for(PRonda2 segundaPuntuacion in puntuaciones){
      PRonda1 primeraPuntuacion = _puntuacionesRonda1.firstWhere((element) => element.jugador == segundaPuntuacion.jugador);
      if(primeraPuntuacion.cuantasAzules > segundaPuntuacion.cuantasAzules) {
        throw ProblemaDisminucionAzules();
      }
    }
  
    for(PRonda2 p in puntuaciones){
      if(p.cuantasAzules > maximoCartasJugadasRonda2) throw ProblemaDemasiadosAzules();
      if(p.cuantasVerdes > maximoCartasJugadasRonda2) throw ProblemaDemasiadosVerdes();
      if((p.cuantasAzules + p.cuantasVerdes) > maximoCartasJugadasRonda2){
        throw ProblemaExcesoCartas();
      } 
    }
    _puntuacionesRonda2 = puntuaciones;
  }

  void puntuacionRonda3(List<PRonda3> puntuaciones){
    if(_puntuacionesRonda2.isEmpty) throw ProblemaOrdenIncorrecto();

    if(!setEquals(jugadores, puntuaciones.map((e)=>e.jugador).toSet())) throw ProblemaJugadoresNoConcuerdan();

    for(PRonda3 terceraPuntuacion in puntuaciones){
      PRonda2 segundaPuntuacion = _puntuacionesRonda2.firstWhere((element) => element.jugador == terceraPuntuacion.jugador);
      if(segundaPuntuacion.cuantasAzules > terceraPuntuacion.cuantasAzules) {
        throw ProblemaDisminucionAzules();
      }
      if(segundaPuntuacion.cuantasVerdes > terceraPuntuacion.cuantasVerdes) {
        throw ProblemaDisminucionVerdes();
      }
    }

    for(PRonda3 p in puntuaciones){
      if(p.cuantasAzules > maximoCartasJugadasRonda3) throw ProblemaDemasiadosAzules();
      if(p.cuantasVerdes > maximoCartasJugadasRonda3) throw ProblemaDemasiadosVerdes();
    }

    _puntuacionesRonda3 = puntuaciones;
  }
}
