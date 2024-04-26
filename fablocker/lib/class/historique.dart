class Historique {
  final int casier;
  final String item;
  final String utilisateur;
  final DateTime dateEmprunt;
  DateTime dateRetour;

  Historique(this.casier,this.item, this.utilisateur, this.dateEmprunt,this.dateRetour);
}
