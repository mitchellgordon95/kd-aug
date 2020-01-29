  if [[ $use_cpu == "yes" ]]; then
    device="--use-cpu"
  else
    visible=(${CUDA_VISIBLE_DEVICES//,/ })
    # If expr returns 0, bash quits when we're using set -e
    maxid=$(expr "${#visible[@]}" - 1) || true
    visible_mapping=$(seq -s ' ' 0 $maxid)
    device="--device-ids $visible_mapping"
  fi

  python -m sockeye.train \
    $device \
    --encoder=transformer \
    --decoder=transformer \
    --transformer-attention-heads=8 \
    --optimizer=adam \
    --initial-learning-rate=0.0002 \
    --learning-rate-reduce-num-not-improved=8 \
    --learning-rate-reduce-factor=0.9 \
    --learning-rate-scheduler-type=plateau-reduce \
    --learning-rate-decay-optimizer-states-reset=best \
    --learning-rate-decay-param-reset \
    --max-num-checkpoint-not-improved 10 \
    --batch-type=word \
    --batch-size=4096 \
    --checkpoint-frequency=5000 \
    --decode-and-evaluate=-1 \
    --decode-and-evaluate-use-cpu \
    --disable-device-locking \
    --keep-last-params=10 \
    --max-num-epochs=100 \
    --max-updates=300000 \
    "$@"
    # These are default
    # --transformer-positional-embedding-type=learned \
    # --transformer-preprocess=n \
    # --transformer-postprocess=dr \
    # --transformer-dropout-attention=0.1 \
    # --transformer-dropout-act=0.1 \
    # --transformer-dropout-prepost=0.1 \
    # --weight-init=xavier \
    # --weight-init-scale=3.0 \
    # --weight-init-xavier-factor-type=avg \
    # --optimized-metric=perplexity \
    # --label-smoothing=0.1 \
    # --gradient-clipping-threshold=1 \
