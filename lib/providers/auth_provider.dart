import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String userName;
  final String userRole;
  final String avatarUrl;

  AuthState({
    required this.isAuthenticated,
    required this.userName,
    required this.userRole,
    required this.avatarUrl,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userName,
    String? userRole,
    String? avatarUrl,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier()
      : super(
          AuthState(
            isAuthenticated: true, // Default logged in for smooth demo experience
            userName: 'Nasir U.',
            userRole: 'Super Admin',
            avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
          ),
        );

  void login(String email, String password) {
    state = state.copyWith(isAuthenticated: true);
  }

  void logout() {
    state = state.copyWith(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
