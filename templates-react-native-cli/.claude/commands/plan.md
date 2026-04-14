---
description: React Native 기능 구현 전에 탐색→계획→승인 흐름을 강제한다
argument-hint: <기능 또는 티켓 설명>
---

# 계획 모드 (React Native)

**$ARGUMENTS** 에 대한 구현 계획을 수립합니다.

## 반드시 지킬 것
- **아직 코드를 작성하지 마세요.** 읽기와 분석만.
- iOS와 Android 양쪽 영향을 반드시 고려.

## 진행 순서

### 1. 탐색 (Explore)
`ultrathink` 로 분석. 다음을 확인:
- 영향받는 화면(`src/screens/`), 네비게이션 스택, 공용 컴포넌트
- 관련 API 훅(`src/hooks/queries/`), 스토어, 스키마
- 유사 기능이 이미 있는가? (있다면 그 패턴을 따른다)
- 네이티브 설정 변경이 필요한가? (Info.plist, AndroidManifest, Podfile, build.gradle)
- 새 패키지 추가가 필요한가? (autolinking 여부, iOS/Android 설치 스텝)

### 2. 계획 (Plan)
아래 형식으로 보고하세요.

```
## 목표
<한 문장>

## 영향 파일
- src/screens/... (수정)
- src/components/... (신규)
- ios/MyApp/Info.plist (권한 추가 필요 여부)
- android/app/src/main/AndroidManifest.xml (권한 추가 필요 여부)

## 네이티브 변경
- 신규 패키지: <있음/없음, 있다면 이름과 설치 스텝>
- iOS Pods 재설치 필요: <Y/N>
- Android Gradle 설정 변경: <Y/N>
- 최소 OS 버전 영향: <있음/없음>

## 변경 요약
1. ...
2. ...

## 테스트 전략
- 단위(Jest): ...
- 컴포넌트(RNTL): ...
- E2E(Detox): <필요 시>
- 수동 체크: iOS / Android / 다크모드 / 오프라인

## 리스크 / 트레이드오프
- 성능: 리렌더, 이미지 크기, 리스트 가상화 여부
- 접근성: accessibilityLabel 필요한가
- OTA 업데이트 가능 여부 (네이티브 변경 있으면 OTA 불가)

## 예상 커밋 개수
N 개 (JS / 네이티브 / 테스트 분리)
```

### 3. 승인 대기
계획 제시 후 **반드시 사용자 승인을 기다립니다.**
