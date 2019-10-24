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
    :: train_batch_type
    :: train_batch_size
    :: train_max_checkpoints_not_improved
    :: train_checkpoint_freq
    :: train_num_decode_and_eval
    :: num_layers
    :: model_size
    :: embed_size
    :: FF_size
    :: use_cpu {

  if [[ $model_init == "/dev/null" ]]; then
    params=""
  else
    params="--params $model_init"
  fi

  if [[ $use_cpu == "yes" ]]; then
    device="--use-cpu"
  else
    device="--device-ids $(free-gpu)"
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
    --transformer-positional-embedding-type=fixed \
    --transformer-preprocess=n \
    --transformer-postprocess=dr \
    --transformer-dropout-attention=0.1 \
    --transformer-dropout-act=0.1 \
    --transformer-dropout-prepost=0.1 \
    --weight-tying \
    --weight-tying-type=src_trg_softmax \
    --weight-init=xavier \
    --weight-init-scale=3.0 \
    --weight-init-xavier-factor-type=avg \
    --num-embed=$embed_size \
    --optimizer=adam \
    --optimized-metric=perplexity \
    --label-smoothing=0.1 \
    --gradient-clipping-threshold=-1 \
    --initial-learning-rate=0.0002 \
    --learning-rate-reduce-num-not-improved=8 \
    --learning-rate-reduce-factor=0.9 \
    --learning-rate-scheduler-type=plateau-reduce \
    --learning-rate-decay-optimizer-states-reset=best \
    --learning-rate-decay-param-reset \
    --max-num-checkpoint-not-improved $train_max_checkpoints_not_improved \
    --batch-type=$train_batch_type \
    --batch-size=$train_batch_size \
    --checkpoint-frequency=$train_checkpoint_freq \
    --decode-and-evaluate=$train_num_decode_and_eval \
    --keep-last-params=60 \
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
    device="--device-ids $(free-gpu)"
  fi

  python3 -m sockeye.translate \
    -m $model \
    $device \
    -i $in \
    -o out.all \
    --output-type translation_with_score \
    --beam-size $test_beam_size \
    --batch-size 1 \
    --max-input-len 300 \

    cat out.all | unpaste $scores $out
    mv out.all.log $log
}
