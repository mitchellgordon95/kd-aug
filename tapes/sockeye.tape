func decode : sockeye
    < in
    < model
    > out
    > out_log
    > out_scores
    :: test_beam_size
    :: use_cpu
    :: pyenv {

  if [[ $use_cpu == "yes" ]]; then
    device="--use-cpu"
  else
    visible=(${CUDA_VISIBLE_DEVICES//,/ })
    # If expr returns 0, bash quits when we're using set -e
    maxid=$(expr "${#visible[@]}" - 1) || true
    visible_mapping=$(seq -s ' ' 0 $maxid)
    device="--device-ids $visible_mapping"
  fi

  python3 -m sockeye.translate \
    -m $model \
    $device \
    -i $in \
    -o out.all \
    --output-type translation_with_score \
    --beam-size 12 \
    --batch-size 8 \
    --max-input-len 300 \
    --disable-device-locking \

    cat out.all | cut -f 1 > $out_scores
    cat out.all | cut -f 2 > $out
    mv out.all.log $out_log
}


func score : sockeye
    < src
    < trg
    < model
    > scores
    > avgscore
    :: use_cpu
    :: pyenv {

  if [[ $use_cpu == "yes" ]]; then
    device="--use-cpu"
  else
    visible=(${CUDA_VISIBLE_DEVICES//,/ })
    # If expr returns 0, bash quits when we're using set -e
    maxid=$(expr "${#visible[@]}" - 1) || true
    visible_mapping=$(seq -s ' ' 0 $maxid)
    device="--device-ids $visible_mapping"
  fi

  python3 -m sockeye.score \
    -m $model \
    $device \
    --source $src \
    --target $trg \
    --batch-size 100 \
    --disable-device-locking \
    > scores

  cat scores | awk '{sum+=$1;count++} END {print sum/count}' > avgscore
}