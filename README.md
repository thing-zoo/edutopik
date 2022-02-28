# 2021 2학기 종합프로젝트 설계-1
- 모바일 단말기 보안인증과 미디어서버 컨트롤 앱 개발 (참여 기업체 : (주)조은 캠프)

```
             TEAM : 4B
컴퓨터학부 글로벌Sw융합전공 19학번 김민지(Frontend)
컴퓨터학부 글로벌Sw융합전공 19학번 정명주(Frontend)
컴퓨터학부 글로벌Sw융합전공 19학번 이세은(Backend)
컴퓨터학부 글로벌Sw융합전공 19학번 이승신(Backend)
```
<br/>

## Project Title  << 모바일 단말기 보안인증과 미디어서버 컨트롤 앱 개발 >>
   
---------------------------------------------
## [목차]

- [실행방법](#실행방법)
- [과제수행배경](#과제수행배경)
- [과제수행목표](#과제수행목표)
- [개발환경](#개발환경)
- [과제수행결과](#과제수행결과)
- [프로젝트개발내용](#프로젝트개발내용)
- [기대효과](#기대효과)
- [데모영상](#데모영상)
--------------------------------------------
## 실행방법

1. `git clone/download`
2. `cd edutopik/lib` (해당 폴더로 이동)
3. `flutter packages get` (파일 실행에 필요한 패키지 다운)
4. `flutter run`

## 개발배경

<img width="910" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155928377-c63dc272-0f3f-4127-9304-d4c59f2a36fd.png">
- IOS 기반의 기기 사용자가 많은 실정이나 해당 기업에서는 IOS 사용자를 위한 어플이 없음.

<img width="744" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155928299-bf0614d5-8d72-49d9-8d74-54ddb45f6027.png">
- 인터넷 강의 시장에서는 ID 공유에 대한 문제가 심각하게 대두
- 해당 기업에서는 저희에게 이 부분을 방지 할 수 있는 방안 제안 및 개발을 요청 

>> 따라서 IOS기반의 모바일 단말기 보안인증과 미디어서버 컨트롤 앱 개발을 진행함

## 과제수행목표

<img width="528" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155928620-e510b48a-eff8-4410-8f49-ee883df612b6.png">

- `IOS Application 개발`
- `UUID 및 다중 인증 요소를 활용한 강의 부정 시청 방지 서비스 개발`

## 개발환경

<img width="759" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155928709-fb21083e-3ec1-4a57-932f-6b1ed7a7a28b.png">

- 기업 측에서는 EDU TOPIK 웹 사이트를 중심으로 하되, 모바일에서도 쉽게 강의를 들을 수 있는 앱을 요구함
- 이에 따라 우리는 Web App과 Native App을 결합한 형태의 Hybrid App으로 개발을 진행

## 과제수행결과

 - 웹-앱간 HTTPS를 이용한 통신 보안 강화
 - UUID를 이용한 기기등록 및 인증
 - 같은 아이디 동시수강 방지
 
## 프로젝트개발내용
1. 웹/앱 통신

<img width="495" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155929266-d1ae5144-f298-4886-adf5-bd66aac743a7.png">

- 기업 측 요청으로 웹앱과 네이티브 앱이 결합된 하이브리드 어플을 개발
- 따라서 네이티브 부분과 웹 부분의 통신이 필수적이었음
- 서버측에서 앱 측으로 데이터를 보내야 하는 경우 웹앱 실행 시 함께 열어둔 Javascript Channel을 이용하였으며 앱에서 서버로 데이터를 요청 및 전송 할 때는 HTTP의 Get, Post 통신을 이용함

2. 통신 보안 강화

<img width="470" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155929337-7e2cc2d1-5c42-4eb4-af9b-3ccceb458bb5.png">

- 기존 기업체가 사용하던 웹 서버는 타인이 통신 내용을 볼 수 있는 HTTP 통신을 사용
- 보안을 위해 세션 키로 데이터 암호화를 하는 HTTPS를 도입함
- 이로써 악의적인 사용자의 개입을 차단하고, 통신 내용을 엿볼 수 없도록 보안성을 강화함

3. UUID를 활용한 기기등록 

<img width="481" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155930343-8c0fd159-bd22-4cd9-8258-eb0ca19d9353.png">

- 기기고유값인 IMEI가 있지만, 이는 보안상의 문제로 현재 사용하고 있지 않기에 저희는 개인 정보 사용에 대한 문제도 해결하고, 고유 기기를 인식 할 수 있는 UUID를 활용하기로 함. 
- 이 값을 통하여 개별 기기를 인식 하였음

4. 자동 로그인 기능 및 기기등록 개수 2개 제한

<img width="512" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155930421-af0ea683-7ad0-4eaf-9eaf-ce82c8268deb.png">

<img width="494" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155930631-bf8f46a0-92a3-4b1a-9ff1-e2bd175069bc.png">

- 앱이 실행되면 앱 내의 storage에 이전 로그인 기록이 저장되어 있는지를 확인함
- 저장된 값이 있다면 해당 기기 등록 유효성을 서버와의 통신으로 확인 후 메인 페이지로 자동 로그인이되도록 구현
- 해당 기기 등록 개수를 2개로 제한함
- 특히 이미 2개 이상의 기기가 등록되어있는 경우, 사용자가 기존에 등록된 기기들 중 삭제할 기기를 선택할 수 있도록 함

5. 같은 아이디 동시 수강 방지

<img width="510" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155930683-c5c73f1c-83c7-4804-a5a7-76b791e10298.png">

- 강의를 클릭하면 자바스크립트 채널 통신을 통해 강의 재생 관련 데이터 및 중복 여부 값을 받음
- 이미 기존에 다른 기기로 강의를 시청 중이었다면 기기 변경 여부를 묻고 사용자가 원한다면 플레이어를 실행

6. 미디어 컨트롤 

<img width="519" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155930780-b45ded05-bf14-4991-ae76-800b146d411a.png">
- 미디어 컨트롤 관련 서비스도 구현함

## 기대효과

<img width="510" alt="Untitled" src="https://user-images.githubusercontent.com/62577565/155930861-42466fad-c374-4e27-a76a-e3a87d51c3df.png">

## 데모영상
https://drive.google.com/file/d/1zeHEFAZ_MVS100wnBH0Km4YZpaxTZs_3/view

