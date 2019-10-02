# RacingImageViewer
---
> 특정 페이지(https://www.gettyimagesgallery.com/collection/auto-racing/)를 http로 받아와 갤러리에 포함된 이미지를 list로 표현하는 앱

## Index

* 기능
    * 지정된 웹페이지를 읽고, 조건에 맞는 이미지를 스크롤하여 테이블뷰를 통해서 보여준다.
    * 사이트의 HTML소스 전체를 읽어와서, 파싱해서 필요한 데이터를 추출한다.
    * 이렇게 불러온 이미지를 캐싱하여 다음에 필요할 때 추가로 띄워준다.
    * Prefetching을 지원하여 부드러운 스크롤을 지원한다.(지나치게 빠르게 스크롤 할 경우는 깨질 수 있다.)
* 앱 구조 
* 설계 고려 사항
