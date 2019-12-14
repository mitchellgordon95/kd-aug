# Distill and prepare the GD data
task chunk_gd_data
    < in=$TRAIN_SRC@general_domain
    > chunkaa > chunkab > chunkac > chunkad > chunkae > chunkaf > chunkag > chunkah {
  chunksize=$(wc -l $in | awk '{print $1}' | xargs -I{} expr {} / 8 + 1)
  split -l $chunksize $in chunk

}
    
task distill_gd_data_chunk1 calls decode 
    < in=$chunkaa@chunk_gd_data
    < model=$model@train_gd_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

task distill_gd_data_chunk2 calls decode 
    < in=$chunkab@chunk_gd_data
    < model=$model@train_gd_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

task distill_gd_data_chunk3 calls decode 
    < in=$chunkac@chunk_gd_data
    < model=$model@train_gd_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

task distill_gd_data_chunk4 calls decode 
    < in=$chunkad@chunk_gd_data
    < model=$model@train_gd_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

task distill_gd_data_chunk5 calls decode 
    < in=$chunkae@chunk_gd_data
    < model=$model@train_gd_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

task distill_gd_data_chunk6 calls decode 
    < in=$chunkaf@chunk_gd_data
    < model=$model@train_gd_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

task distill_gd_data_chunk7 calls decode 
    < in=$chunkag@chunk_gd_data
    < model=$model@train_gd_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

task distill_gd_data_chunk8 calls decode 
    < in=$chunkah@chunk_gd_data
    < model=$model@train_gd_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

task distill_gd_data
    < chunk1=$out@distill_gd_data_chunk1
    < chunk2=$out@distill_gd_data_chunk2
    < chunk3=$out@distill_gd_data_chunk3
    < chunk4=$out@distill_gd_data_chunk4
    < chunk5=$out@distill_gd_data_chunk5
    < chunk6=$out@distill_gd_data_chunk6
    < chunk7=$out@distill_gd_data_chunk7
    < chunk8=$out@distill_gd_data_chunk8
    > out {
    cat $chunk1 $chunk2 $chunk3 $chunk4 $chunk5 $chunk6 $chunk7 $chunk8 > $out
}
    
task prepare_distilled_gd_data calls prepare_data
    < train_src_in=$TRAIN_SRC@general_domain
    < train_trg_in=$out@distill_gd_data
    < src_vocab=$SRC_VOCAB@general_domain
    < trg_vocab=$TRG_VOCAB@general_domain
    > data
    :: pyenv=@
    :: train_max_sent_length=$MaxLen
    :: seed=1235813
    :: .submitter=@ .resource_flags=$resource_flags_decode .action_flags=@

# Distill and prepare ID data with Adapted Teacher
task distill_id_with_adapted calls decode 
    < in=$TRAIN_SRC@in_domain
    < model=$model@train_adapted_teacher
    > out
    > out_log
    > out_scores
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
    :: .submitter=@ .resource_flags=$resource_flags_decode .action_flags=@


# Distill and prepare ID data with ID teacher
task distill_id_with_baseline_teacher calls decode 
    < in=$TRAIN_SRC@in_domain
    < model=$model@train_id_baseline_teacher
    > out
    > out_log
    > out_scores
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
    :: .submitter=@ .resource_flags=$resource_flags_decode .action_flags=@