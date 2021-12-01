class PlayTime {
  dynamic get_time_url; //강의 데이터 수신 url
  dynamic send_url; //강의 데이터 발신 url
  dynamic uid; //아이디
  dynamic ocode; //주문코드
  dynamic scode; //챕터코드
  dynamic lm_num; //챕터내 강의 차시
  dynamic lm_time; //강의 전체 시간
  dynamic uuid; //UUID
  dynamic current_time; //이어볼 시청 지점
  dynamic fin; //Y: 강의 시청 완료, N: 강의 시청중
  dynamic check_log_url; //중복시청 여부 확인 url

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
    this.check_log_url,
  });
}
