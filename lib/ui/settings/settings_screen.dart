import 'package:appsagainsthumanity/authentication_bloc/authentication_bloc.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/settings/widgets/preference.dart';
import 'package:appsagainsthumanity/ui/settings/widgets/preference_header.dart';
import 'package:appsagainsthumanity/ui/settings/widgets/user_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          PreferenceCategory(
            title: "Account",
            children: [
              UserPreference(),
              Preference(
                title: "Delete account",
                titleColor: Colors.redAccent,
                icon: Icon(
                  MdiIcons.deleteForeverOutline,
                  color: Colors.redAccent,
                ),
                onTap: () {
                  _deleteAccount(context);
                },
              ),
              Preference(
                title: "Sign out",
                icon: Icon(
                  MdiIcons.logout,
                  color: Colors.black54,
                ),
                onTap: () {
                  _signOut(context);
                },
              )
            ],
          ),
          PreferenceCategory(
            title: "Legal",
            children: [
              Preference(
                title: "Privacy Policy",
                icon: Icon(
                  MdiIcons.shieldSearch,
                  color: Colors.black54,
                ),
                onTap: () {
                  // TODO: Open web browser
                },
              ),
              Preference(
                title: "Terms of service",
                icon: Icon(
                  MdiIcons.formatFloatLeft,
                  color: Colors.black54,
                ),
                onTap: () {
                  // TODO: Open web browser
                },
              ),
              Preference(
                title: "Open Source Licenses",
                icon: Icon(
                  MdiIcons.sourceBranch,
                  color: Colors.black54,
                ),
                onTap: () {
                  showLicensePage(context: context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _deleteAccount(BuildContext context) async {
    bool result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete account?",
              style: context.theme.textTheme.headline6.copyWith(color: Colors.redAccent),
            ),
            content: Text(
              "Are you sure you want to delete your account? This is permenant and cannot be undone.",
              style: context.theme.textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              FlatButton(
                child: Text("CANCEL"),
                textColor: Colors.white70,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("DELETE ACCOUNT"),
                textColor: Colors.redAccent,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (result ?? false) {
      var userRepository = context.repository<UserRepository>();
      try {
        await userRepository.deleteAccount();
        context.bloc<AuthenticationBloc>()
            .add(LoggedOut());
      } catch (e) {
        if (e is PlatformException) {
          if (e.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
            await userRepository.signInWithGoogle();
            await userRepository.deleteAccount();
            context.bloc<AuthenticationBloc>()
                .add(LoggedOut());
          }
        }
      }
    }
  }

  void _signOut(BuildContext context) async {
    var userRepository = context.repository<UserRepository>();
    await userRepository.signOut();
    context.bloc<AuthenticationBloc>()
      .add(LoggedOut());
  }
}

class PreferenceCategory extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets margin;

  PreferenceCategory({
    this.title,
    this.margin,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              if (title != null) PreferenceHeader(title: title, includeIconSpacing: false),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}