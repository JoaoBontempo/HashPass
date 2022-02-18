import 'package:flutter/material.dart';
import 'package:hashpass/Themes/colors.dart';

class AppBottomNavgation extends StatefulWidget {
  const AppBottomNavgation({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final Function(int) onItemSelected;

  @override
  State<AppBottomNavgation> createState() => _AppBottomNavgationState();
}

class _AppBottomNavgationState extends State<AppBottomNavgation> {
  int pageIndex = 0;

  void SelectIndex(index) {
    setState(() {
      pageIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.vpn_key),
          label: 'Minhas senhas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configurações',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_vert),
          label: 'Exportar/Importar',
        ),
      ],
      currentIndex: pageIndex,
      onTap: SelectIndex,
    );
  }
}
