import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(String email, String password, bool isLogin, String? username)
  onSubmit;
  final bool isLoading;

  const AuthForm({super.key, required this.onSubmit, this.isLoading = false});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Giriş/Kayıt toggle
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              setState(() {
                                _isLogin = true;
                              });
                            },
                      style: TextButton.styleFrom(
                        backgroundColor: _isLogin
                            ? const Color(0xFF667eea)
                            : Colors.transparent,
                        foregroundColor: _isLogin ? Colors.white : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Giriş Yap'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              setState(() {
                                _isLogin = false;
                              });
                            },
                      style: TextButton.styleFrom(
                        backgroundColor: !_isLogin
                            ? const Color(0xFF667eea)
                            : Colors.transparent,
                        foregroundColor: !_isLogin ? Colors.white : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Kayıt Ol'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Username field (sadece kayıt için)
              if (!_isLogin) ...[
                TextFormField(
                  controller: _usernameController,
                  enabled: !widget.isLoading,
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (!_isLogin && (value?.isEmpty ?? true)) {
                      return 'Kullanıcı adı gerekli';
                    }
                    if (!_isLogin && (value?.length ?? 0) < 3) {
                      return 'Kullanıcı adı en az 3 karakter olmalı';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Email field
              TextFormField(
                controller: _emailController,
                enabled: !widget.isLoading,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'E-mail gerekli';
                  if (!value!.contains('@')) return 'Geçerli e-mail giriniz';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                enabled: !widget.isLoading,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Şifre gerekli';
                  if (value!.length < 6) return 'Şifre en az 6 karakter olmalı';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!widget.isLoading) {
                        widget.onSubmit(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _isLogin, // isLogin parametresi
                          _isLogin
                              ? null
                              : _usernameController.text
                                    .trim(), // displayName parametresi
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isLogin ? 'Giriş Yap' : 'Kayıt Ol',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
