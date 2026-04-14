---
description: 현재 브랜치의 React Native 변경사항을 시니어 관점에서 리뷰한다
argument-hint: [비교할 브랜치, 기본값 main]
---

# 코드 리뷰 (React Native)

비교 대상: **${ARGUMENTS:-main}**

## 진행 방식
```bash
git diff ${ARGUMENTS:-main}...HEAD
git log ${ARGUMENTS:-main}...HEAD --oneline
```

## 체크리스트 (우선순위 순)

1. **정확성** — 버그, 엣지 케이스 누락, race condition, off-by-one
2. **플랫폼 균형** — iOS/Android 어느 한쪽만 처리된 부분 없는가? Platform 분기 검증
3. **네이티브 영향** — Info.plist / AndroidManifest / Podfile / build.gradle 변경 시 이유 명확한가, OTA 가능성에 영향
4. **보안** — 토큰 저장 위치(MMKV vs Keychain/Keystore), deeplink 검증, WebView `javaScriptEnabled` 필요성
5. **타입 안전성** — `any` 사용, 널 체크 누락, 네비게이션 파라미터 타입
6. **성능**
   - 불필요한 리렌더 (`React.memo`, `useCallback`, `useMemo`)
   - `FlatList`/`SectionList` 가상화: `keyExtractor`, `getItemLayout`, `removeClippedSubviews`
   - 이미지 크기와 캐시 (`FastImage`, resize, URI 쿼리)
   - Reanimated 워크렛 JS 브릿지 왕복
   - 번들 크기(불필요한 폴리필, 미사용 패키지)
7. **접근성** — `accessibilityLabel`, `accessibilityRole`, `accessibilityState`, 최소 터치 영역 44dp
8. **테스트 커버리지** — 단위(로직), RNTL(컴포넌트), Detox(중요 플로우). happy path 외 실패 경로.
9. **코드 스타일** — CLAUDE.md 규칙, 인라인 스타일, StyleSheet 사용, 절대경로
10. **문서** — 네이티브 설정 변경은 README 또는 PR 설명에 반드시 기록

## 출력 형식

```
## 종합 판단
<머지 가능 / 수정 필요 / 재설계 필요>

## 플랫폼 빌드 영향
- iOS: <영향 없음 / Pods 재설치 필요 / OTA 불가 등>
- Android: <영향 없음 / Gradle 변경 / 최소 SDK 영향 등>

## 🔴 Blocking Issues
- [파일:줄] 문제와 제안

## 🟡 Suggestions
- ...

## 🟢 Nits
- ...

## 잘한 점
- ...
```

**중요**: 아첨 금지. 문제 없으면 "문제 없음" 한 줄로.
