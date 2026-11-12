import 'package:flutter/material.dart';
import '../services/app_storage.dart';

class SettingsPage extends StatefulWidget{
  final VoidCallback onLogout;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.onLogout,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<SettingsPage>{
  final AppStorage _appStorage = AppStorage();
  bool _isloading = true;
  bool _darkMode = false;
  bool _confirmDelete = true;

  @override
  void initState(){
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _appStorage.loadSettings();
    setState(() {
      _darkMode = settings.darkMode;
      _confirmDelete = settings.confirmDelete;
      _isloading = false;
    });
  }

  Future<void> _toggleDarkmode(bool value) async{
    setState(() {
      _darkMode = value;
    });
    await _appStorage.saveDarkMode(value);
    widget.onThemeChanged(value);
  }

  Future<void> _toggleConfirmDelete (bool value) async{
    setState(() {
      _confirmDelete = value;
    });

    await _appStorage.saveConfirmDelete(value);
  }

  Future<void> _confirmLogout() async{
    final shouldLogout = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Deseja sair da conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          )
        ],
      );
    }
    );
    if(shouldLogout == true){
      await _appStorage.setLoggedIn(false);
      if (!mounted){
        return;
      }

      Navigator.pop(context);

      widget.onLogout();
    }
  }

  Future<void> _changePassword() async {
    final changed = await showDialog(
      context: context,
      builder: (context) {
        return _ChangePasswordDialog(appStorage: _appStorage);
      }
    );

    if (changed == true && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: _isloading
      ? const Center(child: CircularProgressIndicator())
      : ListView(
        children: [
          const _SectionTitle('APARÊNCIA'),
          SwitchListTile(
            title: const Text('Modo escuro'),
            subtitle: Text(_darkMode ? '🌙 Ativado' : '☀️ Desativado'),
            value: _darkMode,
            onChanged: _toggleDarkmode,
          ),
          const _SectionTitle('TAREFAS'),
          SwitchListTile(
            title: const Text('confirmar exclusã'),
            subtitle: const Text(
              'pedir confirmação antes de apagar uma tarefa'
            ),
            value: _confirmDelete,
            onChanged: _toggleConfirmDelete,
          ),
          const _SectionTitle('conta'),
          ListTile(
            title: const Text('alterar senha'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePassword,
          ),
          const _SectionTitle('sair da conta'),
          ListTile(
            const _SectionTitle Text('SOBRE'),
            
            const ListTile(
              title: Text('minhas tarefas'),
              subtitle: Text('versão 1.0.0'),
            ),
          ),


        ],
       

      ),
      );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  final AppStorage appStorage;

  const _ChangePasswordDialog({
    required this.appStorage,
  });

  @override 
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String? _errrorMessage;
  bool _isSaving = false;

  @override
  void dispose(){
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

    Future<void> _save() async{
      final current = _currentController.text.trim();
      final next = _newController.text.trim();
      final confirm = _confirmController.text.trim();
      final savepassword = await widget.appStorage.loadPassword();

      if (!mounted){
        return;
      }
      if (current != savepassword){
        setState(() {
          _errrorMessage = 'senha atual incorreta';
        });
        return;
      }
      if (next.isEmpty){
        setState(() {
          _errrorMessage = 'a nova senha não pde ficar vazia';
        });
        return;
      }
      if (next != confirm){
        setState(() {
          _errrorMessage = 'a confirmação não confere com a nova';
       });
       return;
      }

      setState(() {
        _isSaving = true;
        _errrorMessage = null;
      });
      await widget.appStorage.savePassword(next);
      if (!mounted){
        return;
      }
      Navigator.pop(context, true);
    }

    @override
    Widget build(BuildContext context){
      return AlertDialog(
        title: const Text('alterar senha'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'senha atual',

                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'nova senha',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'confirmar nova senha',
                ),
              ),
              if(_errrorMessage != null)...[
                const SizedBox(height: 12),
                Text(
                  _errrorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
actions: [
  TextButton(
    onPressed: _isSaving ? null : () => Navigator.pop(context),
    child: const Text('cancela'),
  ),
  FilledButton(
    onPressed: _isSaving ? null : _save,
    child: const Text('salvar'),
  ),
],

      );
    }
  }
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
    );
  }
}