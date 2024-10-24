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
### 1. 상품 이미지를 불러올 때 원본 이미지를 필요한 크기만큼만 축소하여 보여줌으로써 메모리 절약
- 상황
  - 사용자가 상품을 검색하면 관련 상품을 컬렉션뷰 형태로 보여주고 각 셀에서 Kingfisher를 이용하여 이미지를 보여줌
  
- 원인 분석
  - 네이버 쇼핑 API 응답값에서 주는 url은 원본이미지를 기반으로 보여주게 되는데 원본이미지는 크기가 매우 크므로 불러올 때 시간이 걸리고 메모리를 많이 사용

- 해결
  - Kingfisher에 있는 DownsamplingImageProcessor로 필요한 크기만큼 이미지를 축소하여 메모리 절약

  <br>

   <img width="426" alt="스크린샷 2024-10-19 오후 6 29 50" src="https://github.com/user-attachments/assets/3068fb33-2713-489a-b08a-79d002114de0">     
   <img width="417" alt="스크린샷 2024-10-19 오후 6 30 47" src="https://github.com/user-attachments/assets/e41fca70-2ff9-41fb-bfa3-edf34243f3f7">
   
    <br>

     ```swift
     func setImage(_ url: String?) {
        guard let url = url, let source = URL(string: url) else { return }
        kf.setImage(with: source, placeholder: UIImage(named: "shop-placeholder"), options: [
            .transition(.fade(1)),
            .forceTransition,
            .processor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 400))),
            .scaleFactor(UIScreen.main.scale),
            .progressiveJPEG(.init(isBlur: false, isFastestScan: true, scanInterval: 0.1)),
            .cacheOriginalImage
        ])
    }
     ```
<br>

### 2. 셀 안에 있는 버튼에 addTarget을 매번 선언하는 문제
- 상황
  - cell안에 버튼이 있는 경우 버튼의 action을 위해서 addTarget을 cellForItemAt함수 내에서 선언해줌
 
- 원인 분석
  - 처음 한번만 선언하면 addTarget에서 설정한 action을 실행할 수 있지만 cellForItemAt에서 선언해주기 때문에 collectionView가 reload될 때 마다 매번 선언되는 문제 발생
  
- 해결 
  - delegate 패턴을 사용함
  - delegate protocol을 정의하고 버튼을 눌렀을 때의 로직을 delegate를 통해 viewController로 전달함
  - UICollectionViewCell에서 delegate protocol을 채택하여 버튼이 눌렸을 때의 로직을 구현함
    
  <br>
    
     ```swift
     protocol SearchResultCellDelegate: AnyObject {
         func goodButtonTapped(at index: Int)
     }

     extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, SearchResultCellDelegate {
        func goodButtonTapped(at index: Int) {
            print(index)
        }
     }
     ```
    
    







