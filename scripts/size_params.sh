
if [ $1 == "large" ]; then
    echo --num-layers=6 \
    --transformer-feed-forward-num-hidden=2048 \
    --transformer-model-size=512 \
    --num-embed=512:512
elif [ $1 == "medium" ]; then
    echo --num-layers=3 \
    --transformer-feed-forward-num-hidden=2048 \
    --transformer-model-size=512 \
    --num-embed=512:512
elif [ $1 == "small" ]; then
    echo --num-layers=3 \
    --transformer-feed-forward-num-hidden=2014 \
    --transformer-model-size=256 \
    --num-embed=256:256
elif [ $1 == "tiny" ]; then
    echo --num-layers=1 \
    --transformer-feed-forward-num-hidden=2014 \
    --transformer-model-size=256 \
    --num-embed=256:256
else
    exit 1
fi
