# Train the GD teacher
task train_gd_teacher calls train
    < prepared_data=$data@prepare_gd_data
    < dev_src="/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.dev.bpe.$SRC"
    < dev_trg="/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.dev.bpe.$TRG"
    < model_init=/dev/null # Pretty sure ducttape will freak out if we don't have a file here
    > model
    :: pyenv=@
    :: train_batch_type=@
    :: train_batch_size=@
    :: train_max_checkpoints_not_improved=@
    :: train_checkpoint_freq=@
    :: train_num_decode_and_eval=@
    :: num_layers=$teacher_layers
    :: model_size=$teacher_model_size
    :: embed_size=$teacher_embed_size
    :: FF_size=$teacher_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Adapt the GD teacher
task train_adapted_teacher calls train
    < prepared_data=$data@prepare_id_data
    < dev_src="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC"
    < dev_trg="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$TRG"
    < model_init=$model@train_gd_teacher
    > model
    :: pyenv=@
    :: train_batch_type=@
    :: train_batch_size=@
    :: train_max_checkpoints_not_improved=@
    :: train_checkpoint_freq=@
    :: train_num_decode_and_eval=@
    :: num_layers=$teacher_layers
    :: model_size=$teacher_model_size
    :: embed_size=$teacher_embed_size
    :: FF_size=$teacher_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Train an ID teacher
task train_id_baseline_teacher calls train
    < prepared_data=$data@prepare_id_data
    < dev_src="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC"
    < dev_trg="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$TRG"
    < model_init=/dev/null # Pretty sure ducttape will freak out if we don't have a file here
    > model
    :: pyenv=@
    :: train_batch_type=@
    :: train_batch_size=@
    :: train_max_checkpoints_not_improved=@
    :: train_checkpoint_freq=@
    :: train_num_decode_and_eval=@
    :: num_layers=$teacher_layers
    :: model_size=$teacher_model_size
    :: embed_size=$teacher_embed_size
    :: FF_size=$teacher_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@