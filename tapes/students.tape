# Train the GD student
task train_gd_student calls train
    < prepared_data=$data@prepare_distilled_gd_data
    < dev_src=$DEV_SRC@general_domain
    < dev_trg=$DEV_TRG@general_domain
    < model_init=/dev/null # Pretty sure ducttape will freak out if we don't have a file here
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Adapt the GD student
task train_adapted_gd_student calls train
    < prepared_data=$data@prepare_id_data
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_gd_student
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Adapt the GD student on distilled id data
task train_daad calls train
    < prepared_data=$data@prepare_distilled_id_with_adapted
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_gd_student
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Train the GD baseline
task train_gd_student_baseline calls train
    < prepared_data=$data@prepare_gd_data
    < dev_src=$DEV_SRC@general_domain
    < dev_trg=$DEV_TRG@general_domain
    < model_init=/dev/null # Pretty sure ducttape will freak out if we don't have a file here
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Adapt the GD baseline 
task train_adapted_gd_student_baseline calls train
    < prepared_data=$data@prepare_id_data
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_gd_student_baseline
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Train ID student
task train_id_student calls train
    < prepared_data=$data@prepare_distilled_id_with_adapted
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=/dev/null
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Train ID baseline student
task train_id_baseline_student calls train
    < prepared_data=$data@prepare_distilled_id_with_baseline_teacher
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=/dev/null
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Train GD student with baseline ID teacher
task train_gdsbt calls train
    < prepared_data=$data@prepare_distilled_id_with_baseline_teacher
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_gd_student
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Train GD baseline with adapted teacher
task train_gdbat calls train
    < prepared_data=$data@prepare_distilled_id_with_adapted
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_gd_student_baseline
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

# Train ID baseline
task train_id_small_baseline calls train
    < prepared_data=$data@prepare_id_data
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=/dev/null
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@