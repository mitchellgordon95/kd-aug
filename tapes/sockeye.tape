func prepare_data : sockeye
    < train_src_in
    < train_trg_in
    < src_vocab
    < trg_vocab
    > data
    :: pyenv
    :: train_max_sent_length
    :: seed {

  python3 -m sockeye.prepare_data \
      --source $train_src_in \
      --target $train_trg_in \
      --source-vocab $src_vocab \
      --target-vocab $trg_vocab \
      --word-min-count 2:2 \
      --bucket-width 10 \
      --max-seq-len $train_max_sent_length \
      --num-samples-per-shard 10000000 \
      --seed $seed \
      --output data
}

func train : sockeye
    < prepared_data
    < dev_src
    < dev_trg
    < model_init
    > model
    :: pyenv
    :: num_layers
    :: model_size
    :: embed_size
    :: FF_size
    :: use_cpu {

  if [[ $model_init == "/dev/null" ]]; then
    params=""
  else
    params="--params $model_init/params.best"
  fi

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
    -o $model \
    $params \
    $device \
    --prepared-data $prepared_data \
    --validation-source $dev_src \
    --validation-target $dev_trg \
    --encoder=transformer \
    --decoder=transformer \
    --num-layers=$num_layers \
    --transformer-model-size=$model_size \
    --transformer-attention-heads=8 \
    --transformer-feed-forward-num-hidden=$FF_size \
    --num-embed=$embed_size \
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
}


# the target input here is used to compute naïve acc and ppl,
# that's why we need post-bpe target input
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
    --batch-size 10 \
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