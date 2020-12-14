class Activity {
  String haciendaName;
  DateTime startDate;
  String suerteName;
  double programedHours;
  String activityName;
  double hoursDone;
  double missingHours;
  String observations;
  String idSuerte;
  String idActivity;
  bool isFinish;

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
      this.idActivity,
      this.isFinish});
}
