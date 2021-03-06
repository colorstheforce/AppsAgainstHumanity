import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/game_bottom_sheet.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/game_status_title.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/judge_bar.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/player_list.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/player_response_picker.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/prompt_container.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/re_deal_button.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/winning/turn_winner_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GamePlayScreen extends StatefulWidget {
  final GameViewState state;

  GamePlayScreen(this.state);

  @override
  State<StatefulWidget> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 56,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: GameStatusTitle(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ReDealButton(),
                    ),
                    IconButton(
                      icon: Icon(MdiIcons.accountGroup),
                      color: Colors.white,
                      onPressed: () {
                        _showPlayerBottomSheet(context);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: BlocListener<GameBloc, GameViewState>(
        condition: (previous, current) {
          return current.game.turn?.winner != previous.game.turn?.winner;
        },
        listener: (context, state) {
          // Show bottom sheet modal for the winner
          var turnWinner = state.game.turn?.winner;
          if (turnWinner != null) {
            print("Showing winner sheet");
            _showWinnerBottomSheet(context, state);
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          JudgeBar(),
          Expanded(
            child: Stack(
              children: <Widget>[
                PromptContainer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 256,
                    child: PlayerResponsePicker(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showWinnerBottomSheet(BuildContext context, GameViewState state) {
    Analytics().logViewItemList(itemCategory: 'turn_winner');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.97,
          builder: (context, scrollController) {
            return GameBottomSheet(
              title: "Round ${state.game.round}",
              child: TurnWinnerSheet(state, scrollController),
            );
          },
        );
      },
    );
  }

  void _showPlayerBottomSheet(BuildContext context) {
    Analytics().logViewItemList(itemCategory: 'players');
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            maxChildSize: 0.885,
            builder: (context, scrollController) {
              return GameBottomSheet(
                title: "Players",
                actions: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 56,
                    alignment: Alignment.center,
                    child: Text(
                      widget.state.game.gid,
                      style: context.theme.textTheme.headline6.copyWith(
                        color: AppColors.primaryVariant,
                      ),
                    ),
                  )
                ],
                child: PlayerList(widget.state.game, scrollController),
              );
            },
          );
        });
  }
}
