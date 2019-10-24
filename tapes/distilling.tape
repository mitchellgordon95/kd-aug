# Distill and prepare the GD data
task distill_gd_data calls decode 
    < in=$TRAIN_SRC@general_domain
    < model=$model@train_gd_teacher
    > out
    > out_log
    > out_scores
    :: test_beam_size=@
    :: use_cpu=@
    :: pyenv=@
    :: .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 
    
task prepare_distilled_gd_data calls prepare_data
    < train_src_in=$TRAIN_SRC@general_domain
    < train_trg_in=$out@distill_gd_data
    < src_vocab=$SRC_VOCAB@general_domain
    < trg_vocab=$TRG_VOCAB@general_domain
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@

# Distill and prepare ID data with Adapted Teacher
task distill_id_with_adapted calls decode 
    < in=$TRAIN_SRC@in_domain
    < model=$model@train_adapted_teacher
    > out
    > out_log
    > out_scores
    :: test_beam_size=@
    :: use_cpu=@
    :: pyenv=@
    :: .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode

task prepare_distilled_id_with_adapted calls prepare_data
    < train_src_in=$TRAIN_SRC@in_domain
    < train_trg_in=$out@distill_id_with_adapted
    < src_vocab=$SRC_VOCAB@general_domain
    < trg_vocab=$TRG_VOCAB@general_domain
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@


# Distill and prepare ID data with ID teacher
task distill_id_with_baseline_teacher calls decode 
    < in=$TRAIN_SRC@in_domain
    < model=$model@train_id_baseline_teacher
    > out
    > out_log
    > out_scores
    :: test_beam_size=@
    :: use_cpu=@
    :: pyenv=@
    :: .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode

task prepare_distilled_id_with_baseline_teacher calls prepare_data
    < train_src_in=$TRAIN_SRC@in_domain
    < train_trg_in=$out@distill_id_with_baseline_teacher
    < src_vocab=$SRC_VOCAB@general_domain
    < trg_vocab=$TRG_VOCAB@general_domain
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@