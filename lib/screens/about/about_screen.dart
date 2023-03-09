import 'package:easypedv3/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../widgets/base_page_layout.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key? key}) : super(key: key);

  final List<String> authors = <String>[
    "Dr. Ruben Rocha - Pediatra",
    "Dra. Ana Reis Melo - Interna de Pediatria",
    "Dra. Claudia Teles Silva - Interna de Pediatria",
    "Dr. João Sarmento - Interno de Cardiologia Pediátrica",
    "Dra. Mariana Adrião - Interna de Pediatria",
    "Dra. Marta Rosário - Interna de Pediatria",
    "Dr. Ruben Pinheiro - Cirurgião Pediátrico",
    "Dra. Sofia Ferreira - Interna de Pediatria",
    "Dra. Sónia Silva - Interna de Pediatria"
  ];

  final List<String> biblio = <String>[
    "European medicines agency database. Acesso online. Ano 2016 - 2017.",
    "Takemoto CK, Hodding JH, Kraus, DM. Pediatric & Neonatal Dosage Handbook, 21st ed. Hudson, Ohio, Lexi-Comp, Inc. 2014.",
    "Prontuário terapêutico. Infarmed. Versão on-line. Acedida no ano 2016 - 2017.",
    "Formulário hospitalar nacional do medicamento. Infarmed. Versão on-line. Acedida no ano 2016 - 2017.",
    "Medscape drug database. Acesso online. Ano 2016 - 2017.",
    "Anjos R, Bandeira T, Marques JG. Formulário de Pediatria. 3 edição.",
  ];

  Widget authorsWdgt() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: authors.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(authors[index], style: Styles.normalText);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }

  Widget biblioWdgt() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: biblio.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(biblio[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("easyPed")),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
              tileColor: const Color(0xFF28a745),
              title: Text("Autores",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline4),
            ),
            Padding(padding: EdgeInsets.all(5), child: authorsWdgt()),
            ListTile(
              tileColor: const Color(0xFF28a745),
              title: Text("Isenção de Responsabilidade",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline4),
            ),
            Padding(
                padding: const EdgeInsetsDirectional.all(5),
                child: Column(children: const [
                  Text(
                      "Esta aplicação é dirigida a profissionais de saúde. Pretende ser um auxilio à prática da medicina pediátrica. Todos os dados foram inseridos e validados por médicos do corpo clínico do Centro Materno Infantil do Norte e Centro Hospitalar São João. Embora envidemos todos os esforços razoáveis para garantir que as informações contidas na easyPed sejam corretas, esteja ciente de que as informações podem estar incompletas, imprecisas ou desatualizadas e não podem ser garantidas. Assim, está excluída a garantia ou responsabilidade de qualquer tipo. Os autores declinam qualquer responsabilidade na utilização da mesma, devendo qualquer dose ou indicação ser confirmada em documentos de referencia atualizados aquando da prescrição. Qualquer erro relativo aos fármacos pode e deve ser reportado no espaço próprio de cada fármaco. Qualquer sugestão de adição de fármacos ou outra sugestão é bem-vinda e pode ser reportada do mesmo modo que os fármacos."),
                  Gap(1),
                ])),
            ListTile(
              tileColor: const Color(0xFF28a745),
              title: Text("Bibliografia essencial consultada",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline4),
            ),
            Padding(padding: EdgeInsets.all(5), child: biblioWdgt()),
          ]),
        ));
  }
}
