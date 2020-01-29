task train_teacher : sockeye : scripts
    < train_src=$TRAIN_SRC@bpe_data
    < train_trg=$TRAIN_TRG@bpe_data
    < dev_src=$DEV_SRC@bpe_data
    < dev_trg=$DEV_TRG@bpe_data
    > model
    :: teacher_size=@
    :: pyenv=@ use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@ {

    $scripts/train_transformer.sh -o $model \
    --source $train_src \
    --target $train_trg \
    --validation-source $dev_src \
    --validation-target $dev_trg \
    $($scripts/size_params.sh $teacher_size)
}

task teacher_decode_dev calls decode 
    < in=$DEV_SRC@bpe_data
    < model=$model@train_teacher
    > out out_log out_scores
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task teacher_bleu_dev calls multi_bleu
     < in=$out@teacher_decode_dev
     < ref=$DEV_TRG@bpe_data
      > bleu