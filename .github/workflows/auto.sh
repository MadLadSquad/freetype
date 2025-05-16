#!/bin/bash
cd ../../
ahead=$(git rev-list --count origin/${{ env.BRANCH }}..upstream/${{ env.UPSTREAM_BRANCH }})
echo "${ahead}"
echo "::set-output name=ahead::${ahead}"
