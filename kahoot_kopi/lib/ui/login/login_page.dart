import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:kahoot_kopi/classes/helpers/api.dart';
import 'package:kahoot_kopi/classes/helpers/general_helper.dart';
import 'package:kahoot_kopi/classes/objects/join_session_dto.dart';
import 'package:kahoot_kopi/classes/objects/path.dart';
import 'package:kahoot_kopi/ui/login/login_bloc.dart';
import 'package:kahoot_kopi/widgets/default_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController pinController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      child: BlocProvider(
          create: (_) => LoginBloc(buildContext: context),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage('assets/logo.png')),
            
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: TextField(
                      controller: pinController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Game Pin',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: TextField(
                      controller: nicknameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nickname',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        Response res = await API.postRequest(
                          ApiPath.quizSession, 
                          API.createJoinEnvelope(
                            JoinSessionDto(
                              pin: pinController.text, 
                              nickname: nicknameController.text,
                            ),
                          ),
                        );

                        if (res.statusCode == 200) {
                          context.read<LoginBloc>().add(JoinGameEvent(response: res));
                        } else {
                          GeneralHelper.makeSnackBar('Error: ${res.body}');
                        }
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    child: const Text('Join Game'),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
