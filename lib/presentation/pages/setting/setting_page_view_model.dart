// // 설정 페이지 뷰 모델

// // lib/setting/setting_page_view_model.dart
// import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_princess/domain/repository/setting_repository.dart';

// // 상태 클래스
// class SettingState {
//   final File? selectedFile;
//   final String? selectedUrl;
//   final String? currentProfileUrl;
//   final bool isUploading;

//   SettingState({
//     this.selectedFile,
//     this.selectedUrl,
//     this.currentProfileUrl,
//     this.isUploading = false,
//   });

//   SettingState copyWith({
//     File? selectedFile,
//     String? selectedUrl,
//     String? currentProfileUrl,
//     bool? isUploading,
//   }) {
//     return SettingState(
//       selectedFile: selectedFile ?? this.selectedFile,
//       selectedUrl: selectedUrl ?? this.selectedUrl,
//       currentProfileUrl: currentProfileUrl ?? this.currentProfileUrl,
//       isUploading: isUploading ?? this.isUploading,
//     );
//   }
// }

// // ViewModel
// class SettingViewModel extends StateNotifier<SettingState> {
//   final SettingRepository repository;

//   SettingViewModel(this.repository) : super(SettingState()) {
//     loadCurrentProfile();
//   }

//   // 현재 프로필 불러오기
//   Future<void> loadCurrentProfile() async {
//     final url = await repository.getCurrentProfileUrl();
//     if (url != null) {
//       state = state.copyWith(currentProfileUrl: url);
//     }
//   }

//   // 파일 선택
//   void selectFile(File file) {
//     state = state.copyWith(selectedFile: file, selectedUrl: null);
//   }

//   // 기존 URL 선택
//   void selectUrl(String url) {
//     state = state.copyWith(selectedFile: null, selectedUrl: url);
//   }

//   // Storage 목록 가져오기
//   Future<List<String>> getProfileImages() async {
//     return repository.listProfileImages();
//   }

//   // 저장
//   Future<void> saveProfile() async {
//     state = state.copyWith(isUploading: true);
//     String? newUrl = state.selectedUrl;

//     try {
//       if (state.selectedFile != null) {
//         newUrl = await repository.uploadProfile(state.selectedFile!);
//       }

//       if (state.currentProfileUrl != null &&
//           state.currentProfileUrl != newUrl) {
//         await repository.deleteProfileUrl(state.currentProfileUrl!);
//       }

//       if (newUrl != null) {
//         await repository.updateProfileUrl(newUrl);
//       }

//       state = state.copyWith(
//         currentProfileUrl: newUrl,
//         selectedFile: null,
//         selectedUrl: null,
//         isUploading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(isUploading: false);
//     }
//   }
// }

// // Provider
// final settingViewModelProvider =
//     StateNotifierProvider<SettingViewModel, SettingState>(
//       (ref) => SettingViewModel(SettingRepository(userId: 'madongsuk')),
//     );
