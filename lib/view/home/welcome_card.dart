import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeCardWOutSidekick extends StatelessWidget {
  const WelcomeCardWOutSidekick({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 345,
        height: 141,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.7),
          color : Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text('Bienvenue !', textAlign: TextAlign.left, style: TextStyle(
                  color: Color.fromRGBO(10, 6, 21, 1),
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
                ),
              ), Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Recherche en cours... Vous recevrez une notification lorsque le partenaire parfait sera trouvé.', style: TextStyle(
                          color: Color.fromRGBO(10, 6, 21, 1),
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          height: 1.3
                      ),
                      ),
                    ),
                  ), Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                        width: 53,
                        height: 78,
                        decoration: const BoxDecoration(
                          image : DecorationImage(
                              image: AssetImage('assets/images/hourglass.png'),
                              fit: BoxFit.fitWidth
                          ),
                        )
                    ),
                  ),
                ],
              )
            ]
        )
    );
  }
}

class WelcomeCardWSidekick extends StatelessWidget {
  final String sidekickName;
  final String imagePath;
  const WelcomeCardWSidekick({super.key, required this.sidekickName, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 345,
          height: 142,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.7),
            boxShadow : [
              BoxShadow(
                color: Color.fromRGBO(242, 93, 41, 0.5),
                blurRadius: 16
              ),
            ],
            color: Color(0xffF25D29),
          ),
          child: Row(
              children: <Widget>[
                Container(
                  width: 132,
                  height: 142,
                  decoration: const BoxDecoration(
                    image : DecorationImage(
                        image: AssetImage('assets/images/welcome_icon.png'),
                        fit: BoxFit.fitWidth
                    ),
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('$sidekickName vient de réaliser sa séance d’abdos il y a 3h !',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          )
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17.5),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 3, bottom: 3, left: 3),
                                child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(imagePath),
                                      ),
                                    ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('Lui envoyer un message', textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]
          )
      );
  }
}

