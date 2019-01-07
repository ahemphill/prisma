require_relative './command'

class NativeImageCommands
  def self.build(context, target)

  end
end

# lambda
# #!/bin/bash

# set -e
# export BUILDKITE_ARTIFACT_UPLOAD_DESTINATION="s3://$ARTIFACT_BUCKET/lambda/$BUILDKITE_JOB_ID"

# # Use current dir as working dir base
# cd "$(dirname "$0")"

# BK_ROOT=$(dirname "$(pwd)")
# SERVER_ROOT=$(dirname "$BK_ROOT")

# docker run -e "BRANCH=$BUILDKITE_BRANCH" -e "COMMIT_SHA=$BUILDKITE_COMMIT" -e "CLUSTER_VERSION=$DOCKER_TAG" \
#   -w /root/build \
#   -v ${SERVER_ROOT}:/root/build \
#   -v ~/.ivy2:/root/.ivy2 \
#   -v ~/.coursier:/root/.coursier \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   prismagraphql/build-image:lambda sbt "project prisma-native" prisma-native-image:packageBin
# #  -v /.cargo/:~/root/.cargo \

# buildkite-agent artifact upload ${SERVER_ROOT}/images/prisma-native/target/prisma-native-image/prisma-native


# --------------

# native image
# #!/bin/bash

# set -e

# # Use current dir as working dir base
# cd "$(dirname "$0")"

# BK_ROOT=$(dirname "$(pwd)")
# SERVER_ROOT=$(dirname "$BK_ROOT")

# # todo: correct docker build
# docker run -e "BRANCH=$BUILDKITE_BRANCH" -e "COMMIT_SHA=$BUILDKITE_COMMIT" -e "CLUSTER_VERSION=testbuild" \
#   -w /root/build \
#   -v ${SERVER_ROOT}:/root/build \
#   -v ~/.ivy2:/root/.ivy2 \
#   -v ~/.coursier:/root/.coursier \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   prismagraphql/build-image:debian sbt "project prisma-native" prisma-native-image:packageBin
# #  -v /.cargo/:~/root/.cargo \

# if [ "$BUILDKITE_BRANCH" = "master" ]
# then
#     # Upload as stable and under commit hash

#     cd ${SERVER_ROOT}/images/prisma-native/target/prisma-native-image/
#     BUILDKITE_ARTIFACT_UPLOAD_DESTINATION="s3://$ARTIFACT_BUCKET/linux/stable/" buildkite-agent artifact upload prisma-native
#     buildkite-agent artifact upload ${SERVER_ROOT}/images/prisma-native/target/prisma-native-image/prisma-native
#     cd -

#     ${BK_ROOT}/scripts/docker-native/build.sh latest
# elif [ "$BUILDKITE_BRANCH" = "beta" ]
# then
#     ${BK_ROOT}/scripts/docker-native/build.sh beta
# elif [ "$BUILDKITE_BRANCH" = "alpha" ]
# then
#     ${BK_ROOT}/scripts/docker-native/build.sh alpha
# fi

# ## Todo This is for testing only before the merges. Remove in final cleanup pass.
# ${BK_ROOT}/scripts/docker-native/build.sh latest


# ## todo: Upload to github release on tag