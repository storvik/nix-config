self: super:

{

  gopls = super.gopls.overrideAttrs (oldAttrs: rec {
    version = "0.5.0";

    src = super.fetchgit {
      rev = "gopls/v${version}";
      url = "https://go.googlesource.com/tools";
      sha256 = "150jg1qmdszfvh1x5fagawgc24xy19xjg9y1hq3drwy7lfdnahmq";
    };

    vendorSha256 = "1s3d4hnbw0mab7njck79qmgkjn87vs4ffk44zk2qdrzqjjlqq5iv";

  });

}
