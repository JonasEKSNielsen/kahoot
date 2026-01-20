import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../colors.dart';
import '../../widgets/answer_button.dart';
import '../../widgets/leaderboard.dart';
import '../../widgets/rank_card.dart';
import 'quiz_bloc.dart';
import 'quiz_events_states.dart';
import '../../widgets/default_scaffold.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.pin, required this.nickname, required this.quizSessionId, required this.participantId});

  final String pin;
  final String nickname;
  final String quizSessionId;
  final int participantId;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> { 
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizBloc(
        pin: widget.pin, 
        nickname: widget.nickname, 
        quizSessionId: widget.quizSessionId,
        participantId: widget.participantId,
      ),
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) => DefaultScaffold(
          title: state is ShowQuestionState ? state.question.text : null,
          showTitle: true,
          additionalWidgets: [
            if (state is JoinedWaitingState)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    widget.nickname,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            if (state is ShowQuestionState)
              CircleAvatar(
                backgroundColor: grey,
                child: Text(
                  '1',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
          ],
          child: Builder(
            builder: (context) {
              switch (state.runtimeType) {
                case const (WaitingForNextQuestionState):
                  return _buildWaitingState(context, state as WaitingForNextQuestionState);
                
                case const (ShowQuestionState):
                  return _buildShowQuestionState(context, state as ShowQuestionState);

                case const (GameCompletedState):
                  return _buildGameCompletedState(context, state as GameCompletedState);

                default:
                  return _buildJoinedWaitingState(context, state as JoinedWaitingState);
              }
            }
          ),
        ),
      ),
    );
  }

  Widget _buildJoinedWaitingState(BuildContext context, JoinedWaitingState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "You've Joined!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Nickname: ${widget.nickname}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text(
            'Waiting for the game to start...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWaitingState(BuildContext context, WaitingForNextQuestionState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      
          const SizedBox(height: 10),
          
          Text(
            state.title ?? 'Waiting for next question',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  Widget _buildShowQuestionState(BuildContext context, ShowQuestionState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int rows = (state.question.answers.length / 2).ceil();
        
        const double padding = 10; 
        const double rowSpacing = 10;
        const double columnSpacing = 10;
        
        double totalRowSpacing = (rows - 1) * rowSpacing;
        double itemWidth = (constraints.maxWidth - padding - columnSpacing) / 2;
        double itemHeight = (constraints.maxHeight - padding - totalRowSpacing) / rows;
        double childAspectRatio = itemWidth / itemHeight;
        
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: columnSpacing,
              mainAxisSpacing: rowSpacing,
              childAspectRatio: childAspectRatio,
            ),
            padding: const EdgeInsets.symmetric(horizontal: padding),
            itemBuilder: (context, i) => AnswerButton(
              answer: state.question.answers[i]!,
              color: quizColors[i],
              onPressed: () {
                if (state.question.answers[i]!.id != null && state.question.id != null) {
                  context.read<QuizBloc>().add(SubmitAnswerEvent(answerId: state.question.answers[i]!.id!, questionId: state.question.id!));
                }
              },
            ),
            itemCount: state.question.answers.length,
          ),
        );
      },
    );
  }

  Widget _buildGameCompletedState(BuildContext context, GameCompletedState state) {
    final leaderboardItems = state.leaderboard ?? [];
    final currentPlayerRank = state.currentPlayerRank;
    
    // Get top 5 players
    final topFive = leaderboardItems.length > 5 
      ? leaderboardItems.sublist(0, 5)
      : leaderboardItems;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (currentPlayerRank != null)
              rankCard(currentPlayerRank: currentPlayerRank, nickname: widget.nickname),
            const SizedBox(height: 30),
            
            const Text(
              'Leaderboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            if (topFive.isNotEmpty)
              Leaderboard(leaderboardItems: topFive),
          ],
        ),
      ),
    );
  }
}

