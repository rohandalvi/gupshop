import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/VideoCallBackendService.dart';
import 'package:gupshop/video_call/debug.dart';
import 'package:gupshop/video_call/models/twilio/twilio_enums.dart';
import 'package:gupshop/video_call/room/room_bloc.dart';
import 'package:gupshop/video_call/room/room_model.dart';
import 'package:gupshop/video_call/widgets/button_to_progress.dart';
import 'package:gupshop/video_call/widgets/conference_page.dart';
import 'package:gupshop/video_call/widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class JoinRoomForm extends StatefulWidget {
  final RoomBloc roomBloc;

  const JoinRoomForm({
    Key key,
    @required this.roomBloc,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final backendService = Provider.of<VideoCallBackendService>(context, listen: false);
    return Provider<RoomBloc>(
      create: (BuildContext context) => RoomBloc(backendService: backendService),
      child: Consumer<RoomBloc>(
        builder: (BuildContext context, RoomBloc roomBloc, _) => JoinRoomForm(
          roomBloc: roomBloc,
        ),
      ),
      dispose: (BuildContext context, RoomBloc roomBloc) => roomBloc.dispose(),
    );
  }

  @override
  _JoinRoomFormState createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends State<JoinRoomForm> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _submit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
//    return StreamBuilder<RoomModel>(
//        stream: widget.roomBloc.modelStream,
//        initialData: RoomModel(),
//        builder: (BuildContext context, AsyncSnapshot<RoomModel> snapshot) {
//          final roomModel = snapshot.data;
//          return Padding(
//            padding: const EdgeInsets.only(left: 16, right: 16),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              children: _buildChildren(roomModel),
//            ),
//          );
//        });
  }

  List<Widget> _buildChildren(RoomModel roomModel) {
    return <Widget>[
      TextField(
        key: Key('enter-room-name'),
        decoration: InputDecoration(
          labelText: 'Enter room name',
          errorText: roomModel.nameErrorText,
          enabled: !roomModel.isLoading,
        ),
        controller: _nameController,
        onChanged: widget.roomBloc.updateName,
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              'Room size:',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton(
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              isExpanded: true,
              items: <TwilioRoomType>[TwilioRoomType.group, TwilioRoomType.groupSmall].map<DropdownMenuItem<TwilioRoomType>>((TwilioRoomType value) {
                return DropdownMenuItem<TwilioRoomType>(
                  value: value,
                  child: Text(RoomModel.getTypeText(value)),
                );
              }).toList(),
              value: widget.roomBloc.model.type,
              onChanged: widget.roomBloc.updateType,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      _buildButton(roomModel),
      const SizedBox(
        height: 16,
      ),
    ];
  }

  Widget _buildButton(RoomModel roomModel) {
    return ButtonToProgress(
      onLoading: widget.roomBloc.onLoading,
      loadingText: 'Creating the room...',
      progressHeight: 2,
      child: FlatButton(
        key: Key('join-button'),
        color: Theme.of(context).appBarTheme?.color ?? Theme.of(context).primaryColor,
        disabledColor: Colors.grey.shade300,
        child: FittedBox(
          child: Text(
            'JOIN',
            style: TextStyle(color: Theme.of(context).appBarTheme?.textTheme?.headline6?.color ?? Colors.white),
          ),
        ),
        onPressed: roomModel.canSubmit && !roomModel.isLoading ? () => _submit() : null,
      ),
    );
  }

  Future<void> _submit() async {
    try {
      final roomModel = await widget.roomBloc.submit();
      await Navigator.of(context).push(
        MaterialPageRoute<ConferencePage>(
          fullscreenDialog: true,
          builder: (BuildContext context) => ConferencePage(roomModel: roomModel),
        ),
      );
    } catch (err) {
      Debug.log(err);
      await PlatformExceptionAlertDialog(
        exception: err,
      ).show(context);
    }
  }
}
