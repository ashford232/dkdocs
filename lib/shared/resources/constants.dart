class Constants {
  static const String googleLogo = "assets/icons/google-logo.png";
  static const String dkDocsLogo = "assets/icons/dk-docs-logo.png";
  static const String githubLogo = "assets/icons/github-logo.png";

  static const String appName = "Dk Docs";
  static const String clientIdAndroid =
      "965821373671-i7k8bldgouka2058spfhh9vna58jrb73.apps.googleusercontent.com";
  static const String clientIdWeb =
      "965821373671-k1m7t64e99nkn9lakrdsgplfgcqim3di.apps.googleusercontent.com";
// 



static const String port = "3001";
static const String addr = "172.18.178.118";
static const String serverVersion = "v1";

static const String host = "http://$addr:$port/api/$serverVersion";

static const String tokenHeaderValue ="x-auth-token";


static final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
}

