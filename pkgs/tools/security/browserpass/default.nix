# This file was generated by https://github.com/kamilchm/go2nix v1.2.0
{ stdenv, buildGoPackage, fetchFromGitHub, gnupg }:

buildGoPackage rec {
  name = "browserpass-${version}";
  version = "2.0.17";

  goPackagePath = "github.com/dannyvankooten/browserpass";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    repo = "browserpass";
    owner = "dannyvankooten";
    rev = version;
    sha256 = "1gbhpx75bcacj6z5p4av0011c4chhzqcjjs2bvmfxpi7826hn9kn";
  };

  postPatch = ''
    substituteInPlace browserpass.go                                           \
      --replace /usr/local/bin/gpg ${gnupg}/bin/gpg
  '';

  postInstall = ''
      host_file="$bin/bin/browserpass"
      mkdir -p "$bin/etc"

      sed -e "s!%%replace%%!$host_file!" go/src/${goPackagePath}/chrome/host.json > chrome-host.json
      sed -e "s!%%replace%%!$host_file!" go/src/${goPackagePath}/firefox/host.json > firefox-host.json

      install chrome-host.json $bin/etc/
      install -D firefox-host.json $bin/lib/mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json
      install go/src/${goPackagePath}/chrome/policy.json $bin/etc/chrome-policy.json
  '';

  meta = with stdenv.lib; {
    description = "A Chrome & Firefox extension for zx2c4's pass";
    homepage = https://github.com/dannyvankooten/browserpass;
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin ++ openbsd;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
