cd ..

docker build -t swift-lambda .

docker run \
     --rm \
     --volume "$(pwd)/:/src" \
     --workdir "/src/" \
     swift-lambda \
     scripts/package.sh GlucoseApp Backend 
