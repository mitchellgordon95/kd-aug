# Distill and prepare the GD data
task distill_gd_data calls decode 
    < in="/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.train.bpe.$SRC"
    < model=$model@train_gd_teacher
    > out
    > out_log
    > out_scores
    :: test_beam_size=@
    :: use_cpu=@
    :: pyenv=@
    :: .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 
    
task prepare_distilled_gd_data calls prepare_data
    < train_src_in="/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.train.bpe.$SRC"
    < train_trg_in=$out@distill_gd_data
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@

# Distill and prepare ID data with Adapted Teacher
task distill_id_with_adapted calls decode 
    < in="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC"
    < model=$model@train_adapted_teacher
    > out
    > out_log
    > out_scores
    :: test_beam_size=@
    :: use_cpu=@
    :: pyenv=@
    :: .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode

task prepare_distilled_id_with_adapted calls prepare_data
    < train_src_in="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC"
    < train_trg_in=$out@distill_id_with_adapted
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@


# Distill and prepare ID data with ID teacher
task distill_id_with_baseline_teacher calls decode 
    < in="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC"
    < model=$model@train_id_baseline_teacher
    > out
    > out_log
    > out_scores
    :: test_beam_size=@
    :: use_cpu=@
    :: pyenv=@
    :: .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode

task prepare_distilled_id_with_baseline_teacher calls prepare_data
    < train_src_in="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC"
    < train_trg_in=$out@distill_id_with_baseline_teacher
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@