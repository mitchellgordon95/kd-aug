task train_student : sockeye : scripts
    < train_src=$out_src@maybe_concat
    < train_trg=$out_trg@maybe_concat
    < dev_src=$DEV_SRC@bpe_data
    < dev_trg=$DEV_TRG@bpe_data
    > model
    :: dropout=(StudentDropout: 0.1 0 0.2)
    :: smoothing=(StudentSmoothing: 0.1 0 0.2)
    :: student_size=@
    :: pyenv=@ use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@ {

    $scripts/train_transformer.sh -o $model \
    --source $train_src \
    --target $train_trg \
    --validation-source $dev_src \
    --validation-target $dev_trg \
    --transformer-dropout-attention=$dropout \
    --transformer-dropout-act=$dropout \
    --transformer-dropout-prepost=$dropout \
    --label-smoothing=$smoothing \
    $($scripts/size_params.sh $student_size)
}

task student_decode_dev calls decode 
    < in=$DEV_SRC@bpe_data
    < model=$model@train_student
    > out out_log out_scores
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task student_bleu_dev calls multi_bleu
     < in=$out@student_decode_dev
     < ref=$DEV_TRG@bpe_data
      > bleu