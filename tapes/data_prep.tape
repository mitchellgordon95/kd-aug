# Prepare the general domain data
task prepare_gd_data calls prepare_data
    < train_src_in=$TRAIN_SRC@general_domain
    < train_trg_in=$TRAIN_TRG@general_domain
    < src_vocab=$SRC_VOCAB@general_domain
    < trg_vocab=$TRG_VOCAB@general_domain
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@

# Prepare the in domain data
task prepare_id_data calls prepare_data
    < train_src_in=$TRAIN_SRC@in_domain
    < train_trg_in=$TRAIN_TRG@in_domain
    < src_vocab=$SRC_VOCAB@general_domain
    < trg_vocab=$TRG_VOCAB@general_domain
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@
