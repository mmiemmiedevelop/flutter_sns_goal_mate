# 🎯 GoalMate
**개인 목표를 기록하고 다른 사용자와 소통하며 함께 달성하는 SNS**

<div align="center">
  <img src="assets/img/goal_mate_logo.png" alt="GoalMate Logo" width="200"/>
  
  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
</div>

---

##  프로젝트 소개

GoalMate는 개인의 목표를 체계적으로 관리하고, 같은 목표를 가진 사용자들과 소통하며 동기부여를 받을 수 있는 소셜 네트워킹 서비스입니다. 

###  주요 특징
-  **목표 기록 및 관리**: 개인의 목표를 체계적으로 기록하고 추적
-  **소셜 네트워킹**: 같은 목표를 가진 사용자들과 소통 및 정보 공유
-  **실시간 댓글 시스템**: 게시물에 대한 실시간 피드백 및 응원 메시지
-  **모던 UI/UX**: 직관적이고 아름다운 사용자 인터페이스
-  **실시간 동기화**: Firebase를 통한 실시간 데이터 동기화

---

## 아키텍처

### Clean Architecture 구조
프로젝트는 **Clean Architecture** 패턴을 기반으로 설계되어 유지보수성과 확장성을 높였습니다.

```
lib/
├── domain/          # 비즈니스 로직 계층
│   ├── entity/      # 핵심 비즈니스 모델
│   ├── repository/  # 데이터 접근 인터페이스
│   └── usecase/     # 비즈니스 규칙 구현
├── data/            # 데이터 계층
│   ├── data_source/ # 외부 데이터 소스 (Firebase, API)
│   ├── dto/         # 데이터 전송 객체
│   └── repository/  # Repository 구현체
├── presentation/    # 프레젠테이션 계층
│   ├── pages/       # 화면별 UI 컴포넌트
│   └── common_widget/ # 공통 위젯 및 테마
└── config/          # 설정 파일 (라우팅, API 설정)
```

### 핵심 엔티티

#### Post Entity
```dart
class Post {
  final String id;
  final String userId;
  final String userNickname;
  final String userProfileImageUrl;
  final List<String> imageUrls;
  final List<String> tags;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final List<String> likedBy;
}
```

#### User Entity
```dart
class User {
  final String uid;
  final String email;
  final String userNickname;
  final String? profileImgUrl;
}
```

---

## 핵심 기능

### 1. 사용자 인증 시스템
- **Firebase Authentication** 기반 회원가입/로그인
- 이메일 및 비밀번호 검증
- 프로필 이미지 업로드 및 닉네임 설정
- **Firebase Storage**를 활용한 이미지 저장

### 2. 게시물 관리
- 목표 달성 과정 및 결과 공유
- 다중 이미지 업로드 지원
- 해시태그를 통한 카테고리 분류
- 좋아요 및 댓글 기능

### 3. 실시간 댓글 시스템
- **Firestore**를 활용한 실시간 댓글 동기화
- 댓글 작성, 수정, 삭제 기능
- 사용자별 프로필 이미지 표시

### 4. 무한 스크롤
- 효율적인 데이터 로딩을 위한 페이지네이션
- `ListView.separated`를 활용한 최적화된 스크롤
- **RefreshIndicator**를 통한 Pull-to-Refresh 기능

### 5. 상태 관리
- **Riverpod**을 활용한 상태 관리
- MVVM 패턴을 통한 비즈니스 로직 분리
- 효율적인 위젯 리빌딩

---

## 화면 구성

### 메인 화면들

| 화면 | 설명 | 주요 기능 |
|------|------|-----------|
| **Splash** | 앱 시작 화면 | 초기 로딩, 인증 상태 확인 |
| **Login** | 로그인 화면 | Firebase Auth를 통한 로그인 |
| **SignUp** | 회원가입 화면 | 이메일/비밀번호 회원가입 |
| **SignUpNickname** | 프로필 설정 | 닉네임 설정, 프로필 이미지 업로드 |
| **Home** | 메인 피드 | 게시물 목록, 무한 스크롤 |
| **Write** | 글쓰기 화면 | 새 게시물 작성, 이미지 업로드 |
| **Comment** | 댓글 화면 | 댓글 조회/작성, 실시간 업데이트 |
| **Setting** | 설정 화면 | 사용자 설정, 계정 관리 |

### 디자인 시스템
- **GoalMateTheme**: 일관된 디자인을 위한 커스텀 테마
- **NotoSansKR**: 한글 최적화 폰트 적용
- 모던하고 직관적인 UI/UX

---

## 기술 스택

### Frontend
- **Flutter** 3.8.1+ - 크로스 플랫폼 UI 프레임워크
- **Dart** - 프로그래밍 언어
- **Riverpod** 2.6.1 - 상태 관리
- **go_router** 16.2.1 - 선언적 라우팅

### Backend & 데이터베이스
- **Firebase Core** 4.0.0 - Firebase 초기화
- **Firebase Auth** 6.0.1 - 사용자 인증
- **Cloud Firestore** 6.0.0 - NoSQL 데이터베이스
- **Firebase Storage** 13.0.0 - 파일 저장소
- **Firebase Analytics** 12.0.0 - 사용자 분석
- **Firebase Messaging** 16.0.0 - 푸시 알림

### 추가 라이브러리
- **image_picker** 1.2.0 - 갤러리/카메라 이미지 선택
- **cached_network_image** 3.4.1 - 네트워크 이미지 캐싱
- **flutter_image_compress** 2.4.0 - 이미지 압축
- **shared_preferences** 2.1.1 - 로컬 데이터 저장
- **http** 1.1.0 - HTTP 통신

---

## 고급 기능 구현

### 1. **Firebase 실시간 데이터 동기화**
```dart
// Firestore를 활용한 실시간 데이터 스트림
Stream<List<Post>> watchPosts() {
  return _firestore
    .collection('post')
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => Post.fromFirestore(doc.data(), doc.id))
        .toList());
}
```

### 2. **Go Router 기반 네비게이션**
```dart
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    // ... 추가 라우트들
  ],
);
```

### 3. **Riverpod 상태 관리**
- 각 화면별 ViewModel 패턴 적용
- 비동기 상태 관리를 위한 `AsyncNotifier` 활용
- 의존성 주입을 통한 테스트 용이성 확보

### 4. **이미지 최적화**
- 업로드 전 이미지 압축 처리
- 캐시된 네트워크 이미지로 성능 최적화
- Firebase Storage 연동으로 효율적인 이미지 관리

---

## 설치 및 실행

### 사전 요구사항
- Flutter SDK 3.8.1 이상
- Dart SDK
- Android Studio / Xcode
- Firebase 프로젝트 설정

### 설치 과정

1. **저장소 클론**
```bash
git clone [repository-url]
cd flutter_princess
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **Firebase 설정**
```bash
# Firebase CLI 설치 후
firebase login
flutterfire configure
```

4. **앱 실행**
```bash
flutter run
```

### 빌드
- **지원 플랫폼**: Android, iOS

```bash
# Android APK 빌드
flutter build apk --release

# iOS IPA 빌드 (macOS에서만)
flutter build ios --release
```

---

## 👥 기여자 공주님들

- @FEgguri
- @mmiemmiedevelop
- @hayanmini
- @So2ln
- @su-vely

---

<div align="center">
  <sub>Built with ❤️ using Flutter & Firebase</sub>
</div>
