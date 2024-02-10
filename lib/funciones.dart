String agregarAlPedido(String pedido, String agregar) {
  pedido = pedido + ' ' + agregar;
  return pedido;
}

String extraerObjetoEntreLlaves(String cadena) {
  // Busca el índice de inicio de la primera llave '{'
  int indiceInicio = cadena.indexOf('{');

  // Busca el índice de fin de la segunda llave '}'
  int indiceFin = -1;
  int contadorLlaves = 0;
  for (int i = indiceInicio; i < cadena.length; i++) {
    if (cadena[i] == '{') {
      contadorLlaves++;
    } else if (cadena[i] == '}') {
      contadorLlaves--;
      if (contadorLlaves == 0) {
        indiceFin = i;
        break;
      }
    }
  }

  // Extrae la subcadena que contiene el objeto entre las llaves
  String objetoEntreLlaves = cadena.substring(indiceInicio, indiceFin + 1);

  return objetoEntreLlaves;
}

List<List<String>> convertirCadenaAListaDeListas(String cadena) {
  List<List<String>> lista = [];

  if (cadena.length == 2) {
    return lista;
  }

  // Eliminar los corchetes y espacios
  cadena = cadena.replaceAll('{', '').replaceAll('}', '').trim();

  // Dividir la cadena en pares clave-valor
  List<String> pares = cadena.split(', ');

  // Iterar sobre los pares clave-valor y agregarlos a la lista
  for (String par in pares) {
    List<String> partes = par.split(':');
    String clave = partes[0].trim();
    String valor = partes[1].trim();
    lista.add([clave, valor]);
  }

  return lista;
}

List<String> procesarMapa(Map<String, String> mapa) {
  List<String> valores = [];
  mapa.forEach((clave, valor) {
    valores.add(valor);
  });
  return valores;
}

Map<String, String> convertirCadenaAObjeto(String cadena) {
  Map<String, String> objeto = {};

  if (cadena.length == 2) {
    return objeto;
  }

  // Eliminar los corchetes y espacios
  cadena = cadena.replaceAll('{', '').replaceAll('}', '').trim();

  // Dividir la cadena en pares clave-valor
  List<String> pares = cadena.split(', ');

  // Iterar sobre los pares clave-valor y agregarlos al objeto
  for (String par in pares) {
    List<String> partes = par.split(':');
    String clave = partes[0].trim();
    String valor = partes[1].trim();
    objeto[clave] = valor;
  }

  return objeto;
}

String listToString(List<dynamic> list) {
  String result = 'Tu productos son: ';

  for (int i = 0; i < list.length; i++) {
    result += list[i].toString();
    if (i != list.length - 1) {
      result += ', ';
    }
  }

  return result + ' deseas pedir algo mas?';
}
