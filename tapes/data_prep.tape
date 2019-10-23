# Prepare the general domain data
task prepare_gd_data calls prepare_data
    < train_src_in="/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.train.bpe.$SRC"
    < train_trg_in="/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.train.bpe.$TRG"
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@

# Prepare the in domain data
task prepare_id_data calls prepare_data
    < train_src_in="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC"
    < train_trg_in="/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$TRG"
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=$submitter .resource_flags=$resource_flags_16g .action_flags=@
