import 'package:vista_practica/pages/PE/Inicio_PE.dart';
import 'package:vista_practica/utils/Button_info.dart';

List<ButtonInfo> getButtons() {
  return [
    const ButtonInfo(
      icon: 'assets/icons/planta_electrica.png',
      text: 'Planta eléctrica',
      route: PaginaPlantaelec(),
    ),
    const ButtonInfo(
      icon: 'assets/icons/taladro.png',
      text: 'Taladro',
      route: PaginaPlantaelec(),
    ),
    const ButtonInfo(
      icon: 'assets/icons/pulidora.png',
      text: 'Pulidora',
      route: PaginaPlantaelec(),
    ),
    const ButtonInfo(
      icon: 'assets/icons/Compresor.png',
      text: 'Compresor',
      route: PaginaPlantaelec(),
    ),
    const ButtonInfo(
      icon: 'assets/icons/Compactador.png',
      text: 'Compactador',
      route: PaginaPlantaelec(),
    ),
  ];
}