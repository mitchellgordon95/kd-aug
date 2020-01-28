# Continue training the GD student on the gold data
task continue_train_gd_student calls train
    < prepared_data=$data@prepare_distilled_gd_data
    < dev_src=$DEV_SRC@general_domain
    < dev_trg=$DEV_TRG@general_domain
    < model_init=$model@train_gd_student
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

task continue_gd_student_score_train calls score
     < src=$TRAIN_SRC@general_domain
     < trg=$TRAIN_TRG@general_domain
     < model=$model@continue_train_gd_student
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_gd_student_decode_dev calls decode 
    < in=$DEV_SRC@general_domain
    < model=$model@continue_train_gd_student
    > out out_log out_scores
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_gd_student_bleu_dev calls multi_bleu
     < in=$out@continue_gd_student_decode_dev
     < ref=$DEV_TRG@general_domain
     > bleu

# Continue train ID student on the gold ID data
task continue_train_id_student calls train
    < prepared_data=$data@prepare_id_data
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_id_student
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

task continue_id_student_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@continue_train_id_student
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_id_student_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@continue_train_id_student
    > out out_log out_scores
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_id_student_bleu_dev calls multi_bleu
     < in=$out@continue_id_student_decode_dev
     < ref=$DEV_TRG@in_domain
     > bleu

# Continue trainining ID baseline student on the gold data
task continue_train_id_baseline_student calls train
    < prepared_data=$data@prepare_id_data
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_id_baseline_student
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

task continue_id_baseline_student_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@continue_train_id_baseline_student
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_id_baseline_student_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@continue_train_id_baseline_student
    > out out_log out_scores
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_id_baseline_student_bleu_dev calls multi_bleu
     < in=$out@continue_id_baseline_student_decode_dev
     < ref=$DEV_TRG@in_domain
     > bleu

# Continue trainining DAAD on gold data
task continue_train_daad calls train
    < prepared_data=$data@prepare_id_data
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_daad
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

task continue_daad_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@continue_train_daad
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_daad_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@continue_train_daad
    > out out_log out_scores
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_daad_bleu_dev calls multi_bleu
     < in=$out@continue_daad_decode_dev
     < ref=$DEV_TRG@in_domain
     > bleu

# Continue trainining gdsbt on gold data
task continue_train_gdsbt calls train
    < prepared_data=$data@prepare_id_data
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_gdsbt
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

task continue_gdsbt_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@continue_train_gdsbt
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_gdsbt_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@continue_train_gdsbt
    > out out_log out_scores
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_gdsbt_bleu_dev calls multi_bleu
     < in=$out@continue_gdsbt_decode_dev
     < ref=$DEV_TRG@in_domain
     > bleu

# Continue trainining gdbat on gold data
task continue_train_gdbat calls train
    < prepared_data=$data@prepare_id_data
    < dev_src=$DEV_SRC@in_domain
    < dev_trg=$DEV_TRG@in_domain
    < model_init=$model@train_gdbat
    > model
    :: pyenv=@
    :: num_layers=$student_layers
    :: model_size=$student_model_size
    :: embed_size=$student_embed_size
    :: FF_size=$student_FF_size
    :: use_cpu=@
    :: .submitter=@ .resource_flags=$resource_flags_train .action_flags=@

task continue_gdbat_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@continue_train_gdbat
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_gdbat_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@continue_train_gdbat
    > out out_log out_scores
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task continue_gdbat_bleu_dev calls multi_bleu
     < in=$out@continue_gdbat_decode_dev
     < ref=$DEV_TRG@in_domain
     > bleu