---
description: React Native 이슈를 재현→가설→검증 흐름으로 디버깅한다
argument-hint: <에러 메시지 또는 증상>
---

# 체계적 디버깅 (React Native)

증상: **$ARGUMENTS**

**중요**: 추측 금지. 증거를 수집해 원인을 확정한 뒤 수정.

## 진행 순서

### 1. 재현 (Reproduce)
- 어느 플랫폼? iOS / Android / 둘 다?
- Debug 빌드 / Release 빌드?
- Metro 캐시 초기화 후에도 재현되는가? (`npm start -- --reset-cache`)
- 최소 재현 스니펫 또는 실패하는 테스트를 먼저 작성.

### 2. 관찰 (Observe)

**JS 에러:**
- 전체 스택 트레이스 확인. `npx react-native log-ios`, `npx react-native log-android` 로 실시간 로그.
- Release 빌드의 난독화 스택은 소스맵 없이 분석하지 말 것.

**네이티브 크래시:**
```bash
# iOS 시뮬레이터 로그
xcrun simctl spawn booted log stream --predicate 'process == "MyApp"' --level=debug | tail -200

# Android logcat (앱 PID만)
adb logcat --pid=$(adb shell pidof -s com.myapp) *:E ReactNativeJS:V ReactNative:V
```

**빌드 실패:**
- iOS: Xcode Issue Navigator 메시지 전체 복사
- Android: `cd android && ./gradlew assembleDebug --stacktrace --info` 재실행

### 3. 가설 — `think hard`
```
가설 A: Metro 캐시 문제 — 확률 30%
  검증: watchman watch-del-all && npm start -- --reset-cache
가설 B: iOS Pods 버전 충돌 — 확률 40%
  검증: rm -rf ios/Pods ios/Podfile.lock && npx pod-install
가설 C: 네이티브 모듈 autolinking 누락 — 확률 20%
  검증: npx react-native config | jq '.dependencies'
```

### 4. RN 특화 '의심 3대장'
- JS/네이티브 버전 미스매치: 패키지 업데이트 후 네이티브 rebuild 안 함
- 플랫폼 분기 누락: `Platform.OS` 처리가 한쪽만 된 코드
- Reanimated worklet: `'worklet'` 디렉티브 누락, `runOnJS` 미사용
- FlatList 성능/렌더: `keyExtractor` 누락, 부모 리렌더
- Metro resolver: `babel-plugin-module-resolver` 경로 변경 후 reset-cache 안 함

### 5. 수정 (Fix)
- 회귀 테스트 먼저 (Jest + React Native Testing Library).
- 네이티브 변경이면 iOS/Android **양쪽** 빌드 통과 확인.
- 같은 버그가 복붙된 다른 위치가 있는지 grep.

### 6. 보고
```
## 원인
<정확히 무엇이 왜 — 플랫폼 명시>

## 수정
<파일:줄, 변경 요약>

## 재발 방지
<테스트 / 린트 규칙 / CI 체크>

## OTA 가능 여부
<JS only → 가능 / 네이티브 변경 있음 → 스토어 배포 필요>
```
