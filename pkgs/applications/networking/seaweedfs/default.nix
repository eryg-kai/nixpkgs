{ lib
, fetchFromGitHub
, buildGoModule
, testers
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "3.41";

  src = fetchFromGitHub {
    owner = "seaweedfs";
    repo = "seaweedfs";
    rev = version;
    hash = "sha256-sNeuIcRJ249F9m7NBi5Vh4HMhWwDpNHAZsit1auVI5U=";
  };

  vendorHash = "sha256-ZtHgZ0Mur102H2EvifsK3HYUQaI1dFMh/6eiJO09HBc=";

  subPackages = [ "weed" ];

  ldflags = [
    "-w"
    "-s"
    "-X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=N/A"
  ];

  tags = [
    "elastic"
    "gocdk"
    "sqlite"
    "ydb"
    "tikv"
  ];

  preBuild = ''
    export GODEBUG=http2client=0
  '';

  # There are no tests.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = seaweedfs;
    command = "weed version";
  };

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = with maintainers; [ azahi cmacrae wozeparrot ];
    mainProgram = "weed";
    license = licenses.asl20;
  };
}
