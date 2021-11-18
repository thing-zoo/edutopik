class PlayTime {
  dynamic get_time_url;
  dynamic send_url;
  dynamic uid;
  dynamic ocode;
  dynamic scode;
  dynamic lm_num;
  dynamic lm_time; //강의 전체 시간
  dynamic uuid;
  dynamic current_time; //마지막 시청 지점
  dynamic fin; //Y: 강의 수강 완료, N: 강의 시청중

  PlayTime({
    this.get_time_url,
    this.send_url,
    this.uid,
    this.ocode,
    this.scode,
    this.lm_num,
    this.lm_time,
    this.uuid,
    this.current_time,
    this.fin,
  });
}
