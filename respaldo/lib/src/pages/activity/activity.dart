class Activity {
  String haciendaName;
  DateTime startDate;
  String suerteName;
  double programedHours;
  String activityName;
  double hoursDone;
  double missingHours;
  String observations;
  int idSuerte;
  int idActivity;

  Activity(
      {this.haciendaName,
      this.startDate,
      this.suerteName,
      this.programedHours,
      this.activityName,
      this.hoursDone,
      this.missingHours,
      this.observations,
      this.idSuerte,
      this.idActivity});
}
