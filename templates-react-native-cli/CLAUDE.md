# CLAUDE.md — React Native CLI 프로젝트

> Claude가 매 세션 시작 시 자동으로 읽습니다. 200줄 이내 유지.
> 상세 문서는 링크로 연결하고, 긴 내용을 여기에 복붙하지 마세요.

## 프로젝트 개요
- **이름**: [앱 이름]
- **한 줄 설명**: [무엇을 하는 앱인지]
- **React Native**: 0.74.x (New Architecture: [on/off])
- **언어**: TypeScript (strict)
- **상태 관리**: [Zustand / Redux Toolkit / Jotai 중 택1]
- **네비게이션**: React Navigation v6
- **테스트**: Jest + React Native Testing Library (+ Detox for E2E)
- **배포**: Fastlane + App Store Connect / Google Play Console
- **지원 OS**: iOS 14+, Android API 24+

## 필수 명령어 (Claude가 자주 사용)

### 개발 서버
```bash
# Metro 시작 (캐시 초기화 포함)
npm start -- --reset-cache

# iOS 실행 (시뮬레이터)
npm run ios
npm run ios -- --simulator="iPhone 15 Pro"
npm run ios -- --device         # 실기기

# Android 실행 (에뮬레이터 또는 연결된 기기)
npm run android
adb devices                     # 기기 확인
```

### 네이티브 의존성
```bash
# iOS 의존성 설치 (package.json 변경 후 반드시)
cd ios && bundle install && bundle exec pod install && cd ..

# 혹은
npx pod-install

# Android Gradle clean (빌드 에러 시)
cd android && ./gradlew clean && cd ..
```

### 빌드
```bash
# iOS release
cd ios && xcodebuild -workspace MyApp.xcworkspace -scheme MyApp -configuration Release

# Android release APK
cd android && ./gradlew assembleRelease
# Android bundle (Play Store 업로드용)
cd android && ./gradlew bundleRelease
```

### 품질 게이트 (PR 전 반드시 통과)
```bash
npm run typecheck              # tsc --noEmit
npm run lint                   # eslint + prettier check
npm run lint -- --fix
npm run test                   # Jest 단위/통합
npm run test -- --coverage
npm run test:e2e:ios           # Detox iOS (선택)
```

### 캐시 문제 해결 (정석 순서)
```bash
# 1. Metro 캐시
npm start -- --reset-cache
# 2. Watchman
watchman watch-del-all
# 3. node_modules 재설치
rm -rf node_modules && npm ci
# 4. iOS Pods 재설치
cd ios && rm -rf Pods Podfile.lock && bundle exec pod install && cd ..
# 5. Android Gradle clean
cd android && ./gradlew clean && cd ..
# 6. 시뮬레이터 리셋 (최후 수단)
xcrun simctl erase all
```

## 코드 스타일
- TypeScript strict 모드. `any` 금지 (불가피하면 `unknown` + 타입 가드).
- 함수형 컴포넌트 + Hooks만. 클래스 컴포넌트 금지.
- 파일명: 컴포넌트 `PascalCase.tsx`, 훅 `useCamelCase.ts`, 그 외 `kebab-case.ts`.
- import 순서: 외부 → `@/*` 절대경로 → 상대경로 (eslint-plugin-import로 자동 정렬).
- 스타일: `StyleSheet.create` 만 사용. 인라인 스타일 금지 (조건부 제외).
- 플랫폼 분기: `Platform.OS` 사용, 파일 분리가 낫다면 `.ios.tsx` / `.android.tsx`.
- 절대 경로: `@/components`, `@/hooks`, `@/screens` (babel-plugin-module-resolver 설정됨).

## 아키텍처 패턴
- **디렉토리**: `src/` 아래 feature-first. 공통은 `src/shared/`.
- **네비게이션**: Stack/Tab/Drawer는 `src/navigation/` 에만. 화면 안에서 라우터 정의 금지.
- **API**: TanStack Query + axios. 직접 fetch 금지. `src/api/` 에 클라이언트, `src/hooks/queries/` 에 훅.
- **폼**: React Hook Form + Zod.
- **비동기 스토리지**: MMKV (AsyncStorage보다 빠름). 민감 데이터는 `react-native-keychain`.
- **이미지**: `FastImage` (원격), `react-native-svg` (벡터).
- **애니메이션**: Reanimated v3. 단순한 건 `Animated` 금지하고 Reanimated로 통일.
- **i18n**: `i18next` + `react-i18next`. 키 이름은 `screen.section.key` 패턴.

## 디렉토리 구조
```
src/
├── api/              # axios 클라이언트, 인터셉터
├── components/       # 재사용 UI (Button, Input 등)
├── hooks/
│   ├── queries/      # TanStack Query 훅
│   └── ...
├── navigation/       # Stack/Tab 정의, 타입
├── screens/          # 화면별 폴더 (각자 components/ 포함 가능)
├── stores/           # Zustand 스토어
├── schemas/          # Zod
├── shared/           # 공용 유틸, 상수, 타입
└── theme/            # 색상, 타이포, 스페이싱
```

## 절대 금지 사항 (Guardrails)
- `.env*`, `google-services.json`, `GoogleService-Info.plist` 커밋 금지.
- 키스토어(`*.keystore`, `*.jks`), 프로비저닝 프로파일, 푸시 인증서 커밋 금지.
- `main` 직접 push 금지. `git push --force` 금지.
- `console.log` 배포 빌드에 남기지 말 것. `__DEV__` 가드 또는 `reactotron` 사용.
- Metro `resolver.blockList` 우회 금지.
- iOS `Info.plist` / Android `AndroidManifest.xml` 수정 시 반드시 이유를 PR 설명에 기록.
- 네이티브 모듈 추가(`react-native link` 류) 후 반드시 iOS/Android 양쪽 빌드 확인.

## 작업 흐름 (반드시 이 순서)
1. **탐색**: 관련 화면·훅·API를 먼저 읽는다. 코드 작성 금지.
2. **계획**: 변경 파일, iOS/Android 차이, 마이그레이션 필요 여부를 요약.
3. **승인 대기**: 사용자 확인 후 진행.
4. **구현**: 작은 단위 커밋. 네이티브 설정 변경은 별도 커밋.
5. **검증**: `typecheck → lint → test → iOS 실행 → Android 실행` 순으로 통과 확인.

## 플랫폼 체크리스트 (기능 추가 시)
- □ iOS 시뮬레이터에서 동작
- □ Android 에뮬레이터에서 동작
- □ 다크 모드 처리 (`useColorScheme`)
- □ 가로/세로 회전 또는 고정 명시
- □ 키보드 처리 (`KeyboardAvoidingView`, `keyboardShouldPersistTaps`)
- □ Safe Area (`react-native-safe-area-context`)
- □ 접근성 (accessibilityLabel, accessibilityRole)
- □ 느린 네트워크/오프라인 시나리오

## 컨텍스트 관리
- 컨텍스트 60% 넘기 전 진행 상황을 `progress.md`에 저장 후 `/clear`.
- 대용량 탐색(예: 화면 전체 리팩토링 영향도)은 서브에이전트에 위임.
- 네이티브 로그(`xcrun simctl spawn booted log stream`, `adb logcat`)는 항상 `| grep` 으로 필터해서 읽게 한다.

## 참고 문서 (필요할 때만)
- [아키텍처 상세](./docs/ARCHITECTURE.md)
- [네비게이션 설계](./docs/NAVIGATION.md)
- [빌드/배포 가이드](./docs/RELEASE.md)
- [네이티브 모듈 추가 절차](./docs/NATIVE_MODULES.md)
