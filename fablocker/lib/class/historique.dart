class Historique {
  final int casier;
  final String item;
  final String utilisateur;
  final DateTime dateEmprunt;
  final DateTime dateRetourPrevu;
  final DateTime dateRetour;
  final int? dureeAutorisee;
  

  Historique(this.casier, this.item, this.utilisateur, this.dateEmprunt, this.dateRetourPrevu, this.dateRetour, this.dureeAutorisee, int dureeEmprunt);
}