import 'package:flutter/material.dart';

import '../data/necessidades.dart';
import '../models/pessoa.dart';
import '../services/pessoa_service.dart';
import '../services/pessoa_validator.dart';
import '../theme/app_colors.dart';

class PessoaFormScreen extends StatefulWidget {
  final Pessoa? pessoa;

  const PessoaFormScreen({super.key, this.pessoa});

  @override
  State<PessoaFormScreen> createState() => _PessoaFormScreenState();
}

class _PessoaFormScreenState extends State<PessoaFormScreen> {
  final PessoaService _pessoaService = PessoaService();

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _padrinhoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _reservaController = TextEditingController();
  final _destinoController = TextEditingController();
  final _observacoesController = TextEditingController();

  String _necessidade = necessidades.first;

  bool _consentimento = false;

  bool _salvando = false;

  bool get _editando => widget.pessoa != null;

  @override
  void initState() {
    super.initState();

    final pessoa = widget.pessoa;

    if (pessoa != null) {
      _nomeController.text = pessoa.nome;
      _idadeController.text = pessoa.idade.toString();
      _enderecoController.text = pessoa.endereco;
      _padrinhoController.text = pessoa.padrinho;
      _telefoneController.text = pessoa.telefonePadrinho;
      _reservaController.text = pessoa.padrinhoReserva;
      _destinoController.text = pessoa.destinoSeguro;
      _observacoesController.text = pessoa.observacoes;
      _consentimento = pessoa.consentimento;

      _necessidade = necessidades.contains(pessoa.necessidade)
          ? pessoa.necessidade
          : necessidades.last;
    }
  }

  Future<void> _salvar() async {
    final valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Revise os campos marcados em vermelho.')),
        );
      return;
    }

    setState(() {
      _salvando = true;
    });

    final original = widget.pessoa;

    final pessoa = Pessoa(
      id: original?.id ?? PessoaService.novoId(),
      nome: _nomeController.text.trim(),
      idade: int.parse(_idadeController.text.trim()),
      endereco: _enderecoController.text.trim(),
      necessidade: _necessidade,
      padrinho: _padrinhoController.text.trim(),
      telefonePadrinho: _telefoneController.text.replaceAll(RegExp(r'\D'), ''),
      padrinhoReserva: _reservaController.text.trim().isEmpty
          ? 'Não definido'
          : _reservaController.text.trim(),
      destinoSeguro: _destinoController.text.trim(),
      observacoes: _observacoesController.text.trim().isEmpty
          ? 'Sem observações.'
          : _observacoesController.text.trim(),
      consentimento: _consentimento,
      prioritaria: original?.prioritaria ?? false,
      status: original?.status ?? StatusPessoa.aguardando,
      statusDesde: original?.statusDesde ?? DateTime.now(),
    );

    final salva = await _pessoaService.salvar(pessoa);

    if (!mounted) return;

    Navigator.pop(context, salva);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar cadastro' : 'Novo cadastro'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const _TituloSecao(
              icone: Icons.person_outline,
              texto: 'Quem precisa de ajuda',
            ),
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nome completo *'),
              validator: PessoaValidator.nome,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  child: TextFormField(
                    controller: _idadeController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Idade *'),
                    validator: PessoaValidator.idade,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _necessidade,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Necessidade'),
                    items: necessidades.map((necessidade) {
                      return DropdownMenuItem(
                        value: necessidade,
                        child: Text(
                          necessidade,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (valor) {
                      setState(() {
                        _necessidade = valor ?? necessidades.first;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _enderecoController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Endereço *',
                hintText: 'Rua e número',
              ),
              validator: (valor) =>
                  PessoaValidator.obrigatorio(valor, 'o endereço'),
            ),
            const SizedBox(height: 24),
            const _TituloSecao(
              icone: Icons.volunteer_activism_outlined,
              texto: 'Plano de saída',
            ),
            TextFormField(
              controller: _padrinhoController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Padrinho *'),
              validator: (valor) =>
                  PessoaValidator.obrigatorio(valor, 'o padrinho'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Telefone do padrinho *',
                hintText: '(11) 90000-0000',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: PessoaValidator.telefone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _reservaController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Padrinho reserva'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _destinoController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Destino seguro *',
                hintText: 'Ex.: escola, igreja, casa de parente',
              ),
              validator: (valor) =>
                  PessoaValidator.obrigatorio(valor, 'o destino seguro'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _observacoesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observações',
                hintText: 'Remédios, aparelhos, como entrar na casa...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            FormField<bool>(
              initialValue: _consentimento,
              validator: PessoaValidator.consentimento,
              builder: (campo) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: campo.hasError
                          ? AppColors.vermelhoAguardando
                          : AppColors.borda,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: _consentimento,
                    onChanged: (valor) {
                      setState(() {
                        _consentimento = valor ?? false;
                      });
                      campo.didChange(valor);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.asfalto,
                    title: const Text(
                      'A pessoa (ou seu responsável) autorizou o cadastro *',
                    ),
                    subtitle: Text(
                      campo.errorText ??
                          'O endereço só é usado para o padrinho chegar até ela.',
                      style: TextStyle(
                        color: campo.hasError
                            ? AppColors.vermelhoAguardando
                            : AppColors.textoSecundario,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _salvando ? null : _salvar,
              icon: _salvando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_editando ? 'Salvar alterações' : 'Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _enderecoController.dispose();
    _padrinhoController.dispose();
    _telefoneController.dispose();
    _reservaController.dispose();
    _destinoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }
}

class _TituloSecao extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _TituloSecao({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icone, color: AppColors.textoSecundario),
          const SizedBox(width: 8),
          Text(texto, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
