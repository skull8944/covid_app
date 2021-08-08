class CovidInfo {
  String date;
  String totalConfirmed;
  String localConfirmed;
  String newTotalConfirmed;
  String newLocalConfirmed;
  String totalDeath;
  String newDeath;
  String injection;
  String newInjection;

  CovidInfo(this.date,
            this.totalConfirmed, this.localConfirmed, 
            this.newTotalConfirmed, this.newLocalConfirmed, 
            this.totalDeath, this.newDeath,
            this.injection, this.newInjection);
}