import 'package:partida/src/problemas.dart';

class Jugador{
  final String nombre;

  Jugador({required this.nombre}){
    if(nombre.isEmpty) throw ProblemaNombreJugadorVacio();
  }

  int get id => nombre.hashCode;
  
  @override
  bool operator == (Object other){
    if(identical(this, other)) return true;

    return other is Jugador && 
      other.nombre == nombre;
  }

  @override
  int get hashCode => nombre.hashCode;
}


class PuntuacionJugador{
  final Jugador jugador;
  int porAzules=0;
  int porVerdes=0;
  int porNegras=0;
  int porRosas=0;

  int get total => porAzules + porVerdes + porNegras + porRosas;
  
  PuntuacionJugador({required this.jugador,  required this.porAzules, required this.porVerdes, required this.porNegras, required this.porRosas});
}