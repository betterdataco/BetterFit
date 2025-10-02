class Urls {
  Urls._();

  //Supabase URLs
  static const _baseSupabaseUrl = "io.supabase.zjqzzanuafynftnuidui";
  static const loginCallbackUrl = "$_baseSupabaseUrl://login-callback/";
  static const changeEmailCallbackUrl = "$_baseSupabaseUrl://change-email/";

  // App URLs
  static const appUrl = "https://app.betterfitai.com";
  static const authCallbackUrl = "$appUrl/auth/callback";

  //Settings URLs
  static const termsService = "https://app.betterfitai.com/terms";
  static const privacyPolicy = "https://app.betterfitai.com/privacy";
  static const contactEmail = "support@betterfitai.com";

  //Author URLs
  static const medium = "https://www.medium.com/@betterfitai/";
  static const linkedin = "https://www.linkedin.com/company/betterfitai/";
  static const twitter = "https://www.twitter.com/betterfitai";
}
