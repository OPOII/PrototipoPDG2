import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserView extends StatefulWidget {
  final dynamic user;

  UserView({Key key, this.user}) : super(key: key);
  @override
  _UserViewState createState() => _UserViewState(user);
}

class _UserViewState extends State<UserView> {
  dynamic usuario;
  _UserViewState(this.usuario);
  @override
  Widget build(BuildContext context) {
    print(usuario['urlfoto']);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Informacióm personal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/imgs/fondo.jpg"),
                        fit: BoxFit.cover)),
                height: 200,
                child: Align(
                    alignment: Alignment.center,
                    child: ProfilePic(user: usuario))),
            SizedBox(
              height: 20,
            ),
            ProfileMenu(
              text: usuario['name'],
              icon: Icons.account_circle,
              press: () => {},
            ),
            ProfileMenu(
              text: usuario['telephone'].toString(),
              icon: Icons.phone,
              press: () => {},
            ),
            ProfileMenu(
              text: usuario['email'],
              icon: Icons.contact_mail,
              press: () => {},
            ),
            ProfileMenu(
              text: usuario['cedula'].toString(),
              icon: Icons.portrait,
              press: () => {},
            ),
            ProfileMenu(
              text: usuario['birthday'].toString(),
              icon: Icons.cake,
              press: () => {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  final dynamic user;
  ProfilePic({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: 120,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
              backgroundImage: NetworkImage(user['urlfoto']),
              backgroundColor: Colors.transparent),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {},
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
