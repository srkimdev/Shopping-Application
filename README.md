# Mall봐
> 제주도에서 한달살기를 경험했거나 현재 하고있는 사람들이 정보를 공유하고 소통할 수 있는 앱
<br/>

## 스크린샷

|![Simulator Screenshot - iPhone 15 Pro - 2024-10-17 at 20 32 15](https://github.com/user-attachments/assets/fcf48aab-4a52-44f0-aff7-77d244318eee)|![Simulator Screenshot - iPhone 15 Pro - 2024-10-17 at 20 32 38](https://github.com/user-attachments/assets/d4cd0c25-0f37-4efd-8a4d-09aaf10ad3c2)|![Simulator Screenshot - iPhone 15 Pro - 2024-10-17 at 16 26 24](https://github.com/user-attachments/assets/dd9b5180-1655-4a2a-be1c-5d9c1ec05a40)|![Simulator Screenshot - iPhone 15 Pro - 2024-10-17 at 21 00 27](https://github.com/user-attachments/assets/b24d9142-eedf-4470-86fb-70d8326eface)|
|--|--|--|--|

<br>

## 프로젝트 환경
- 개발 인원:
  - iOS 1명
- 개발 기간:
  - 24.06.11 - 24.06.18 ( 7일 )
- 개발 환경:

    | iOS version | <img src="https://img.shields.io/badge/iOS-15.0+-black?logo=apple"/> |
    |:-:|:-:|
    | Framework | UIKit |
    | Architecture | MVVM |
    | Reactive | Custom Observable |

<br/>

## 기술 스택 및 라이브러리
- UI: `WebKit`, `SnapKit`, `Toast`
- Network: `URLSession`, `Kingfisher`, `Reachability`
- Database: `Realm`

<br/>

## 핵심 기능

- 검색 기반 상품 조회
- 정확도, 날짜순, 가격높은순, 가격낮은순 필터 기능
- 최근 검색어
- 좋아요한 상품 확인
- 사용자 프로필 사진, 이름 설정 및 수정
- 탈퇴하기

<br/>
 
## 핵심 기술 구현 사항

- ### Custom Observable
  - 반응형 프로그래밍을 1st party에서 구현해보고 싶어서 RxSwift에 있는 Observable을 커스텀하여 사용

<br>

- ### Skeleton View 구현
  - 네트워크 통신이 오래걸릴 시 사용자에게 로딩되고 있다는 것을 보여줌
  

<br>

- ### 상태코드 분기 처리
  - 네트워크 통신 시 발생할 수 있는 에러의 상태코드를 분기하여 각 상태코드에 따른 에러메세지를 보여줌
 
<br>

- ### 상품 조회
  - 네이버 Shopping API를 이용하여 사용자 검색에 따른 상품들을 조회함

<br>

- ### 네트워크 통신 단절 시 메세지 알림
  - 



<br/>

## 트러블 슈팅
### 1. Kingfisher의 ~를 가지고 메모리 성능 개선
- 상황
  - 숙소 검색 화면에서 지역 검색 시 최근 검색어에는 검색어의 목록이 컬렉션뷰로 보여지게 되고 검색어의 길이에 따라 셀의 크기를 다르게 설정하였음
  - 첫번째 검색어는 텍스트의 크기에 맞게 셀이 만들어졌지만 두번째 검색부터는 이전 검색어 셀과 똑같은 셀의 크기를 가지거나 잘 잡지 못함
   
      <img width="201" alt="스크린샷 2024-10-18 오후 7 50 04" src="https://github.com/user-attachments/assets/eb919ce7-4436-4e78-828e-92bb08db4163">
  
- 원인 분석
  - 이전 셀이 가지고 있는 내용과 상태를 초기화해줄 필요가 있음
  - UICollectionViewCell의 prepareForReuse를 호출하는 과정에서 부모 클래스의 prepareForReuse를 호출하지 않았음

- 해결
  - super.prepareForReuse를 호출하여 부모클래스에서 prepareForReuse가 수행하는 기본동작을 실행하도록 함
  <br>

     ```swift
     override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
     }
     ```
<br>

### 2. addtarget 매번 선언 문제
- 상황
  - 게시물 공유 화면 진입 시 PublishSubject로 선언된 viewDidLoadTrigger를 통해 viewModel에서 네트워크 통신을 하고 받아온 게시물을 보여줌
  - viewDidLoadTrigger가 viewModel의 Input으로 들어가고 네트워크 통신하도록 바인드 되어 있음
 
- 원인 분석
  - PublishSubject는 bind를 걸어주고 난 후에 이벤트가 방출된 것을 구독하는 특징이 있음
  - 처음에 viewDidLoadTrigger가 viewModel과 연결되어 바인드 되어있는 것은 맞지만 그 이후에 방출되는 이벤트가 없기 때문에 네트워크 통신을 하지 않음
 
- 해결 
  - 시점 문제를 해결하기 위해 구독할 때 처음에 가지고 있는 값을 바로 방출해줄 수 있는 BehaviorSubject를 사용함
  <br>
    
     ```swift
     let viewDidLoadTrigger = BehaviorSubject<Void>(value: ())
     let input = AccomodationViewModel.Input(networkTrigger: viewDidLoadTrigger)
     ```
    
    







