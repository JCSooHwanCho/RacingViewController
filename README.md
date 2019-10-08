# RacingImageViewer
---
> 특정 페이지(https://www.gettyimagesgallery.com/collection/auto-racing/)를 http로 받아와 갤러리에 포함된 이미지를 list또는 grid로 표현하는 앱

## Index
1. 기능
2. 앱 구조 

---

1. 기능
    * 지정된 URL의 웹페이지를 http 요청을 통해 읽어와서 파싱해서, 갤러리의 이미지 링크들을 추출한다.(Kanna 라이브러리 이용)
    * 추출한 이미지 링크로 다시 http 요청을 해서 이미지 데이터를 가져와 테이블 뷰를 통해 list 형태로 띄워준다.
    * 웹페이지와 이미지 데이터가 성공했다면, 결과가 캐시되어 다시 요청할 때 추가적인 네트워크 요청 없이 데이터를 사용할 수 있다.
    * TableViewDelegate를 통해서 이미지의 크기를 동적으로 계산한다.*
    * Prefetching을 적용하여 좀 더 부드러운 스크롤링을 지원한다.

2. 앱 구조
    
    ![App Structure](/Image/RacingImageViewerAppStructure.png)

