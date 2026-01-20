import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pin_page_bloc.dart';
import 'pin_page_events_states.dart';
import '../../widgets/default_scaffold.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  TextEditingController pinController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  
  Future<void> selected(String value) async {
    switch (value) {
      case 'mypage':
        // Navigate to My Page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PinBloc(),
      child: BlocBuilder<PinBloc, PinState>(
        builder: (context, state) => DefaultScaffold(
          additionalWidgets: [
            PopupMenuButton<String>(
              color: Colors.grey[900],
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onSelected: (selected) => context.read<PinBloc>().add(DropdownSelected(selected: selected)),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'mypage',
                  child: Text('My page', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Image(image: AssetImage('assets/logo.png'))),
              const SizedBox(height: 30),

              if (state is EnterPinState)
                _buildEnterPinState(context, state),
                
              if (state is EnterNicknameState)
                _buildEnterNicknameState(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnterPinState(BuildContext context, EnterPinState state) {
    return Column(
      children: [
        const Text(
          'Enter the Game Pin',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: TextField(
            controller: pinController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Game Pin',
            ),
          ),
        ),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: state.isLoading ? null : () =>context.read<PinBloc>().add(CheckPinEvent(pin: pinController.text)),
          child: state.isLoading ? 
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Next'),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildEnterNicknameState(BuildContext context, EnterNicknameState state) {
    return Column(
      children: [
        const Text(
          'Enter Your Nickname',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: TextField(
            controller: nicknameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nickname',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                pinController.clear();
                context.read<PinBloc>().add(
                  CheckPinEvent(pin: ''),
                );
              },
              child: const Text('Back'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                context.read<PinBloc>().add(EnterNicknameEvent(nickname: nicknameController.text));
              },
              child: const Text('Join Game'),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
