#!/bin/sh
echo "build and up percona"
docker-compose build percona phpfpm
docker-compose up -d percona

sleep 5

echo "setup magento"

docker-compose -f docker-compose.yml \
 			run --rm phpfpm /bin/sh -c "/src/setup-mage.sh"  | tee SetupTest

    if grep -q "fail" SetupTest
    then
      echo "Setup Test Failed:"
      cat ./SetupTest | grep fail | awk '{print $2, $3}'
    else
      echo "Setup Test passed"
    fi
