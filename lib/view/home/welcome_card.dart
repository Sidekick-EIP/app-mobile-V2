import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';

class WelcomeCardWOutSidekick extends StatelessWidget {
  const WelcomeCardWOutSidekick({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 345,
        height: 141,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.7),
          color : const Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text('Bienvenue !', textAlign: TextAlign.left,
                    style: pSemiBold20
                ),
              ), Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('Recherche en cours... Vous recevrez une notification lorsque le partenaire parfait sera trouvé.',
                          style: pRegular14,
                      ),
                    ),
                  ), Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                        width: 53,
                        height: 78,
                        decoration: const BoxDecoration(
                          image : DecorationImage(
                              image: AssetImage(DefaultImages.hourGlass),
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
            boxShadow : const [
              BoxShadow(
                color: Color.fromRGBO(242, 93, 41, 0.5),
                blurRadius: 16
              ),
            ],
            color: ConstColors.primaryColor,
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
                          style: pSemiBold18.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('Lui envoyer un message', textAlign: TextAlign.center,
                                  style: pRegular14,
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

